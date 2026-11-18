const getEventData = require('getEventData');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const makeInteger = require('makeInteger');
const Object = require('Object');

const variableType = data.variableType;
const jsonData = data.jsonData;
const isFirstClick = data.attributionType === 'firstClickAttribution';

// Item List & Promotion parameters that carry attribution (event-level and item-level)
const ATTRIBUTION_KEYS = ['item_list_id', 'item_list_name', 'promotion_id', 'promotion_name',
                          'creative_name', 'creative_slot', 'location_id', 'index'];
const PROMOTION_KEYS = ['promotion_id', 'promotion_name', 'creative_name', 'creative_slot', 'location_id'];
// Parameters that tell that an Item List or Promotion is implemented on the event or item
const LIST_PROMO_KEYS = ['item_list_id', 'item_list_name', 'promotion_id', 'promotion_name',
                         'creative_name', 'creative_slot'];

// ==========================================
// HELPERS
// ==========================================
function hasValue(v) { return v !== undefined && v !== null && v !== ''; }
function isMissing(v) { return !hasValue(v); }

function currentOrStored(current, stored) {
  if (hasValue(current)) return current;
  if (hasValue(stored)) return stored;
  return undefined;
}

function parseIfString(v) {
  return getType(v) === 'string' ? JSON.parse(v) : v;
}

function positiveInteger(v) {
  if (isMissing(v)) return undefined;
  const n = makeInteger(v);
  return (n && n > 0) ? n : undefined;
}

// Missing values are always returned as undefined, never as null or an empty string
function valueOrUndefined(v) {
  return hasValue(v) ? v : undefined;
}

function eventValue(key) {
  return valueOrUndefined(getEventData(key));
}

function hasAttributionData(obj) {
  for (let i = 0; i < ATTRIBUTION_KEYS.length; i++) {
    if (hasValue(obj[ATTRIBUTION_KEYS[i]])) return true;
  }
  return false;
}

function hasListOrPromoData(obj) {
  for (let i = 0; i < LIST_PROMO_KEYS.length; i++) {
    if (hasValue(obj[LIST_PROMO_KEYS[i]])) return true;
  }
  return false;
}

// Placeholders stored when there is no data, so the stored structure always has the same shape
function emptyItems() { return [{item_id: 'helper_id'}]; }
function emptyCustomEvents() { return {helper_prop: 'helper_val'}; }

const event_name = getEventData('event_name');
const items = getEventData('items');
const customItemAttributeParameters = data.customItemAttributeParameters || [];
const customEventAttributeParameters = data.customEventAttributeParameters || [];

// "Location ID Value": used as location_id where an Item List or Promotion is implemented without
// a location_id (ex. Page Path for web, screen name for app). Never added to anything else, so
// ex. add_to_cart from a product page gets no location_id.
// The field has its own name on the output variables, where it is only shown for Items and Location ID.
const locationIdValue = valueOrUndefined(variableType === 'output' ? data.locationIdValueOutput : data.locationIdValue);

// ==========================================
// TRIGGER HELPER
// Returns true when the event can change the stored attribution data.
// Runs before any stored data is handled, since it never needs the Second Data Source.
// ==========================================
if (variableType === 'check_trigger') {
  // purchase always passes, so "Delete Attribution Data after Purchase" only has to be ticked
  // in the "Extract" variable. The trigger's Event Name condition decides if purchase is included.
  if (event_name === 'purchase') return true;

  for (let i = 0; i < ATTRIBUTION_KEYS.length; i++) {
    if (hasValue(getEventData(ATTRIBUTION_KEYS[i]))) return true;
  }

  if (data.siteSearchChecbox && hasValue(getEventData('search_term'))) return true;

  for (let i = 0; i < customEventAttributeParameters.length; i++) {
    if (hasValue(customEventAttributeParameters[i].parameterValue)) return true;
  }

  if (items && items.length > 0) {
    for (let i = 0; i < items.length; i++) {
      const itm = items[i];
      if (hasAttributionData(itm)) return true;
      for (let j = 0; j < customItemAttributeParameters.length; j++) {
        const p = customItemAttributeParameters[j].parameterName;
        if (hasValue(p) && hasValue(itm[p])) return true;
      }
    }
  }

  return false;
}

