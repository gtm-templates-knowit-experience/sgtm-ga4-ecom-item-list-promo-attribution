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
  "securityGroups": [],
  "displayName": "GA4 - Item List \u0026 Promotion Attribution",
  "description": "Attribute GA4 Item List, Promotion or Search Term to revenue \u0026 ecommerce Events. This Template makes this possible by using ex. Firestore as a \"helper\". Last \u0026 First Click Attribution supported.",
  "categories": [
  "ANALYTICS",
  "UTILITY",
  "TAG_MANAGEMENT"
  ],
  "containerContexts": [
    "SERVER"
  ]
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
        "alwaysInSummary": true
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
          },
          {
            "type": "CHECKBOX",
            "name": "searchTermLowerCase",
            "checkboxText": "Lower Case Search Term",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "siteSearchChecbox",
                "paramValue": true,
                "type": "EQUALS"
              }
            ],
            "help": "Lower Case \u003cstrong\u003esearch_term\u003c/strong\u003e to avoid duplicates."
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
const JSON = require('JSON');
const makeInteger = require('makeInteger');
const Object = require('Object');

const jsonData = data.jsonData;
const secondDataSource = data.secondDataSource && typeof data.secondDataSource === 'string' ? JSON.parse(data.secondDataSource) : data.secondDataSource || undefined;
const event_name = getEventData('event_name');
const items = getEventData('items');
let items2 = secondDataSource ? secondDataSource.items : [{item_id:"helper_id"}];
let promo2 = secondDataSource ? secondDataSource.promotion : undefined;
let searchTerm2 = secondDataSource ? secondDataSource.search_term : undefined;

const timestamp = data.attributionTime ? getTimestampMillis() : makeInteger(getEventData('ga_session_id'));
const timestamp2 = secondDataSource ? secondDataSource.timestamp : timestamp;
const timestampDiff = secondDataSource && data.attributionTime ? timestamp-secondDataSource.timestamp : timestamp;
const attributionTime = data.attributionTime ? makeInteger(data.attributionTime)*60000 : timestamp2;
const attributionType = data.attributionType;
const limitItemsNumber = data.limitItemsNumber;

function hasValue(v) { return v !== undefined && v !== null && v !== ''; }
function isMissing(v) { return v === undefined || v === null || v === ''; }

if(timestampDiff > attributionTime) {
  items2 = [{item_id:"helper_id"}];
  promo2 = undefined;
  searchTerm2 = undefined;
}

