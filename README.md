# GA4 - Item List & Promotion Attribution - SGTM Variable (Server)
**Google Analytics 4 (GA4)** has **Item List & Promotion reports**. But, unlike **Enhanced Ecommerce**, no revenue or conversions are attributed back to Promotion or Item Lists (at the time of creating this solution).

This Variable for  **Server-side GTM** makes it possible to attribute GA4 Item List & Promotion to revenue or ecommerce Events (ex. purchase):
* Last Click Attribution
* First Click Attribution
* Attribution Time (for how long should Item List or Promotion be attributed)
* Can handle attributed data as both array & string

![GA4 Item List Attribution example](https://github.com/gtm-templates-knowit-experience/gtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ga4-item-list-attribution-animation.gif)

A similar [Variable Template do also exist for **GTM (Web)**](https://github.com/gtm-templates-knowit-experience/gtm-ga4-ecom-item-list-promo-attribution). Differences between doing the attribution with GTM (Web) vs. Server-side GTM (SGTM) are listed below.

| Functionality  | GTM (Web) | Server-side GTM |
| ------------- | ------------- | ------------- |
| Cross (sub)domain tracking | No | Yes |
| Server to Server-side (Measurement Protocol) | No | Yes |
| Attribution/processing | Users browser | Server-side |
| Storage Limitation | Yes | No |
| Costs Money | No | Yes |

In the following documentation, **[Firestore](https://cloud.google.com/firestore/)** will be used to handle the attribution.

**Reasons for using Firestore are:**
*	Firestore is well suited for real-time data.
*	Number of Items stored in Firestore is unlimited (compared to browser storage).
*	There is no point storing the attribution data for long, and Firestore can automatically delete outdated documents.
*	Firestore has a **[free quota per day](https://cloud.google.com/firestore/pricing)**, but **[costs may occur](#estimating-cost)**.

Firestore data example below.
![Firestore storage example](https://raw.githubusercontent.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/main/images/firestore-storage-example.png)

## Google Cloud, Firestore & Cloud Functions Setup
It’s recommended to create a [new Google Cloud Project](https://console.cloud.google.com/projectcreate) for the Firestore setup.

###  Firestore Setup  
* Select a [Cloud Firestore mode](https://console.cloud.google.com/firestore/welcome)
  * Select Native Mode
* Choose where to store your data
  * Create Database

If you are running Firestore in a different Google Cloud Project than Server-side GTM, you must add the **[SGTM service account](https://console.cloud.google.com/iam-admin/serviceaccounts)** to the **[Firestore project via IAM](https://console.cloud.google.com/iam-admin/iam)**.

Grant the service account a **Cloud Datastore User role** to give SGTM access to the Firestore project.

* If Server-side GTM is running on App Engine, add the Server-side GTM **App Engine default service account** to the Firestore project.
* If Server-side GTM is running on Cloud Run, add the Server-side GTM **Compute Engine default service account** to the Firestore project.

#### Delete outdated documents in Firestore
* Use **[time-to-live (TTL) policies](https://cloud.google.com/firestore/docs/ttl)** to automatically delete outdated documents.

In Firestore, go to **[Time to live (TTL)](https://console.cloud.google.com/firestore/ttl)**.
* Click **Create Policy**
* **Collection group**: ecommerce
* **Timestamp field**: expire_at
* Click **Create** button

### Cloud Functions
To be able to use **TTL**, the TTL field must be of type **Date and time**. At the time of writing, SGTM can't store data in this format to Firestore.
To get around this we use **[Cloud Functions](https://cloud.google.com/functions)** to write **Date and time** to Firestore. Note: This increases Firestore reads & writes.

#### Create function
We need to create 2 functions; **create** & **update**.
These functions will listen to changes in Firestore, and will take a **Timestamp** set by SGTM in a **number format**, and rewrite that number to **Date and time**.

##### Configuration
* Basics
  * **Environment**: 1st gen
  * **Function name**: ga4-int_attribution-date-time_create
  * **Region**: choose a region close to or the same as Firestore
  * **Trigger type**: create
  * **Document path**: ecommerce/{docId}
* Runtime
  * **Memory allocated**: 256 MB (128 MB may also work)
  * Other settings as is
* Connections
  * Allow internal traffic only

##### Code
* **Runtime**: Node.js 16
* **Source code**: Inline Editor
* **Entry point**: makeDateTime

###### index.js

```javascript
const Firestore = require('@google-cloud/firestore');
const firestore = new Firestore({
  projectId: process.env.GOOGLE_CLOUD_PROJECT
});

exports.makeDateTime = event => {
  const curValue = event.value.fields.expire_at.doubleValue;
  if (curValue && typeof curValue === 'number') {
    const affectedDoc = firestore.doc(event.value.name.split('/documents/')[1]);

    let newValue = new Date(curValue);
    newValue = new Date(newValue.setDate(newValue.getDate() + 7)); // Set TTL to 7 days from now.

    return affectedDoc.update({
      expire_at: newValue
    });
  }
};
```
The reason for setting TTL to 7 days from now is to reduce TTL deletes. If we set TTL today, and the user comes back in a couple of days, TTL deletes will be done twice for this user.

###### package.json

```json
{
  "name": "sample-firestore",
  "version": "0.0.1",
  "dependencies":{
   "firebase-admin": "11.3.0",
   "firebase-functions": "4.1.0"
}
}
```

**Deploy function**.

* Now create a identical function, but select **Trigger type** *update* instead.
* Name this function **ga4-int_attribution-date-time_update**

Cloud Functions setup is now completed.

## Server-side GTM Setup
Install the following Server-side GTM Templates:
* GA4 - Item List & Promotion Attribution (this Variable Template)
*	[Firestore Writer](https://tagmanager.google.com/gallery/#/owners/stape-io/templates/firestore-writer-tag) Tag
* [sha256 Hasher](https://tagmanager.google.com/gallery/#/owners/gtm-templates-simo-ahava/templates/sha256-hasher) Variable

### Create Variables
We must create a decent number of Variables. Suggested Variable names are listed below, and are also used throughout the documentation.
*	ecom - attribution time - minutes – C
*	ecom - item_list & promotion - Lookup - Events – LT
*	GA(4) - client_id – ED
*	GA(4) - client_id - sha256 – hex
*	ecom - item_list & promotion - Firestore – FL
*	ecom - item_list & promotion - extract – CT
*	ecom - items - ED
*	ecom - items - item_list & promotion - merge – CT
*	ecom - items - item_list & promotion - merge – LT
*	++

### ecom - attribution time - minutes – C
Since attribution time is referenced in several variables, it’s recommended to create a Constant Variable with the attribution time in minutes.
How long the attribution time should be is up to you. Time is counted from the last **select_promotion**, **select_item** or **add_to_cart** Event. 

![ecom - attribution time - minutes – C](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-attribution%20time-minutes-C.png)

* Name the Variable **ecom - attribution time - minutes - C**.

### ecom - item_list & promotion - Lookup - Events - LT
The purpose of this Variable is to give you full control over when to read data from your Secondary Data Source (ex. Firestore), and when to use data from your GA4 Ecommerce implementation.

Ideally your setup should be as shown in the image below. But, if you are using Firestore and want to limit number of Firestore Reads to save some money, you can remove some of the Events from this Lookup Table.Data from the implementation will be used for all Ecommerce Events that isn’t listed in this Lookup Table.

**The following Events are necessary:** purchase, begin_checkout & add_to_cart.

![ecom - item_list & promotion - Lookup - Events - LT](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-item_list-and-promotion-Lookup-Events-LT.png)

* Name the Variable **ecom - items - item_list & promotion - Lookup - Events – LT**.

### GA(4) - client_id – ED
The Client Id is going to be used as an identifier in this solution.
Create an **Event Data** Variable and add **client_id** as **Key Path**.

![GA(4) - client_id – ED](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/GA(4)-client_id-ED.png)

*	Name the Variable **GA(4) - client_id – ED**.

### GA(4) - client_id - sha256 – hex
With Server-side GTM, the **Client ID** can sometimes come from the **_ga** cookie, and other times from the **FPID** cookie if you have chosen **Migrate from JavaScript Managed Client ID** in SGTM. Client ID from the FPID cookie can sometimes contain / (slash). An id with a slash can’t be a document in Firestore (the document would be broken).

To get around this potential issue, we **hash the Client ID encoded as hex**. Create a **sha256 Hasher** Variable, and **Value to hash** should be **{{GA(4) – client_id – ED}}**.

In addition, using data pseudonymization or anonymization when you can is always a good thing.

![GA(4) - client_id - sha256 – hex](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/GA(4)-client_id-sha256-hex.png)

* Name the Variable **GA(4) - client_id - sha256 – hex**.

### ecom - item_list & promotion - Firestore – FL
We are using the **Firestore Lookup** to read data from Firestore. You can query Firestore using either **Document Path**, or **Collection & query**. We are using Collection & query simply because this will not throw any warnings in Server-side GTM Preview if you query an id that doesn’t exist (yet).
How to name and organize your Firestore document is up to you, but these are the settings used in this example:

*	**Document Path:** ecommerce
*	**Field:** _id ==_ {{GA(4) - client_id - sha256 – hex}}
*	**Key Path:** int_attribution
*	**Project ID:** _Your GCP Project ID_

![ecom - item_list & promotion - Firestore – FL](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-item_list-and-promotion-Firestore-FL.png)

* Name the Variable **ecom - item_list & promotion - Firestore – FL**.

### ecom - item_list & promotion - extract – CT
Select the **GA4 Ecommerce – Item List & Promotion Attribution** Variable (this Template). This variable will **extract Item List & Promotion dat**a from GA4 Ecommerce and create the attribution. With other words, attribution happens at collection time.

This variable will do both Firestore Read and Write.

*	**Variable Type:** Extract Item Lists & Promotion for Attribution
*	**Second Data Source:** {{ecom - item_list & promotion - Firestore – FL}}
* Attribution
  * **Attribution Time in Minutes:** {{ecom - attribution time - minutes – C}}
  * **Attribution Type:** Select Last or First Click Attribution
* Other Settings
  * **Handle data as string:** This will save attribution data as a string. Not relevant when using Firestore.
  * **Limit Items:** This will limit number of Items stored. Not relevant when using Firestore.

![ecom - item_list & promotion - extract – CT](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-item_list-and-promotion-extract-CT.png)

* Name the Variable **ecom - item_list & promotion - extract – CT**.

### ecom - items – ED
Create an **Event Data** Variable and add **items** as **Key Path**.

![ecom - items – ED](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-items-ED.png)

*	Name the Variable **ecom - items – ED**.

In addition, you should create **Promotion Variables** from Event Data if you have implemented **Promotion without Items**:

| Variable Name  | Key Path |
| ------------- | ------------- |
| ecom - location_id - ED | location_id |
| ecom - promo - creative_name - ED | creative_name |
| ecom - promo - creative_slot - ED | creative_slot |
| ecom - promo - promotion_id - ED | promotion_id |	
| ecom - promo - promotion_name - ED | promotion_name |	

### ecom - items - item_list & promotion - merge – CT

Select the **GA4 Ecommerce – Item List & Promotion Attribution Variable** (this Template). This Variable merges Implemented data & data from Second Data Source (ex. Firestore).

* **Variable Type:** Return Attributed Output
* **Output:** Items
* **Second Data Source:** {{ecom – item_list & promotion – Firestore – FL}}
* Attribution
  * **Attribution Time in Minutes:** {{ecom - attribution time - minutes – C}}

![ecom - items - item_list & promotion - merge – CT](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/sgtm-ga4-items-item_list-and-promotion-merge-CT.png)

*	Name the Variable **ecom - items - item_list & promotion - merge – CT**.

In addition, you should create **Promotion Variables** using the same Variable Type if you have implemented **Promotion without Items**:

| Variable Name  | Output |
| ------------- | ------------- |
| ecom - location_id - merge - CT | Location ID |
| ecom - promo - creative_name - merge - CT | Creative Name |
| ecom - promo - creative_slot - merge - CT | Creative Slot |
| ecom - promo - promotion_id – merge - CT | Promotion ID |	
| ecom - promo - promotion_name – merge - CT | Promotion Name |	

### ecom - items - item_list & promotion - merge – LT
This Lookup Table controls when to use merged (attributed) items data, and when to use implemented data.

*	**Input Variable:** {{ ecom - items - item_list & promotion - Lookup - Events – LT}}
*	**Input:** true
*	**Output:** {{ecom - items - item_list & promotion - merge - CT}}
*	**Default Value:** {{ecom - items - ED}}

![ecom - items - item_list & promotion - merge – LT](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/ecom-items-item_list-and-promotion-merge-LT.png)

* Name the Variable **ecom - items - item_list & promotion - merge – LT**.

In addition, you should create **Promotion Variables** using the same Variable if you have implemented **Promotion without Items**:

| Variable Name  | Output | Default Value |
| ------------- | ------------- | ------------- |
| ecom - location_id - merge - LT | {{ecom - location_id - merge - CT}} | {{ecom - location_id - ED}} |
| ecom - promo - creative_name - merge - LT | {{ecom - promo - creative_name - merge - CT}} | {{ecom - promo - creative_name - ED}} |
| ecom - promo - creative_slot - merge - LT | {{ecom - promo - creative_slot - merge - CT}} | {{ecom - promo - creative_slot - ED}} |
| ecom - promo - promotion_id – merge - LT | {{ecom - promo - promotion_id - merge - CT}} |	{{ecom - promo - promotion_id - ED}} |
| ecom - promo - promotion_name – merge - LT | {{ecom - promo - promotion_name - merge - CT}} |	{{ecom - promo - promotion_name - ED}} |

## Trigger
### ecom - select_item, select_promotion & add_to_cart

Create a Custom Trigger Type with the following settings:

*	**This trigger fires on:** Some Events
*	**Client Name** _equals_ GA4 (the name you have given your GA4 Client)
*	**Event Name** *matches RegEx* ^(select_item|select_promotion|add_to_cart)$
*	**ecom – item_list & promotion – extract – CT** _does not equal_ undefined

![ecom - select_item, select_promotion & add_to_cart](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/Trigger-ecom-select_item-select_promotion-add_to_cart.png)

*	Name the Trigger **ecom - select_item, select_promotion & add_to_cart**.

## Tags

### Ecom - Item List & Promotion Attribution – Firestore
Select the **Firestore Writer** Tag, and add the following settings:

* **Firebase Path:** ecommerce/{{GA(4) - client_id - sha256 – hex}}
* Override Firebase Project ID
  * **Firebase Project ID:** your-project-id
* Add Timestamp
  * **Timestamp field name:** expire_at
* Custom Data
  * **Field Name:** int_attribution
  * **Field Value:** {{ecom - item_list & promotion - extract - CT}}
  * **Field Name:** id
  * **Field Value:** {{GA(4) - client_id - sha256 - hex}}

![Ecom - Item List & Promotion Attribution – Firestore](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/GA4-Item-List-and-Promotion-Attribution-Firestore.png)

* Add **ecom - select_item, select_promotion & add_to_cart** as a Trigger to the Tag.

### GA4 Tag – Parameters to Add/Edit
Edit **Parameters to Add / Edit** in your GA4 Tag:

| Name  | Value | Note |
| ------------- | ------------- | ------------- |
| items | {{ecom - items - item_list & promotion - merge - LT}} |  |
| promotion_name | {{ecom - promo - promotion_name - merge - LT}} | If Promotion without Items is implemented |
| promotion_id | {{ecom - promo - promotion_id - merge - LT}} | If Promotion without Items is implemented |
| creative_name | {{ecom - promo - creative_name - merge - LT}} | If Promotion without Items is implemented |	
| creative_slot | {{ecom - promo - creative_slot - merge - LT}} | If Promotion without Items is implemented |
| location_id | {{ecom - location_id - merge - LT}} | If Promotion without Items is implemented |

![GA4 Tag – Parameters to Add/Edit](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/Tag-GA4-Parameters-to-Add-or-Edit.png)

Your Server-side GTM setup is now complete, but you can do even more to control attribution. If the case is that customers usually do several purchases within a session, then you maybe want to delete attribution data after each purchase.

## Web implementation
To make the attribution work, also the implementation on the website must be correct. It’s especially implementation of Item List that can be incorrect.

**All attribution in this solution is tied back to the following Events:**
*	select_item, add_to_cart (from a list) or select_promotion

When it comes to filling out the **location_id** parameter, if you don’t have **Place ID** as Google suggest using, fill this parameter with **Page Path** instead. Then you will get Page Path attributed as well.

The GA4 Event documentation allows for implementation of Item List and Promotion on both the Event-level and Item-level. This Template supports both implementations.

### Promotion implementation
It’s recommended to implement all promotion parameters, but as a minimum for this attribution to work you must implement either **promotion_id** or **promotion_name** with the **[select_promotion](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#select_promotion)** Event.

### Item List Implementation

The following Events should have Item List implemented. The rest of the ecommerce Events will read the Item List data from this Template.
*	[view_item_list](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#view_item_list)
* [select_item](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#select_item)
* [add_to_cart](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#add_to_cart)

Implementing Item List for the **add_to_cart** Event has though an exception. Item Lists should only be implemented if the Item is added to cart directly from an Item List. 

You should never implement a **Product Page Item List**. The reason for this is that this will overwrite the Item List the user arrived from (ex. a “Related Products” list), and you will not be able to tell how well the “Related Products” list is working in terms of sales.

## GTM (Web) Setup
To make the attribution work, the **GTM (Web)** setup must also be correct.

In the examples below, the setup handles implementation both on the Event-level and Item-level.

In the setup you will see that Data Layer is mostly Version 1. The **[GA4 Ecom Items - DLV Version 1](https://github.com/gtm-templates-knowit-experience/gtm-ga4-ecom-items-dlv-version-1-variable)** Variable Template is used for achieving that.

### select_promotion & view_promotion
This setup handles both **select_promotion** & **view_promotion**, where promotion also has **Event-level Item Lists**. **location_id** is set to **Page Path**.

![select_promotion & view_promotion](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/gtm-ga4-tag-select_promotion.png)

### select_item & view_item_list
This setup handles both **select_item** & **view_item_list**, with **Event-level Item Lists**. **location_id** is set to **Page Path**.

![select_promotion & view_promotion](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/gtm-ga4-tag-select_item.png)

### add_to_cart & view_item
This setup handles **add_to_cart** & **view_item**. **location_id** in this setups is also **Page Path**, but Page Path will only be returned if **item_list_name** or **item_list_id** exist. Otherwise **location_id** will be **undefined**.

![select_promotion & view_promotion](https://github.com/gtm-templates-knowit-experience/sgtm-ga4-ecom-item-list-promo-attribution/blob/main/images/gtm-ga4-tag-add_to_cart-view_item.png)

## Attribution explained

This solution can do either **Last Click** or **First Click Attribution**.

Attribution happens on 2 levels: Promotion without Items (Event-level), and the Item-level. In addition, Item-level trumps the Event-level.

To get a better understanding of the attribution, it's recommended to run some test scenarios where you inspect your own data:
* Run **Server-side GTM** in **Preview Mode**
* Look at the **Firestore** data being built or rewritten
* Inspect especially **Items** in **GA4 DebugView**

### Last Click Attribution
With a Last Click Attribution model, this user journey illustrates the attribution:
1. User clicks on “**Promotion 1 without Items**” (promotion without any Items attached to the promotion). This is an Event-level promotion, and “Promotion 1 without Items” is the attributed Event-level promotion.
    - On the “Promotion 1 without Items” page, there is a “**Promotion 2 without Items**” promotion, and the user clicks on the promotion. This promotion is also an Event-level promotion. “Promotion 2 without Items” is now attributed to the Event-level promotion.
2. The user clicks next on a promotion for a bundled phone with earbuds package (“**Promotion 3 with Items**”). This promotion has 2 items attached, the phone and the earbuds. This promotion is attached to the 2 different Item Id’s (**item_id = phone1** and **item_id = earbud2**) and is therefore an Item-level promotion. 
   -	User adds this bundle with 2 items to cart. The add_to_cart Event is attributed to the promotion.
      - User clicks after that on the “**Users Also Looked At**” Item List with other earbuds that it’s also possible to choose. The earbud (item_id = earbud3) the user clicked on is attributed to the “Users Also Looked At” item list. 
        - On this page, there is also an “Users Also Looked At” item list. User clicks on the first selected earbud (**item_id = earbud2**). The earbud is now attributed to the “Users Also Looked At” item list and is no longer attributed to the initial Item-level promotion.
3. User completes the purchase, and GA4 adds some logic to the result, namely that Item-level trumps the Event-level.
    - The phone (**item_id = phone1**) is attributed to the “**Promotion 3 with Items**” promotion. The promotion didn’t have any Item List, so no Item Lists are attributed. If the promotion also had an Item List, this list would have been attributed.
    - The earbud (**item_id = earbud2**) is attributed to the “**Users Also Looked At**” item list, but in addition, since this item doesn’t have any Item-level promotion, the Event-level promotion “**Promotion 2 without Items**” is also attributed to the earbud. 
      - Since Item-level trumps Event-level, “**Promotion 2 without Items**” is not attributed to the phone, since this has an Item-level promotion attributed.

### First Click Attribution
In the same scenario, but using First Click Attribution, this would be the result:

1.	Both the phone (**item_id = phone1**) and the earbud (**item_id = earbud2**) would both be attributed to the Item-level “**Promotion 3 with Items**” bundle promotion.
    - “**Users Also Looked At**” item list would not be attributed to the sale.
    - None of the Event-level promotions “**Promotion 1 without Items**” or “**Promotion 2 without Items**” would be attributed since Item-level trumps Event-level.

## Estimating cost
### Firestore
At the time of creating this solution, **50,000 Document Reads**, **20,000 Document Writes** and **20,000 Document Deletes** are free per day. See **[Firestore pricing](https://cloud.google.com/firestore/pricing)** for complete information.

Estimating potential cost is difficult, so use these numbers just as rough guidance.

#### Firestore Write
Number of writes would be around the same count of select_item, select_promotion and add_to_cart. If you use Cloud Functions to rewrite **expire_at**, estimate the count to be almost doubled.

#### Firestore Read
Number of Reads is difficult to estimate. Sum all GA4 Events that Reads from Firestore, and multiply that with 5. If you use Cloud Functions to rewrite **expire_at**, estimate the count to be almost doubled.

#### Firestore Delete
This depends on how miuch traffic you have (more users equals more data stored), how often users return, and how many days you store the data in Firestore. Expect this cost to low

### Server-side GTM
Server-side GTM cost will also be affected since attribution requires SGTM to do the processing.