// ==========================================
// 1. NORMALIZE STORED DATA
// Handles a JSON string, an array wrapper (Firestore query) or an {id, data} wrapper (Stape Data Store).
// ==========================================
// The wrappers can be combined, ex. an array that contains a JSON string.
function unwrapStored(v, depth) {
  v = parseIfString(v);
  if (getType(v) === 'array') {
    return (depth < 4 && v.length > 0) ? unwrapStored(v[0], depth + 1) : undefined;
  }
  if (getType(v) === 'object' && hasValue(v.data) && depth < 4) {
    const inner = unwrapStored(v.data, depth + 1);
    if (inner) return inner;
  }
  return getType(v) === 'object' ? v : undefined;
}

const secondDataSource = unwrapStored(data.secondDataSource, 0);

let items2 = (secondDataSource && getType(secondDataSource.items) === 'array') ? secondDataSource.items : emptyItems();
let promo2 = (secondDataSource && getType(secondDataSource.promotion) === 'object') ? secondDataSource.promotion : null;
let searchTerm2 = (secondDataSource && hasValue(secondDataSource.search_term)) ? secondDataSource.search_term : null;
let customEvents2 = (secondDataSource && getType(secondDataSource.custom_events) === 'object') ? secondDataSource.custom_events : emptyCustomEvents();

// ==========================================
// 2. SESSION ID (Web & App)
// Web (gtag.js):  ga_session_id is a top-level event parameter.
// App (Firebase): the session id is sent as a user property, so in sGTM it is found
//                 inside x-ga-mp2-user_properties (as session_id, ga_session_id or _sid).
// A user property value can be a plain value or an object like {value: ...}.
// ==========================================
function toSessionId(v) {
  if (getType(v) === 'object') {
    v = hasValue(v.value) ? v.value :
        hasValue(v.int_value) ? v.int_value :
        hasValue(v.string_value) ? v.string_value : undefined;
  }
  return positiveInteger(v);
}

function getSessionId() {
  let sid = toSessionId(getEventData('ga_session_id'));
  if (sid) return sid;

  sid = toSessionId(getEventData('session_id'));
  if (sid) return sid;

  const userProps = getEventData('x-ga-mp2-user_properties');
  if (getType(userProps) === 'object') {
    const keys = ['session_id', 'ga_session_id', '_sid'];
    for (let i = 0; i < keys.length; i++) {
      sid = toSessionId(userProps[keys[i]]);
      if (sid) return sid;
    }
  }
  return undefined;
}

const sessionId = getSessionId();

// ==========================================
// 3. ATTRIBUTION WINDOW
// "attribution" uses this variable's own settings.
// "output" has no attribution settings in the UI, so it follows the settings
// the attribution variable stored together with the data (attribution_time).
// ==========================================
let customMinutes;
if (variableType === 'output') {
  customMinutes = secondDataSource ? positiveInteger(secondDataSource.attribution_time) : undefined;
} else if (data.customAttributionTime !== false) {
  customMinutes = positiveInteger(data.attributionTime);
}

const timestamp = getTimestampMillis();
const SESSION_TIMEOUT_MS = 30 * 60 * 1000;
// Older versions stored the session id (seconds) as "timestamp". Values below this limit are seconds.
const LEGACY_SECONDS_LIMIT = 100000000000;

let storedTs;
let storedSessionId;
if (secondDataSource) {
  const rawTs = positiveInteger(secondDataSource.timestamp);
  if (rawTs) {
    if (rawTs < LEGACY_SECONDS_LIMIT) {
      storedSessionId = rawTs;
      storedTs = rawTs * 1000;
    } else {
      storedTs = rawTs;
    }
  }
  const sSid = toSessionId(secondDataSource.session_id);
  if (sSid) storedSessionId = sSid;
}