if(data.variableType === 'attribution') { 
  let item_list_id = hasValue(getEventData('item_list_id')) ? getEventData('item_list_id') : undefined;
  let item_list_name = hasValue(getEventData('item_list_name')) ? getEventData('item_list_name') : undefined;
  let creative_name = hasValue(getEventData('creative_name')) ? getEventData('creative_name') : undefined;
  let creative_slot = hasValue(getEventData('creative_slot')) ? getEventData('creative_slot') : undefined;
  let promotion_id = hasValue(getEventData('promotion_id')) ? getEventData('promotion_id') : undefined;
  let promotion_name = hasValue(getEventData('promotion_name')) ? getEventData('promotion_name') : undefined;
  let location_id = hasValue(getEventData('location_id')) ? getEventData('location_id') : undefined;
  let index = hasValue(getEventData('index')) ? getEventData('index') : undefined;

  if (items) {
    const mapItemsData = i => {
      const itemObj = {
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
      return itemObj;
    };
    
    const items1 = items.map(mapItemsData); 
    const first = items1[0] || {};
   
    const item_id = first.item_id ? first.item_id : undefined;
    item_list_id = hasValue(first.item_list_id) ? first.item_list_id : undefined;
    item_list_name = hasValue(first.item_list_name) ? first.item_list_name : undefined;
    promotion_id = hasValue(first.promotion_id) ? first.promotion_id : promotion_id;
    promotion_name = hasValue(first.promotion_name) ? first.promotion_name : promotion_name;
    creative_name = hasValue(first.creative_name) ? first.creative_name : creative_name;
    creative_slot = hasValue(first.creative_slot) ? first.creative_slot : creative_slot;
    location_id = hasValue(first.location_id) ? first.location_id : location_id;

  if (items1 && item_id && (item_list_id || item_list_name || promotion_id || promotion_name)) {
    const firstClick = attributionType === 'firstClickAttribution';
    const combined = firstClick ? items2.concat(items1) : items1.concat(items2);  // first vs. last click attribution

    const mergedMap = {};
    for (let i = 0; i < items2.length; i++) {
      const oldRec = items2[i];
      // shallow‐clone oldRec into a brand‐new object
      const clone = {};
      const flds  = Object.keys(oldRec);
      for (let j = 0; j < flds.length; j++) {
        const k = flds[j];
        clone[k] = oldRec[k];
      }
      mergedMap[oldRec.item_id] = clone;
    }

    // ================
    // 2) MERGE ONLY the NEW `items1` records
    // ================
    items1.forEach(rec1 => {
      const id = rec1.item_id;
      let tgt   = mergedMap[id];
      if (!tgt) {
        // no seed existed, start fresh
        tgt = { item_id: id };
      }

      const isListEvent = hasValue(rec1.item_list_id) || hasValue(rec1.item_list_name);

      // Item‐List group
      if (isListEvent) {
        if (attributionType === 'firstClickAttribution') {
          if (isMissing(tgt.item_list_id)) tgt.item_list_id = rec1.item_list_id;
          if (isMissing(tgt.item_list_name)) tgt.item_list_name = rec1.item_list_name;
        } else {
          // overwrite even if rec1.[…] is null (you may guard if you don’t want to write nulls)
          tgt.item_list_id = rec1.item_list_id;
          tgt.item_list_name = rec1.item_list_name;
        }
      }

      const isPromoEvent = hasValue(rec1.promotion_id) || hasValue(rec1.promotion_name);
      
      // Promotion group   
      if (isPromoEvent) {
        if (attributionType === 'firstClickAttribution') {
          if (isMissing(tgt.promotion_id))   tgt.promotion_id   = rec1.promotion_id;
          if (isMissing(tgt.promotion_name)) tgt.promotion_name = rec1.promotion_name;
          if (isMissing(tgt.creative_name))  tgt.creative_name  = rec1.creative_name;
          if (isMissing(tgt.creative_slot))  tgt.creative_slot  = rec1.creative_slot;
        } else {
          tgt.promotion_id   = rec1.promotion_id;
          tgt.promotion_name = rec1.promotion_name;
          tgt.creative_name  = rec1.creative_name;
          tgt.creative_slot  = rec1.creative_slot;
        }
      }

      // Location & index
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
      
     mergedMap[id] = tgt;
    });

    // ================
    // 3) EXTRACT & LIMIT
    // ================
    let uniqueItems = Object.keys(mergedMap).map(function(k){ return mergedMap[k]; });
    if (limitItemsNumber) {
      uniqueItems = uniqueItems.slice(0, makeInteger(limitItemsNumber));
    }

    const extract = {
      items: uniqueItems,
      promotion: promo2,
      search_term: searchTerm2,
      timestamp: timestamp
    };
    return jsonData ? JSON.stringify(extract) : extract;
    }
  }
  
  if (promotion_id||promotion_name) {
    const promo = {creative_name: creative_name, creative_slot: creative_slot, promotion_id: promotion_id, promotion_name: promotion_name, location_id: location_id};
    
    const promoAttribution = attributionType === 'firstClickAttribution' && promo2 ? promo2 : promo;
    let extract = {items: items2, promotion: promoAttribution, search_term: searchTerm2, timestamp: timestamp};
      extract = jsonData && extract ? JSON.stringify(extract) : extract;
        return extract;
  }
  let searchTerm = data.siteSearchChecbox && hasValue(getEventData('search_term')) ? getEventData('search_term') : undefined;
  if (searchTerm) {
    searchTerm = data.searchTermLowerCase ? searchTerm.toLowerCase() : searchTerm;
    const siteSearchttribution = attributionType === 'firstClickAttribution' && searchTerm2 ? searchTerm2 : searchTerm;
    let extract = {search_term: siteSearchttribution, items: items2, promotion: promo2, timestamp: timestamp};
      extract = jsonData && extract ? JSON.stringify(extract) : extract;
        return extract;
  }
}
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
  } else if (param === 'items' && items) {
    items.forEach(item => {
      if(data.itemSearchTerm && searchTerm2 ) {
        item.search_term = searchTerm2;
      }
      items2.forEach(item2 => {
        if (item.item_id === item2.item_id) {
          item.item_list_id = item.item_list_id || item2.item_list_id || undefined;
          item.item_list_name = item.item_list_name || item2.item_list_name || undefined;
          item.creative_name = item.creative_name || item2.creative_name || undefined;
          item.creative_slot = item.creative_slot || item2.creative_slot || undefined;
          item.promotion_id = item.promotion_id || item2.promotion_id || undefined;
          item.promotion_name = item.promotion_name || item2.promotion_name || undefined;
          item.location_id = item.location_id || item2.location_id || undefined;
          item.index = item.index || item2.index || undefined;
        }
    });
  });
    output = items ? items : undefined;
  }
  return output;
}

if(data.deleteAttribution === true && event_name === 'purchase') {
  let extract = {search_term: undefined, items:[{item_id:"helper_id"}], promotion: undefined, timestamp: timestamp};
      extract = jsonData && extract ? JSON.stringify(extract) : extract;
        return extract;
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
                "string": "ga_session_id"
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
                "string": "event_name"
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


