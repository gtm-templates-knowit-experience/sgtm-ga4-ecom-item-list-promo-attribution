___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "displayName": "GA4 - Item List \u0026 Promotion Attribution",
  "description": "Attribute GA4 Item Lists, Promotions, Search Terms, and Custom Parameters to ecommerce and other events using Firestore/Stape Store. Last \u0026 First Click Attribution supported.",
  "categories": [
    "ANALYTICS",
    "UTILITY",
    "TAG_MANAGEMENT"
  ],
  "containerContexts": [
    "SERVER"
  ],
  "securityGroups": []
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "LABEL",
    "name": "introLabel",
    "displayName": "Extract \u0026 Attribute GA4 Item List \u0026 Promotion data, or merge Item List \u0026 Promotion Data from Second Data Source."
  },
  {
    "type": "GROUP",
    "name": "variableTypeGroup",
    "displayName": "Variable Type",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "RADIO",
        "name": "variableType",
        "displayName": "Create Attribution or Return Attributed Output",
        "radioItems": [
          {
            "value": "attribution",
            "displayValue": "Extract Item List \u0026 Promotion for Attribution",
            "help": "Choose this setting for extracting Item List \u0026 Promotion data, create the attribution, and for storing this data in a Second Data Source (ex. Firestore)."
          },
          {
            "value": "output",
            "displayValue": "Return Attributed Output",
            "help": "Choose this setting for merging ecommerce data with attributed data from Second Data Source (ex.Firestore)."
          },
          {
            "value": "check_trigger",
            "displayValue": "Trigger Helper (Check for new attribution data)",
            "help": "Evaluates the incoming event and returns \u0027true\u0027 if it contains new attribution data (item lists, promotions, search terms, or custom parameters). Use this variable in your GTM Triggers to prevent unnecessary database reads on events with no attribution data."
          }
        ],
        "simpleValueType": true
      },
      {
        "type": "GROUP",
        "name": "outputGroup",
        "displayName": "Output",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "SELECT",
            "name": "outputDropDown",
            "displayName": "Parameter Output",
            "selectItems": [
              {
                "value": "items",
                "displayValue": "Items"
              },
              {
                "value": "promotion_name",
                "displayValue": "Promotion Name"
              },
              {
                "value": "promotion_id",
                "displayValue": "Promotion ID"
              },
              {
                "value": "creative_name",
                "displayValue": "Creative Name"
              },
              {
                "value": "creative_slot",
                "displayValue": "Creative Slot"
              },
              {
                "value": "location_id",
                "displayValue": "Location ID"
              },
              {
                "value": "search_term",
                "displayValue": "Search Term"
              },
              {
                "value": "custom_event",
                "displayValue": "Custom Event Parameter"
              }
            ],
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "variableType",
                "paramValue": "output",
                "type": "EQUALS"
              }
            ],
            "alwaysInSummary": true
          },
          {
            "type": "TEXT",
            "name": "customEventOutputKey",
            "displayName": "Custom Parameter Name",
            "simpleValueType": true,
            "valueHint": "E.g., search_category",
            "enablingConditions": [
              {
                "paramName": "outputDropDown",
                "paramValue": "custom_event",
                "type": "EQUALS"
              }
            ],
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          },
          {
            "type": "CHECKBOX",
            "name": "itemSearchTerm",
            "checkboxText": "Add Search Term To Items",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "outputDropDown",
                "paramValue": "items",
                "type": "EQUALS"
              }
            ],
            "help": "If you tick this checkbox, \u003cstrong\u003esearch_term\u003c/strong\u003e will be added to \u003cstrong\u003eitems\u003c/strong\u003e. This makes it easier to report search_term related to items purchased.\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cstrong\u003esearch_term\u003c/strong\u003e should be added in GA4 as an \u003cstrong\u003eitem scoped dimension\u003c/strong\u003e."
          },
          {
            "type": "CHECKBOX",
            "name": "itemCustomEvents",
            "checkboxText": "Add Custom Event Parameters to Items",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "outputDropDown",
                "paramValue": "items",
                "type": "EQUALS"
              }
            ],
            "help": "If checked, any Custom Event parameters you stored will be stamped directly onto every product inside the items array during the output phase."
          }
        ],
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "output",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "secondDataSourceGroup",
    "displayName": "Second Data Source",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "secondDataSource",
        "displayName": "Second Data Source",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "Insert  variable with Second Data Source (ex. Firestore) in this field",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "variableType",
        "paramValue": "attribution",
        "type": "EQUALS"
      },
      {
        "paramName": "variableType",
        "paramValue": "output",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "LABEL",
    "name": "attributionLabel"
  },
  {
    "type": "GROUP",
    "name": "attributionGroup",
    "displayName": "Attribution",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "deleteAttribution",
        "checkboxText": "Delete Attribution Data after Purchase",
        "simpleValueType": true,
        "alwaysInSummary": true,
        "help": "Tick this box if you want attribution data to be deleted/reset after \u003cstrong\u003epurchase\u003c/strong\u003e.",
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "attribution",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "CHECKBOX",
        "name": "customAttributionTime",
        "checkboxText": "Custom Attribution Time",
        "simpleValueType": true,
        "help": "As standard, attribution time is the same as a \u003cstrong\u003e\u003ca href\u003d\"https://support.google.com/analytics/answer/9191807\" target\u003d\"_blank\"\u003eGA4 Session\u003c/a\u003e\u003c/strong\u003e, but you can choose a \u003cstrong\u003ecustom attribution time\u003c/strong\u003e if that better fits your users behaviour.",
        "alwaysInSummary": true,
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "attribution",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "attributionTime",
        "displayName": "Attribution Time in Minutes",
        "simpleValueType": true,
        "valueUnit": "minutes",
        "help": "How many minutes should \u003cstrong\u003eItem Lists\u003c/strong\u003e or \u003cstrong\u003ePromotion\u003c/strong\u003e being credited to a conversion?\n\u003cbr /\u003e\u003cbr /\u003e\nNote that each \u003cstrong\u003eselect_item\u003c/strong\u003e, \u003cstrong\u003eselect_promotion\u003c/strong\u003e or \u003cstrong\u003eadd_to_cart\u003c/strong\u003e Event will renew the attribution time (if these Events contains Item List or Promotion data).",
        "defaultValue": 30,
        "alwaysInSummary": true,
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          },
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "valueHint": "30",
        "enablingConditions": [
          {
            "paramName": "customAttributionTime",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "RADIO",
        "name": "attributionType",
        "displayName": "Attribution Type",
        "radioItems": [
          {
            "value": "lastClickAttribution",
            "displayValue": "Last Click Attribution"
          },
          {
            "value": "firstClickAttribution",
            "displayValue": "First Click Attribution"
          }
        ],
        "simpleValueType": true,
        "help": "\u003cstrong\u003eLast Click Attribution\u003c/strong\u003e \u003cbr /\u003e\nWith Last Click Attribution, the Last Click on an Item List or a Promotion will be attributed.\n\u003cbr /\u003e\nItem List and Promotion attribution are independent of each other.\n\u003cbr /\u003e\u003cbr /\u003e\nSee \u003ca href\u003d\"https://github.com/gtm-templates-knowit-experience/sgtm-ga4-item-list-promo-attribution\" target\u003d\"_blank\"\u003e\u003cstrong\u003ethe documentation\u003c/strong\u003e\u003c/a\u003e for detailed explanation of attribution.\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cstrong\u003eFirst Click Attribution\u003c/strong\u003e \u003cbr /\u003e\nWith First Click Attribution, the First Click on an Item List or a Promotion will be attributed.\n\u003cbr /\u003e\nItem List and Promotion attribution are independent of each other.",
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "attribution",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "siteSearchGroup",
        "displayName": "Site Search",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "siteSearchChecbox",
            "checkboxText": "Attribute Site Search",
            "simpleValueType": true,
            "help": "Attribute the \u003cstrong\u003esearch_term\u003c/strong\u003e parameter.",
            "alwaysInSummary": true
          }
        ],
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "attribution",
            "type": "EQUALS"
          },
          {
            "paramName": "variableType",
            "paramValue": "check_trigger",
            "type": "EQUALS"
          }
        ]
      },
      {
        "type": "GROUP",
        "name": "otherAttributionGroup",
        "displayName": "Custom Parameter Attribution",
        "groupStyle": "ZIPPY_OPEN_ON_PARAM",
        "subParams": [
          {
            "type": "SIMPLE_TABLE",
            "name": "customItemAttributeParameters",
            "displayName": "Item Parameters",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Parameter Name",
                "name": "parameterName",
                "type": "TEXT",
                "isUnique": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ],
                "valueHint": "item_color"
              }
            ],
            "newRowButtonText": "Add Custom Item Parameter",
            "help": "Add the exact keys of any custom item-scoped parameters present in your incoming ecommerce items array that you want to store and attribute (e.g., \u003cb\u003eitem_variant_id\u003c/b\u003e, \u003cb\u003eitem_color\u003c/b\u003e).\n\u003cbr /\u003e\u003cbr /\u003e\nEnter the parameter key exactly as it appears inside your incoming items array.",
            "enablingConditions": [
              {
                "paramName": "variableType",
                "paramValue": "attribution",
                "type": "EQUALS"
              },
              {
                "paramName": "variableType",
                "paramValue": "check_trigger",
                "type": "EQUALS"
              }
            ]
          },
          {
            "type": "SIMPLE_TABLE",
            "name": "customEventAttributeParameters",
            "displayName": "Event Parameters",
            "simpleTableColumns": [
              {
                "defaultValue": "",
                "displayName": "Parameter Name",
                "name": "parameterName",
                "type": "TEXT",
                "valueHint": "search_category",
                "isUnique": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              },
              {
                "defaultValue": "",
                "displayName": "Parameter Value",
                "name": "parameterValue",
                "type": "SELECT",
                "selectItems": [],
                "macrosInSelect": true,
                "valueValidators": [
                  {
                    "type": "NON_EMPTY"
                  }
                ]
              }
            ],
            "help": "Add any custom event-scoped parameters you want to store and attribute (e.g., \u003cb\u003esearch_category\u003c/b\u003e). You must define the parameter name and map its value using a GTM variable.\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cb\u003eParameter Name\u003c/b\u003e\n\u003cbr /\u003e\nEnter the exact name of the parameter as you want it to appear in your final output (e.g., \u003cb\u003esearch_category\u003c/b\u003e).\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cb\u003eParameter Value\u003c/b\u003e\n\u003cbr /\u003e\nSelect the GTM variable from the dropdown that contains this value (e.g., \u003cb\u003e{{search_category - Event Data}}\u003c/b\u003e).",
            "newRowButtonText": "Add Custom Event Parameter",
            "enablingConditions": [
              {
                "paramName": "variableType",
                "paramValue": "attribution",
                "type": "EQUALS"
              },
              {
                "paramName": "variableType",
                "paramValue": "check_trigger",
                "type": "EQUALS"
              }
            ]
          }
        ],
        "enablingConditions": [
          {
            "paramName": "variableType",
            "paramValue": "attribution",
            "type": "EQUALS"
          },
          {
            "paramName": "variableType",
            "paramValue": "check_trigger",
            "type": "EQUALS"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "variableType",
        "paramValue": "attribution",
        "type": "EQUALS"
      },
      {
        "paramName": "variableType",
        "paramValue": "check_trigger",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "otherSettingsGroup",
    "displayName": "Other Settings",
    "groupStyle": "ZIPPY_OPEN_ON_PARAM",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "jsonData",
        "checkboxText": "Handle data as string",
        "simpleValueType": true,
        "help": "Tick this box, and data will be saved as a string using \u003cstrong\u003eJSON.stringify\u003c/strong\u003e, and read will be done using \u003cstrong\u003eJSON.parse\u003c/strong\u003e. \n\u003cbr /\u003e\u003cbr /\u003e\nChoose this setting if you ex. are storing the data in a cookie."
      },
      {
        "type": "GROUP",
        "name": "limitItemsGroup",
        "groupStyle": "NO_ZIPPY",
        "subParams": [
          {
            "type": "CHECKBOX",
            "name": "limitItems",
            "checkboxText": "Limit Items",
            "simpleValueType": true,
            "help": "Some storages can be limited in size. If you choose to store data in ex. a cookie, you should limit number of items stored."
          },
          {
            "type": "TEXT",
            "name": "limitItemsNumber",
            "displayName": "Number of Items",
            "simpleValueType": true,
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              },
              {
                "type": "POSITIVE_NUMBER"
              }
            ],
            "enablingConditions": [
              {
                "paramName": "limitItems",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "valueHint": "2",
            "valueUnit": "item(s)"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "variableType",
        "paramValue": "attribution",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const getEventData = require('getEventData');
const getTimestampMillis = require('getTimestampMillis');
const getType = require('getType');
const JSON = require('JSON');
const makeInteger = require('makeInteger');
const Object = require('Object');

const jsonData = data.jsonData;

// 1. Defensively normalize incoming stored data (handles string, array wrapper, or {id, data} wrapper)
let parsedSource = getType(data.secondDataSource) === 'string' ? JSON.parse(data.secondDataSource) : data.secondDataSource;

if (getType(parsedSource) === 'array') {
  parsedSource = parsedSource.length > 0 ? parsedSource[0] : undefined;
}

const secondDataSource = (parsedSource && getType(parsedSource.data) === 'object')  ? parsedSource.data  : parsedSource;

const event_name = getEventData('event_name');
const items = getEventData('items');
let items2 = (secondDataSource && getType(secondDataSource.items) === 'array') ? secondDataSource.items : [{item_id: "helper_id"}];
let promo2 = (secondDataSource && getType(secondDataSource.promotion) === 'object') ? secondDataSource.promotion : null;
let searchTerm2 = (secondDataSource && hasValue(secondDataSource.search_term)) ? secondDataSource.search_term : null;
let customEvents2 = (secondDataSource && getType(secondDataSource.custom_events) === 'object') ? secondDataSource.custom_events : {helper_prop: "helper_val"};

const timestamp = data.attributionTime ? getTimestampMillis() : makeInteger(getEventData('ga_session_id'));
const timestamp2 = (secondDataSource && secondDataSource.timestamp) ? secondDataSource.timestamp : timestamp;
const timestampDiff = (secondDataSource && secondDataSource.timestamp && data.attributionTime) ? (timestamp - secondDataSource.timestamp) : timestamp;
const attributionTime = data.attributionTime ? (makeInteger(data.attributionTime) * 60000) : timestamp2;
const attributionType = data.attributionType;
const limitItemsNumber = data.limitItemsNumber;

const customItemAttributeParameters = data.customItemAttributeParameters || [];
const customEventAttributeParameters = data.customEventAttributeParameters || [];

function hasValue(v) { return v !== undefined && v !== null && v !== ''; }
function isMissing(v) { return v === undefined || v === null || v === ''; }

function currentOrStored(current, stored) {
  if (hasValue(current)) return current;
  if (hasValue(stored)) return stored;
  return undefined;
}

// Window expiration: Write explicit nulls so merge writes clear expired values
if (timestampDiff > attributionTime) {
  items2 = [{item_id: "helper_id"}];
  promo2 = null;
  searchTerm2 = null;
  customEvents2 = {helper_prop: "helper_val"};
}

// ==========================================
// TRIGGER HELPER
// ==========================================
if (data.variableType === 'check_trigger') {
  let triggerResult = false;
  
  if (data.deleteAttribution === true && event_name === 'purchase') {
    triggerResult = true;
  }
  else if (hasValue(getEventData('item_list_id')) || hasValue(getEventData('item_list_name')) || 
           hasValue(getEventData('promotion_id')) || hasValue(getEventData('promotion_name')) ||
           hasValue(getEventData('creative_name')) || hasValue(getEventData('creative_slot')) ||
           hasValue(getEventData('location_id')) || hasValue(getEventData('index'))) {
    triggerResult = true;
  }
  else if (data.siteSearchChecbox && hasValue(getEventData('search_term'))) {
    triggerResult = true;
  }
  else if (customEventAttributeParameters.length > 0) {
    for (let i = 0; i < customEventAttributeParameters.length; i++) {
      if (hasValue(customEventAttributeParameters[i].parameterValue)) {
        triggerResult = true;
        break;
      }
    }
  }
  
  if (!triggerResult && items && items.length > 0) {
    for (let i = 0; i < items.length; i++) {
      let itm = items[i];
      if (hasValue(itm.item_list_id) || hasValue(itm.item_list_name) ||
          hasValue(itm.promotion_id) || hasValue(itm.promotion_name) ||
          hasValue(itm.creative_name) || hasValue(itm.creative_slot) ||
          hasValue(itm.location_id) || hasValue(itm.index)) {
        triggerResult = true;
        break;
      }
      if (customItemAttributeParameters.length > 0) {
        for (let j = 0; j < customItemAttributeParameters.length; j++) {
          let p = customItemAttributeParameters[j].parameterName;
          if (hasValue(p) && hasValue(itm[p])) {
            triggerResult = true;
            break;
          }
        }
        if (triggerResult) break;
      }
    }
  }
  
  return triggerResult;
}

// ==========================================
// ATTRIBUTION
// ==========================================
if (data.variableType === 'attribution') { 
  // 1. Purchase Reset: Explicit nulls guarantee removal under merge: true writes
  if (data.deleteAttribution === true && event_name === 'purchase') {
    let resetExtract = {
      search_term: null, 
      custom_events: {helper_prop: "helper_val"}, 
      items: [{item_id: "helper_id"}], 
      promotion: null, 
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(resetExtract) : resetExtract;
  }

  let item_list_id = hasValue(getEventData('item_list_id')) ? getEventData('item_list_id') : undefined;
  let item_list_name = hasValue(getEventData('item_list_name')) ? getEventData('item_list_name') : undefined;
  let creative_name = hasValue(getEventData('creative_name')) ? getEventData('creative_name') : undefined;
  let creative_slot = hasValue(getEventData('creative_slot')) ? getEventData('creative_slot') : undefined;
  let promotion_id = hasValue(getEventData('promotion_id')) ? getEventData('promotion_id') : undefined;
  let promotion_name = hasValue(getEventData('promotion_name')) ? getEventData('promotion_name') : undefined;
  let location_id = hasValue(getEventData('location_id')) ? getEventData('location_id') : undefined;
  let index = hasValue(getEventData('index')) ? getEventData('index') : undefined;

  let currentCustomEvents = {};
  if (customEventAttributeParameters.length > 0) {
    customEventAttributeParameters.forEach(row => {
      const pName = row.parameterName;
      const pVal = row.parameterValue;
      if (hasValue(pName) && hasValue(pVal)) {
        currentCustomEvents[pName] = pVal;
      }
    });
  }

  let mergedCustomEvents = {};
  const oldCeKeys = Object.keys(customEvents2 || {});
  oldCeKeys.forEach(k => { 
    if (k !== 'helper_prop') {
      mergedCustomEvents[k] = customEvents2[k];
    }
  });
  
  const newCeKeys = Object.keys(currentCustomEvents || {});
  newCeKeys.forEach(k => {
    if (attributionType === 'firstClickAttribution') {
      if (isMissing(mergedCustomEvents[k])) {
        mergedCustomEvents[k] = currentCustomEvents[k];
      }
    } else {
      mergedCustomEvents[k] = currentCustomEvents[k];
    }
  });

  if (Object.keys(mergedCustomEvents).length === 0) {
    mergedCustomEvents = {helper_prop: "helper_val"};
  }

  let items1 = [];

  // Filter and map incoming items: only items carrying active attribution are retained
  if (items && items.length > 0) {
    for (let idx = 0; idx < items.length; idx++) {
      let i = items[idx];
      let itemObj = {
        item_id: i.item_id,
        item_list_id: hasValue(i.item_list_id) ? i.item_list_id : item_list_id,
        item_list_name: hasValue(i.item_list_name) ? i.item_list_name : item_list_name,
        creative_name: hasValue(i.creative_name) ? i.creative_name : creative_name,
        creative_slot: hasValue(i.creative_slot) ? i.creative_slot : creative_slot,
        promotion_id: hasValue(i.promotion_id) ? i.promotion_id : promotion_id,
        promotion_name: hasValue(i.promotion_name) ? i.promotion_name : promotion_name,
        location_id: hasValue(i.location_id) ? i.location_id : location_id,
        index: hasValue(i.index) ? i.index : index
      };

      let itemHasAttribution = false;
      if (hasValue(itemObj.item_id) && (
          hasValue(itemObj.item_list_id) || hasValue(itemObj.item_list_name) ||
          hasValue(itemObj.promotion_id) || hasValue(itemObj.promotion_name) ||
          hasValue(itemObj.creative_name) || hasValue(itemObj.creative_slot) ||
          hasValue(itemObj.location_id) || hasValue(itemObj.index))) {
        itemHasAttribution = true;
      }

      if (customItemAttributeParameters.length > 0) {
        for (let j = 0; j < customItemAttributeParameters.length; j++) {
          let p = customItemAttributeParameters[j].parameterName;
          if (hasValue(p) && hasValue(i[p])) {
            itemObj[p] = i[p];
            if (hasValue(itemObj.item_id)) {
              itemHasAttribution = true;
            }
          }
        }
      }

      if (itemHasAttribution) {
        items1.push(itemObj);
      }
    }
  }

  // 2. Item-level attribution branch (items with item_ids attached)
  if (items1.length > 0) {
    const mergedMap = {};
    let orderedKeys = [];
    const seenKeys = {};

    // Deduplicate and import existing stored items
    for (let i = 0; i < items2.length; i++) {
      const oldRec = items2[i];
      if (!oldRec || oldRec.item_id === 'helper_id' || !hasValue(oldRec.item_id)) continue;

      const idKey = 'item_' + oldRec.item_id;
      if (!seenKeys[idKey]) {
        seenKeys[idKey] = true;
        orderedKeys.push(idKey);
      }

      const clone = {};
      const flds = Object.keys(oldRec);
      for (let j = 0; j < flds.length; j++) {
        const k = flds[j];
        clone[k] = oldRec[k];
      }
      mergedMap[idKey] = clone;
    }

    // Merge incoming attributed items
    items1.forEach(rec1 => {
      const id = rec1.item_id;
      if (!hasValue(id) || id === 'helper_id') return;
      const idKey = 'item_' + id;

      let tgt = mergedMap[idKey];
      if (!tgt) {
        tgt = { item_id: id };
        orderedKeys.push(idKey);
      } else if (attributionType !== 'firstClickAttribution') {
        const filteredKeys = [];
        for (let k = 0; k < orderedKeys.length; k++) {
          if (orderedKeys[k] !== idKey) {
            filteredKeys.push(orderedKeys[k]);
          }
        }
        filteredKeys.push(idKey);
        orderedKeys = filteredKeys;
      }

      // List attribution
      const isListEvent = hasValue(rec1.item_list_id) || hasValue(rec1.item_list_name);
      if (isListEvent) {
        if (attributionType === 'firstClickAttribution') {
          if (isMissing(tgt.item_list_id)) tgt.item_list_id = rec1.item_list_id;
          if (isMissing(tgt.item_list_name)) tgt.item_list_name = rec1.item_list_name;
        } else {
          tgt.item_list_id = rec1.item_list_id;
          tgt.item_list_name = rec1.item_list_name;
        }
      }

      // Item-level Promotion Attribution: decoupled so creative-only updates do not wipe identity
      const hasPromoIdentity = hasValue(rec1.promotion_id) || hasValue(rec1.promotion_name);
      const hasCreative = hasValue(rec1.creative_name) || hasValue(rec1.creative_slot);

      if (hasPromoIdentity || hasCreative) {
        if (attributionType === 'firstClickAttribution') {
          if (isMissing(tgt.promotion_id) && hasValue(rec1.promotion_id)) tgt.promotion_id = rec1.promotion_id;
          if (isMissing(tgt.promotion_name) && hasValue(rec1.promotion_name)) tgt.promotion_name = rec1.promotion_name;
          if (isMissing(tgt.creative_name) && hasValue(rec1.creative_name)) tgt.creative_name = rec1.creative_name;
          if (isMissing(tgt.creative_slot) && hasValue(rec1.creative_slot)) tgt.creative_slot = rec1.creative_slot;
        } else {
          if (hasPromoIdentity) {
            tgt.promotion_id = rec1.promotion_id;
            tgt.promotion_name = rec1.promotion_name;
          }
          if (hasValue(rec1.creative_name)) tgt.creative_name = rec1.creative_name;
          if (hasValue(rec1.creative_slot)) tgt.creative_slot = rec1.creative_slot;
        }
      }

      if (hasValue(rec1.location_id)) {
        if (attributionType === 'firstClickAttribution' ? isMissing(tgt.location_id) : true) {
          tgt.location_id = rec1.location_id;
        }
      }
      if (hasValue(rec1.index)) {
        if (attributionType === 'firstClickAttribution' ? isMissing(tgt.index) : true) {
          tgt.index = rec1.index;
        }
      }
      
      if (customItemAttributeParameters.length > 0) {
        customItemAttributeParameters.forEach(row => {
          const p = row.parameterName;
          if (hasValue(rec1[p])) {
            if (attributionType === 'firstClickAttribution' ? isMissing(tgt[p]) : true) {
              tgt[p] = rec1[p];
            }
          }
        });
      }
      
      mergedMap[idKey] = tgt;
    });

    if (limitItemsNumber) {
      const limit = makeInteger(limitItemsNumber);
      if (limit > 0 && orderedKeys.length > limit) {
        if (attributionType === 'firstClickAttribution') {
          orderedKeys = orderedKeys.slice(0, limit);
        } else {
          orderedKeys = orderedKeys.slice(-limit);
        }
      }
    }

    let uniqueItems = orderedKeys.map(function(k) { return mergedMap[k]; });
    if (uniqueItems.length === 0) {
      uniqueItems = [{item_id: "helper_id"}];
    }

    const extract = {
      items: uniqueItems,
      promotion: promo2,
      search_term: searchTerm2,
      custom_events: mergedCustomEvents,
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(extract) : extract;
  }
  
  // 3. Event-level Promotion attribution branch:
  // Usually promotions don't have items. Replaces stored promotion on Last Click; keeps existing on First Click.
  if (promotion_id || promotion_name || creative_name || creative_slot) {
    const promo = {
      creative_name: creative_name, 
      creative_slot: creative_slot, 
      promotion_id: promotion_id, 
      promotion_name: promotion_name, 
      location_id: location_id
    };
    const promoAttribution = (attributionType === 'firstClickAttribution' && promo2) ? promo2 : promo;
    let extract = {
      items: items2, 
      promotion: promoAttribution, 
      search_term: searchTerm2, 
      custom_events: mergedCustomEvents, 
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(extract) : extract;
  }
  
  // 4. Site search attribution branch
  const searchTerm = data.siteSearchChecbox && hasValue(getEventData('search_term')) ? getEventData('search_term') : undefined;
  if (searchTerm) {
    const siteSearchttribution = (attributionType === 'firstClickAttribution' && searchTerm2) ? searchTerm2 : searchTerm;
    let extract = {
      search_term: siteSearchttribution, 
      items: items2, 
      promotion: promo2, 
      custom_events: mergedCustomEvents, 
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(extract) : extract;
  }

  // 5. Custom events attribution branch
  const hasNewCustomEvents = Object.keys(currentCustomEvents || {}).length > 0;
  if (hasNewCustomEvents) {
    let extract = {
      items: items2,
      promotion: promo2,
      search_term: searchTerm2,
      custom_events: mergedCustomEvents,
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(extract) : extract;
  }

  // Fallback extraction to safeguard against returning undefined
  let fallbackExtract = {
    items: items2,
    promotion: promo2,
    search_term: searchTerm2,
    custom_events: mergedCustomEvents,
    timestamp: timestamp
  };
  return jsonData ? JSON.stringify(fallbackExtract) : fallbackExtract;
}

// ==========================================
// OUTPUT
// ==========================================
else if (data.variableType === 'output') {
  let output;
  const param = data.outputDropDown;
  if (param === 'promotion_id') {
    output = promo2 ? promo2.promotion_id : undefined;
  } else if (param === 'promotion_name') {
    output = promo2 ? promo2.promotion_name : undefined;
  } else if (param === 'creative_name') {
    output = promo2 ? promo2.creative_name : undefined;
  } else if (param === 'creative_slot') {
    output = promo2 ? promo2.creative_slot : undefined;
  } else if (param === 'location_id') {
    output = promo2 ? promo2.location_id : undefined;
  } else if (param === 'search_term') {
    output = searchTerm2 ? searchTerm2 : undefined;
  } else if (param === 'custom_event') {
    const requestedKey = data.customEventOutputKey;
    if (customEvents2 && requestedKey && requestedKey !== 'helper_prop') {
      output = customEvents2[requestedKey];
    } else {
      output = undefined;
    }
  } else if (param === 'items' && items) {
    items.forEach(item => {
      if (data.itemSearchTerm && searchTerm2) {
        item.search_term = searchTerm2;
      }
      
      if (data.itemCustomEvents) {
        const ceKeys = Object.keys(customEvents2 || {});
        if (ceKeys.length > 0) {
          ceKeys.forEach(k => {
            if (k !== 'helper_prop') {
              item[k] = currentOrStored(item[k], customEvents2[k]);
            }
          });
        }
      }

      const standardKeys = ['item_id', 'item_list_id', 'item_list_name', 'creative_name', 'creative_slot', 'promotion_id', 'promotion_name', 'location_id', 'index'];

      items2.forEach(item2 => {
        if (item2 && item2.item_id !== 'helper_id' && ('' + item.item_id === '' + item2.item_id)) {
          item.item_list_id = currentOrStored(item.item_list_id, item2.item_list_id);
          item.item_list_name = currentOrStored(item.item_list_name, item2.item_list_name);
          item.creative_name = currentOrStored(item.creative_name, item2.creative_name);
          item.creative_slot = currentOrStored(item.creative_slot, item2.creative_slot);
          item.promotion_id = currentOrStored(item.promotion_id, item2.promotion_id);
          item.promotion_name = currentOrStored(item.promotion_name, item2.promotion_name);
          item.location_id = currentOrStored(item.location_id, item2.location_id);
          item.index = currentOrStored(item.index, item2.index);
          
          const storedKeys = Object.keys(item2 || {});
          storedKeys.forEach(k => {
            if (standardKeys.indexOf(k) === -1) {
              item[k] = currentOrStored(item[k], item2[k]);
            }
          });
        }
      });
    });
    output = items ? items : undefined;
  }
  return output;
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event_name"
              },
              {
                "type": 1,
                "string": "items"
              },
              {
                "type": 1,
                "string": "item_list_id"
              },
              {
                "type": 1,
                "string": "item_list_name"
              },
              {
                "type": 1,
                "string": "creative_name"
              },
              {
                "type": 1,
                "string": "creative_slot"
              },
              {
                "type": 1,
                "string": "promotion_id"
              },
              {
                "type": 1,
                "string": "promotion_name"
              },
              {
                "type": 1,
                "string": "location_id"
              },
              {
                "type": 1,
                "string": "index"
              },
              {
                "type": 1,
                "string": "search_term"
              },
              {
                "type": 1,
                "string": "ga_session_id"
              }
            ]
          }
        },
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 2/7/2023, 8:20:44 PM