let isExpired = false;
if (secondDataSource) {
  if (customMinutes) {
    // Custom attribution time, counted from the last attribution update
    if (storedTs && (timestamp - storedTs) > customMinutes * 60000) isExpired = true;
  } else if (sessionId && storedSessionId) {
    // GA4 session attribution: expires when the session changes
    if (sessionId !== storedSessionId) isExpired = true;
  } else if (storedTs) {
    // Session id missing on one side: fall back to 30 minutes of inactivity
    if ((timestamp - storedTs) > SESSION_TIMEOUT_MS) isExpired = true;
  }
}

if (isExpired) {
  items2 = emptyItems();
  promo2 = null;
  searchTerm2 = null;
  customEvents2 = emptyCustomEvents();
}

// ==========================================
// ATTRIBUTION
// ==========================================
if (variableType === 'attribution') {
  // Every extract is stored with the same structure and meta fields
  const buildExtract = (itemsOut, promotionOut, searchTermOut, customEventsOut, timestampOut) => {
    const extract = {
      items: itemsOut,
      promotion: promotionOut,
      search_term: searchTermOut,
      custom_events: customEventsOut,
      timestamp: timestampOut,
      session_id: sessionId || null,
      attribution_time: customMinutes || null
    };
    return jsonData ? JSON.stringify(extract) : extract;
  };

  // Last click always takes the new value, first click only fills what is missing
  const setAttributed = (target, key, value) => {
    if (hasValue(value) && (!isFirstClick || isMissing(target[key]))) target[key] = value;
  };

  // 1. Purchase reset
  if (data.deleteAttribution === true && event_name === 'purchase') {
    return buildExtract(emptyItems(), null, null, emptyCustomEvents(), timestamp);
  }

  const eventLevel = {};
  ATTRIBUTION_KEYS.forEach(k => { eventLevel[k] = eventValue(k); });

  // Custom event parameters: stored values merged with the values on this event
  const currentCustomEvents = {};
  customEventAttributeParameters.forEach(row => {
    if (hasValue(row.parameterName) && hasValue(row.parameterValue)) {
      currentCustomEvents[row.parameterName] = row.parameterValue;
    }
  });
  const hasNewCustomEvents = Object.keys(currentCustomEvents).length > 0;

  let mergedCustomEvents = {};
  Object.keys(customEvents2).forEach(k => {
    if (k !== 'helper_prop') mergedCustomEvents[k] = customEvents2[k];
  });
  Object.keys(currentCustomEvents).forEach(k => {
    if (!isFirstClick || isMissing(mergedCustomEvents[k])) mergedCustomEvents[k] = currentCustomEvents[k];
  });
  if (Object.keys(mergedCustomEvents).length === 0) mergedCustomEvents = emptyCustomEvents();

  // Incoming items: only items with attribution data are kept. Item-level values trump event-level values.
  const items1 = [];
  if (items && items.length > 0) {
    for (let idx = 0; idx < items.length; idx++) {
      const i = items[idx];
      const itemObj = {item_id: i.item_id};
      ATTRIBUTION_KEYS.forEach(k => { itemObj[k] = hasValue(i[k]) ? i[k] : eventLevel[k]; });
      if (locationIdValue && isMissing(itemObj.location_id) && hasListOrPromoData(itemObj)) {
        itemObj.location_id = locationIdValue;
      }

      let itemHasAttribution = hasValue(itemObj.item_id) && hasAttributionData(itemObj);

      for (let j = 0; j < customItemAttributeParameters.length; j++) {
        const p = customItemAttributeParameters[j].parameterName;
        if (hasValue(p) && hasValue(i[p])) {
          itemObj[p] = i[p];
          if (hasValue(itemObj.item_id)) itemHasAttribution = true;
        }
      }

      if (itemHasAttribution) items1.push(itemObj);
    }
  }

  // 2. Item-level attribution branch
  if (items1.length > 0) {
    const mergedMap = {};
    let orderedKeys = [];

    // Stored items first, in stored order
    for (let i = 0; i < items2.length; i++) {
      const oldRec = items2[i];
      if (!oldRec || oldRec.item_id === 'helper_id' || !hasValue(oldRec.item_id)) continue;

      const idKey = 'item_' + oldRec.item_id;
      if (!mergedMap[idKey]) orderedKeys.push(idKey);

      const clone = {};
      Object.keys(oldRec).forEach(k => { clone[k] = oldRec[k]; });
      mergedMap[idKey] = clone;
    }

    items1.forEach(rec1 => {
      const id = rec1.item_id;
      if (id === 'helper_id') return;
      const idKey = 'item_' + id;

      let tgt = mergedMap[idKey];
      if (!tgt) {
        tgt = {item_id: id};
        orderedKeys.push(idKey);
      } else if (!isFirstClick) {
        // Last click: move the item to the end, so the newest items survive "Limit Items"
        orderedKeys = orderedKeys.filter(k => k !== idKey);
        orderedKeys.push(idKey);
      }

      // Item list id & name are handled as a pair
      if (hasValue(rec1.item_list_id) || hasValue(rec1.item_list_name)) {
        if (isFirstClick) {
          if (isMissing(tgt.item_list_id)) tgt.item_list_id = rec1.item_list_id;
          if (isMissing(tgt.item_list_name)) tgt.item_list_name = rec1.item_list_name;
        } else {
          tgt.item_list_id = rec1.item_list_id;
          tgt.item_list_name = rec1.item_list_name;
        }
      }

      // Promotion identity (id & name) is handled as a pair with last click, independent of the creative
      if (isFirstClick) {
        setAttributed(tgt, 'promotion_id', rec1.promotion_id);
        setAttributed(tgt, 'promotion_name', rec1.promotion_name);
      } else if (hasValue(rec1.promotion_id) || hasValue(rec1.promotion_name)) {
        tgt.promotion_id = rec1.promotion_id;
        tgt.promotion_name = rec1.promotion_name;
      }
      setAttributed(tgt, 'creative_name', rec1.creative_name);
      setAttributed(tgt, 'creative_slot', rec1.creative_slot);
      setAttributed(tgt, 'location_id', rec1.location_id);
      setAttributed(tgt, 'index', rec1.index);

      customItemAttributeParameters.forEach(row => {
        setAttributed(tgt, row.parameterName, rec1[row.parameterName]);
      });

      mergedMap[idKey] = tgt;
    });

    if (data.limitItems !== false && data.limitItemsNumber) {
      const limit = makeInteger(data.limitItemsNumber);
      if (limit > 0 && orderedKeys.length > limit) {
        orderedKeys = isFirstClick ? orderedKeys.slice(0, limit) : orderedKeys.slice(-limit);
      }
    }

    let uniqueItems = orderedKeys.map(k => mergedMap[k]);
    if (uniqueItems.length === 0) uniqueItems = emptyItems();

    return buildExtract(uniqueItems, promo2, searchTerm2, mergedCustomEvents, timestamp);
  }

  // 3. Event-level promotion attribution branch
  if (eventLevel.promotion_id || eventLevel.promotion_name || eventLevel.creative_name || eventLevel.creative_slot) {
    const promo = {};
    PROMOTION_KEYS.forEach(k => { promo[k] = eventLevel[k]; });
    if (locationIdValue && isMissing(promo.location_id)) promo.location_id = locationIdValue;
    const promoAttribution = (isFirstClick && promo2) ? promo2 : promo;
    return buildExtract(items2, promoAttribution, searchTerm2, mergedCustomEvents, timestamp);
  }

  // 4. Site search attribution branch
  const searchTerm = data.siteSearchChecbox ? eventValue('search_term') : undefined;
  if (searchTerm) {
    const searchTermAttribution = (isFirstClick && searchTerm2) ? searchTerm2 : searchTerm;
    return buildExtract(items2, promo2, searchTermAttribution, mergedCustomEvents, timestamp);
  }

  // 5. Custom event parameters attribution branch
  if (hasNewCustomEvents) {
    return buildExtract(items2, promo2, searchTerm2, mergedCustomEvents, timestamp);
  }

  // 6. Nothing new to attribute: keep the previous update time, so the attribution window is not renewed
  const unchangedTimestamp = (!isExpired && storedTs) ? storedTs : timestamp;
  return buildExtract(items2, promo2, searchTerm2, mergedCustomEvents, unchangedTimestamp);
}

