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
  "description": "Attribute GA4 Item Lists, Promotions, Search Terms, and Custom Parameters to ecommerce and other events using Firestore/Stape Data Store. Last \u0026 First Click Attribution supported.",
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
            "help": "Evaluates the incoming event and returns \u0027true\u0027 if it contains new attribution data (item lists, promotions, search terms, or custom parameters). Use this variable in your GTM Triggers to prevent unnecessary database reads on events with no attribution data.\n\u003cbr /\u003e\u003cbr /\u003e\nAlways returns \u0027true\u0027 for \u003cstrong\u003epurchase\u003c/strong\u003e, so attribution data can be deleted/reset after purchase. Only include purchase in the trigger if you use that setting."
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
          },
          {
            "type": "CHECKBOX",
            "name": "itemPromotion",
            "checkboxText": "Add Event-level Promotion to Items",
            "simpleValueType": true,
            "enablingConditions": [
              {
                "paramName": "outputDropDown",
                "paramValue": "items",
                "type": "EQUALS"
              }
            ],
            "help": "If checked, the stored event-level promotion (\u003cstrong\u003epromotion_id\u003c/strong\u003e, \u003cstrong\u003epromotion_name\u003c/strong\u003e, \u003cstrong\u003ecreative_name\u003c/strong\u003e, \u003cstrong\u003ecreative_slot\u003c/strong\u003e and \u003cstrong\u003elocation_id\u003c/strong\u003e) is added to items that don\u0027t have a promotion of their own.\n\u003cbr /\u003e\u003cbr /\u003e\nGA4 copies event-level promotion parameters to items itself, but not \u003cstrong\u003elocation_id\u003c/strong\u003e. Items with the same promotion also get the stored location_id."
          },
          {
            "type": "TEXT",
            "name": "locationIdValueOutput",
            "displayName": "Location ID Value",
            "simpleValueType": true,
            "valueHint": "E.g., {{Page Path}}",
            "help": "Optional. Insert a variable with the value you want as \u003cstrong\u003elocation_id\u003c/strong\u003e, ex. \u003cstrong\u003ePage Path\u003c/strong\u003e for web or \u003cstrong\u003escreen name\u003c/strong\u003e for app.\n\u003cbr /\u003e\u003cbr /\u003e\nThe value is only used where an Item List or Promotion is implemented on the event or the item, and location_id is missing. An \u003cstrong\u003eadd_to_cart\u003c/strong\u003e from an Item List gets the value, an add_to_cart from a product page does not.\n\u003cbr /\u003e\u003cbr /\u003e\nUse the same value in the \u003cstrong\u003eExtract\u003c/strong\u003e variable and in the \u003cstrong\u003eReturn Attributed Output\u003c/strong\u003e variables for \u003cstrong\u003eItems\u003c/strong\u003e and \u003cstrong\u003eLocation ID\u003c/strong\u003e.",
            "enablingConditions": [
              {
                "paramName": "outputDropDown",
                "paramValue": "items",
                "type": "EQUALS"
              },
              {
                "paramName": "outputDropDown",
                "paramValue": "location_id",
                "type": "EQUALS"
              }
            ]
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
    "type": "GROUP",
    "name": "locationIdGroup",
    "displayName": "Location ID",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "TEXT",
        "name": "locationIdValue",
        "displayName": "Location ID Value",
        "simpleValueType": true,
        "valueHint": "E.g., {{Page Path}}",
        "help": "Optional. Insert a variable with the value you want as \u003cstrong\u003elocation_id\u003c/strong\u003e, ex. \u003cstrong\u003ePage Path\u003c/strong\u003e for web or \u003cstrong\u003escreen name\u003c/strong\u003e for app.\n\u003cbr /\u003e\u003cbr /\u003e\nThe value is only used where an Item List or Promotion is implemented on the event or the item, and location_id is missing. An \u003cstrong\u003eadd_to_cart\u003c/strong\u003e from an Item List gets the value, an add_to_cart from a product page does not.\n\u003cbr /\u003e\u003cbr /\u003e\nUse the same value in the \u003cstrong\u003eExtract\u003c/strong\u003e variable and in the \u003cstrong\u003eReturn Attributed Output\u003c/strong\u003e variables for \u003cstrong\u003eItems\u003c/strong\u003e and \u003cstrong\u003eLocation ID\u003c/strong\u003e."
      }
    ],
    "enablingConditions": [
      {
        "paramName": "variableType",
        "paramValue": "attribution",
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
        "help": "Tick this box if you want attribution data to be deleted/reset after \u003cstrong\u003epurchase\u003c/strong\u003e.\n\u003cbr /\u003e\u003cbr /\u003e\nThe trigger for the tag that stores the attribution data must also fire on \u003cstrong\u003epurchase\u003c/strong\u003e. The \u003cstrong\u003eTrigger Helper\u003c/strong\u003e variable always returns true for purchase, so it needs no setting for this.",
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
        "help": "\u003cstrong\u003eLast Click Attribution\u003c/strong\u003e \u003cbr /\u003e\nWith Last Click Attribution, the Last Click on an Item List or a Promotion will be attributed.\n\u003cbr /\u003e\nItem List and Promotion attribution are independent of each other.\n\u003cbr /\u003e\u003cbr /\u003e\nSee \u003ca href\u003d\"https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution\" target\u003d\"_blank\"\u003e\u003cstrong\u003ethe documentation\u003c/strong\u003e\u003c/a\u003e for detailed explanation of attribution.\n\u003cbr /\u003e\u003cbr /\u003e\n\u003cstrong\u003eFirst Click Attribution\u003c/strong\u003e \u003cbr /\u003e\nWith First Click Attribution, the First Click on an Item List or a Promotion will be attributed.\n\u003cbr /\u003e\nItem List and Promotion attribution are independent of each other.",
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
        "name": "siteSearchChecbox",
        "checkboxText": "Attribute Site Search",
        "simpleValueType": true,
        "help": "Attribute the \u003cstrong\u003esearch_term\u003c/strong\u003e parameter.",
        "alwaysInSummary": true
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
              },
              {
                "type": 1,
                "string": "session_id"
              },
              {
                "type": 1,
                "string": "x-ga-mp2-user_properties"
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