// ==========================================
// OUTPUT
// ==========================================
if (variableType === 'output') {
  const param = data.outputDropDown;

  // Is an Item List or Promotion implemented on the event-level of this event?
  let eventHasListOrPromo = false;
  if (locationIdValue) {
    for (let i = 0; i < LIST_PROMO_KEYS.length; i++) {
      if (hasValue(getEventData(LIST_PROMO_KEYS[i]))) eventHasListOrPromo = true;
    }
  }

  // The location of this event trumps the stored location
  if (param === 'location_id' && eventHasListOrPromo) return locationIdValue;

  if (PROMOTION_KEYS.indexOf(param) !== -1) {
    return promo2 ? valueOrUndefined(promo2[param]) : undefined;
  }

  if (param === 'search_term') {
    return valueOrUndefined(searchTerm2);
  }

  if (param === 'custom_event') {
    const requestedKey = data.customEventOutputKey;
    return (requestedKey && requestedKey !== 'helper_prop') ? valueOrUndefined(customEvents2[requestedKey]) : undefined;
  }

  if (param === 'items' && getType(items) === 'array') {
    const standardKeys = ['item_id'].concat(ATTRIBUTION_KEYS);

    items.forEach(item => {
      // An Item List or Promotion implemented on this event gets the location of this event,
      // before stored data is merged in.
      if (locationIdValue && isMissing(item.location_id) && (eventHasListOrPromo || hasListOrPromoData(item))) {
        item.location_id = locationIdValue;
      }

      if (data.itemSearchTerm && searchTerm2) {
        item.search_term = searchTerm2;
      }

      if (data.itemCustomEvents) {
        Object.keys(customEvents2).forEach(k => {
          if (k !== 'helper_prop') item[k] = currentOrStored(item[k], customEvents2[k]);
        });
      }

      // Implemented item data trumps stored item data
      items2.forEach(item2 => {
        if (item2 && item2.item_id !== 'helper_id' && ('' + item.item_id === '' + item2.item_id)) {
          ATTRIBUTION_KEYS.forEach(k => { item[k] = currentOrStored(item[k], item2[k]); });

          // Custom item parameters
          Object.keys(item2).forEach(k => {
            if (standardKeys.indexOf(k) === -1) item[k] = currentOrStored(item[k], item2[k]);
          });
        }
      });

      // Event-level promotion -> items.
      // GA4 copies event-level promotion_id/name and creative_name/slot to items, but not location_id.
      // Only items without their own promotion get the stored promotion, so item-level promotions are never mixed.
      if (data.itemPromotion && promo2) {
        const itemHasPromo = hasValue(item.promotion_id) || hasValue(item.promotion_name) ||
                             hasValue(item.creative_name) || hasValue(item.creative_slot);
        const samePromo = (hasValue(item.promotion_id) && hasValue(promo2.promotion_id) && ('' + item.promotion_id === '' + promo2.promotion_id)) ||
                          (hasValue(item.promotion_name) && hasValue(promo2.promotion_name) && ('' + item.promotion_name === '' + promo2.promotion_name));
        if (!itemHasPromo) {
          PROMOTION_KEYS.forEach(k => { item[k] = currentOrStored(item[k], promo2[k]); });
        } else if (samePromo) {
          item.location_id = currentOrStored(item.location_id, promo2.location_id);
        }
      }
    });
    return items;
  }
}
