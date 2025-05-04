# GA4 - Item List & Promotion Attribution - SGTM Variable (Server)
**Google Analytics 4 (GA4)** has **Item List & Promotion reports**. But - no revenue or conversions are attributed back to Promotion or Item Lists. You have to do this attribution yourself.

This Variable for  **Server-side GTM** makes it possible to attribute **GA4 Item List**, **Promotion** & **Search Term** to revenue or ecommerce Events (ex. purchase) & Items:
* Last Click Attribution
* First Click Attribution
* Reset/delete Attribution Data after Purchase
* Attribution Time (for how long should Item List or Promotion be attributed)
  * Attribution Time can be either **GA4 Session** or **Custom Attribution Time**

![GA4 Item List Attribution example](images/ga4-item-list-attribution-animation.gif)

This Template is available in the **[Google Tag Manager Template Gallery](https://tagmanager.google.com/gallery/#/owners/gtm-templates-knowit-experience/templates/sgtm-ga4-ecom-item-list-promo-attribution)**.

A similar [Variable Template do also exist for **GTM (Web)**](https://github.com/gtm-templates-knowit-experience/gtm-ga4-ecom-item-list-promo-attribution). Differences between doing the attribution with GTM (Web) vs. Server-side GTM (SGTM) are listed below.

| Functionality  | GTM (Web) | Server-side GTM |
| ------------- | ------------- | ------------- |
| Cross (sub)domain tracking | No * | Yes |
| Server to Server-side (Measurement Protocol) | No | Yes |
| Attribution/processing | Users browser | Server-side |
| Storage Limitation | Yes | No |
| Costs Money | No | Yes |

\* Cookies can do cross subdomain tracking, but are not very suitable due to very low storage capasity.

In the following documentation, **[Firestore](https://cloud.google.com/firestore/)** will be used to handle the attribution.

Firestore data example below.
![Firestore storage example](images/firestore-storage-example.png)

## Google Cloud & Firestore Setup
If you want an easier understanding of cost, it’s recommended to create a **[new Google Cloud Project](https://console.cloud.google.com/projectcreate)** for the Firestore setup.

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

## Server-side GTM Setup

### Manual Setup
Install the following Server-side GTM Templates:
* **GA4 - Item List & Promotion Attribution** (this Variable Template)
* [**Firestore Writer with TTL Tag**](https://github.com/gtm-templates-knowit-experience/sgtm-firestore-writer-with-ttl-tag)
    * At the time of writing, this Tag is not vailable in Google Tag Manager Template Gallery.
* [**sha256 Hasher**](https://tagmanager.google.com/gallery/#/owners/gtm-templates-simo-ahava/templates/sha256-hasher) Variable

#### Create Variables
We must create a decent number of Variables. Suggested Variable names are listed below, and are also used throughout the documentation.
*	ecom - attribution time - minutes - C
*	ecom - item_list & promotion - Lookup - Events - LT
*	GA(4) - client_id - ED
*	GA(4) - client_id - sha256 - hex
*	ecom - item_list & promotion - Firestore - FL
*	ecom - item_list & promotion - extract - CT
*	ecom - items - ED
*	ecom - items - item_list & promotion - merge - CT
*	ecom - items - item_list & promotion - merge - LT
*	++

### ecom - attribution time - minutes - C
As standard, attribution time is the same as a **[GA4 Session](https://support.google.com/analytics/answer/9191807)**, but you can choose a **Custom Attribution Time** if that better fits your users behaviour.

Create this variable if you are going to use **Custom Attribution Time**.

Since attribution time is referenced in several variables, it’s recommended to create a Constant Variable with the attribution time in minutes.
How long the custom attribution time should be is up to you. Time is counted from the last **select_promotion**, **select_item** or **add_to_cart** Event. 

![ecom - attribution time - minutes – C](images/ecom-attribution%20time-minutes-C.png)

* Name the Variable **ecom - attribution time - minutes - C**.

### ecom - item_list & promotion - Lookup - Events - LT
The purpose of this Variable is to give you full control over when to read data from your Secondary Data Source (ex. Firestore), and when to use data from your GA4 Ecommerce implementation.

Ideally your setup should be as shown in the image below. But, if you are using Firestore and want to limit number of Firestore Reads to save some money, you can remove some of the Events from this Lookup Table.Data from the implementation will be used for all Ecommerce Events that isn’t listed in this Lookup Table.

The following Events are necessary: **purchase, begin_checkout & add_to_cart** for a complete **GA4 Item lists: Item list** name report

![ecom - item_list & promotion - Lookup - Events - LT](images/ecom-item_list-and-promotion-Lookup-Events-LT.png)

* Name the Variable **ecom - items - item_list & promotion - Lookup - Events - LT**.

### GA(4) - client_id - ED
The Client Id is going to be used as an identifier in this solution.
Create an **Event Data** Variable and add **client_id** as **Key Path**.

![GA(4) - client_id – ED](images/GA(4)-client_id-ED.png)

*	Name the Variable **GA(4) - client_id - ED**.

### GA(4) - client_id - sha256 - hex
With Server-side GTM, the **Client ID** can sometimes come from the **_ga** cookie, and other times from the **FPID** cookie if you have chosen **Migrate from JavaScript Managed Client ID** in SGTM. Client ID from the FPID cookie can sometimes contain / (slash). An id with a slash can’t be a document in Firestore (the document would be broken).

To get around this potential issue, we **hash the Client ID encoded as hex**. Create a **sha256 Hasher** Variable, and **Value to hash** should be **{{GA(4) – client_id - ED}}**.

In addition, using data pseudonymization or anonymization when you can is always a good thing.

![GA(4) - client_id - sha256 – hex](images/GA(4)-client_id-sha256-hex.png)

* Name the Variable **GA(4) - client_id - sha256 - hex**.

### ecom - item_list & promotion - Firestore - FL
We are using the **Firestore Lookup** to read data from Firestore. You can query Firestore using either **Document Path**, or **Collection & query**. We are using Collection & query simply because this will not throw any warnings in Server-side GTM Preview if you query an id that doesn’t exist (yet).
How to name and organize your Firestore document is up to you, but these are the settings used in this example:

*	**Document Path:** ecommerce
*	**Field:** _id ==_ {{GA(4) - client_id - sha256 - hex}}
*	**Key Path:** int_attribution
*	**Project ID:** _Your GCP Project ID_

![ecom - item_list & promotion - Firestore – FL](images/ecom-item_list-and-promotion-Firestore-FL.png)

* Name the Variable **ecom - item_list & promotion - Firestore - FL**.

### ecom - item_list & promotion - extract - CT
Select the **GA4 Ecommerce – Item List & Promotion Attribution** Variable (this Template). This variable will **extract Item List & Promotion dat**a from GA4 Ecommerce and create the attribution. With other words, attribution happens at collection time.

This variable will do both Firestore Read and Write.

*	**Variable Type:** Extract Item Lists & Promotion for Attribution
*	**Second Data Source:** {{ecom - item_list & promotion - Firestore - FL}}
* Attribution
  * **Delete Attribution Data after Purchase:** Tick this box to delete/reset attribution data after a purchase has happened.
    * You only need this setting for the Variable that attribute Items. Not necessary for Event-level attribution Variables.
  * **Custom Attribution Time:** Tick this box if you are using **Custom Attribution Time**
    * **Attribution Time in Minutes:** {{ecom - attribution time - minutes - C}}
  * **Attribution Type:** Select Last or First Click Attribution
* Other Settings
  * **Handle data as string:** This will save attribution data as a string. Not relevant when using Firestore.
  * **Limit Items:** This will limit number of Items stored. Not relevant when using Firestore.

![ecom - item_list & promotion - extract – CT](images/ecom-item_list-and-promotion-extract-CT.png)

* Name the Variable **ecom - item_list & promotion - extract - CT**.

### ecom - items - ED
Create an **Event Data** Variable and add **items** as **Key Path**.

![ecom - items – ED](images/ecom-items-ED.png)

*	Name the Variable **ecom - items - ED**.

In addition, you must create **Promotion & Search Term Variables** using the same Variable Type if you have implemented **Promotion without Items**, or if you want to attribute **Search Term**:

| Variable Name  | Key Path |
| ------------- | ------------- |
| ecom - location_id - ED | location_id |
| ecom - promo - creative_name - ED | creative_name |
| ecom - promo - creative_slot - ED | creative_slot |
| ecom - promo - promotion_id - ED | promotion_id |	
| ecom - promo - promotion_name - ED | promotion_name |	
| search_term - ED | search_term |	

### ecom - items - item_list & promotion - merge - CT

Select the **GA4 Ecommerce – Item List & Promotion Attribution Variable** (this Template). This Variable merges Implemented data & data from Second Data Source (ex. Firestore).

* **Variable Type:** Return Attributed Output
* **Output:** Items
* **Add Search Terms To Items:** If you tick this checkbox, **search_term** will be added to **items**. This makes it easier to report search_term related to items. You must create an **Item scoped Dimension** in GA4.
  * This selection is only available for **Items**
* **Second Data Source:** {{ecom – item_list & promotion – Firestore – FL}}
* Attribution
  * **Custom Attribution Time** Tick this box if you are using **Custom Attribution Time**
    * **Attribution Time in Minutes:** {{ecom - attribution time - minutes - C}}

![ecom - items - item_list & promotion - merge – CT](images/ecom-items-item_list-and-promotion-merge-CT.png)

*	Name the Variable **ecom - items - item_list & promotion - merge - CT**.

In addition, you must create **Promotion & Search Term Variables** using the same Variable Type if you have implemented **Promotion without Items**, or if you want to attribute **Search Term**:

| Variable Name  | Output |
| ------------- | ------------- |
| ecom - location_id - merge - CT | Location ID |
| ecom - promo - creative_name - merge - CT | Creative Name |
| ecom - promo - creative_slot - merge - CT | Creative Slot |
| ecom - promo - promotion_id - merge - CT | Promotion ID |	
| ecom - promo - promotion_name - merge - CT | Promotion Name |	
| ecom - search_term - merge - CT | Search Term |	

### ecom - items - item_list & promotion - merge - LT
This Lookup Table controls when to use merged (attributed) items data, and when to use implemented data.

*	**Input Variable:** {{ ecom - items - item_list & promotion - Lookup - Events - LT}}
*	**Input:** true
*	**Output:** {{ecom - items - item_list & promotion - merge - CT}}
*	**Default Value:** {{ecom - items - ED}}

![ecom - items - item_list & promotion - merge – LT](images/ecom-items-item_list-and-promotion-merge-LT.png)

* Name the Variable **ecom - items - item_list & promotion - merge - LT**.

In addition, you must create **Promotion & Search Term Variables** using the same Variable Type if you have implemented **Promotion without Items**, or if you want to attribute **Search Term**:

| Variable Name  | Output | Default Value |
| ------------- | ------------- | ------------- |
| ecom - location_id - merge - LT | {{ecom - location_id - merge - CT}} | {{ecom - location_id - ED}} |
| ecom - promo - creative_name - merge - LT | {{ecom - promo - creative_name - merge - CT}} | {{ecom - promo - creative_name - ED}} |
| ecom - promo - creative_slot - merge - LT | {{ecom - promo - creative_slot - merge - CT}} | {{ecom - promo - creative_slot - ED}} |
| ecom - promo - promotion_id - merge - LT | {{ecom - promo - promotion_id - merge - CT}} |	{{ecom - promo - promotion_id - ED}} |
| ecom - promo - promotion_name - merge - LT | {{ecom - promo - promotion_name - merge - CT}} |	{{ecom - promo - promotion_name - ED}} |
| ecom - search_term - merge - LT | {{ecom - search_term - merge - CT}} |	{{search_term - ED}} |

## Trigger
### ecom - attribute Events

Create a Custom Trigger Type with the following settings:  
* **This trigger fires on:** Some Events
* **Client Name** _equals_ GA4 (the name you have given your GA4 Client)
* **Event Name** *matches RegEx* ^(select_item|select_promotion|add_to_cart|purchase)$
  * **purchase** Event in RegEx is only needed if you want to delete/reset attribution data after purchase
  *  If you are going to attribute **search_term** as well, RegEx should be **Event Name** *matches RegEx* ^(select_item|select_promotion|add_to_cart|purchase|view_search_results)$
* **ecom – item_list & promotion – extract – CT** _does not equal_ undefined

![ecom - select_item, select_promotion & add_to_cart](images/Trigger-ecom-select_item-select_promotion-add_to_cart.png)

*	Name the Trigger **ecom - attribute Events**.

## Tags

### Ecom - Item List & Promotion Attribution – Firestore
Select the [**Firestore Writer with TTL** Tag](https://github.com/gtm-templates-knowit-experience/sgtm-firestore-writer-with-ttl-tag), and add the following settings:

* **Firebase Path:** ecommerce/{{GA(4) - client_id - sha256 - hex}}
* Override Firebase Project ID
  * **Firebase Project ID:** your-project-id
* Add Time to Live
  * **Time to Live field name:** expire_at
  * **Time To Live:** 7
* Custom Data
  * **Field Name:** int_attribution
  * **Field Value:** {{ecom - item_list & promotion - extract - CT}}
  * **Field Name:** id
  * **Field Value:** {{GA(4) - client_id - sha256 - hex}}

![Ecom - Item List & Promotion Attribution – Firestore](images/GA4-Item-List-and-Promotion-Attribution-Firestore-TTL.png)

* Add **ecom - attribute Events** as a Trigger to the Tag.

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
| search_term | {{ecom - search_term - merge - LT}} | If you want to attribute search_term |

![GA4 Tag – Parameters to Add/Edit](images/Tag-GA4-Parameters-to-Add-or-Edit.png)

Your Server-side GTM setup is now complete.

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

![select_promotion & view_promotion](images/gtm-ga4-tag-select_promotion.png)

### select_item & view_item_list
This setup handles both **select_item** & **view_item_list**, with **Event-level Item Lists**. **location_id** is set to **Page Path**.

![select_promotion & view_promotion](images/gtm-ga4-tag-select_item.png)

### add_to_cart & view_item
This setup handles **add_to_cart** & **view_item**. **location_id** in this setups is also **Page Path**, but Page Path will only be returned if **item_list_name** or **item_list_id** exist. Otherwise **location_id** will be **undefined**.

![select_promotion & view_promotion](images/gtm-ga4-tag-add_to_cart-view_item.png)

## Attribution explained

This solution can do either **Last Click** or **First Click Attribution**.

Attribution happens on 2 levels: 
1. Event-level
    - Promotion without Items
    - Search Term
2. Item-level
    - Implemented Items data (ex. Item List name) trumps attributed Items data. Ex. if you are adding a Item to cart directly from a Item List, the implemented Item List Name will be used. If you are adding the Item to cart from a product page (where you shouldn't have a Item List implemented), the attributed Item List Name will be used.
	- Item Scoped Item List & Promotion attribution are independent of each other. 

* Item-level trumps the Event-level.
  * Promotion without Items will not be attributed to a Item when Promotion with Items are attributed 

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
        - On this page, there is also an “Users Also Looked At” item list. User clicks on the first selected earbud (**item_id = earbud2**). The earbud is now attributed to the “Users Also Looked At” item list, but is still attributed to the initial Item-level promotion. This because Item Lists and Promotion attribution are independent.
3. User completes the purchase, and GA4 adds some logic to the result, namely that Item-level trumps the Event-level.
    - The phone (**item_id = phone1**) is attributed to the “**Promotion 3 with Items**” promotion. The promotion didn’t have any Item List, so no Item Lists are attributed. If the promotion also had an Item List, this list would have been attributed.
    - The earbud (**item_id = earbud2**) is attributed to the “**Users Also Looked At**” item list, but in addition, since this item doesn’t have any Item-level promotion, the Event-level promotion “**Promotion 2 without Items**” is also attributed to the earbud. 
      - Since Item-level trumps Event-level, “**Promotion 2 without Items**” is not attributed to the phone, since this has an Item-level promotion attributed.

### First Click Attribution
In the same scenario, but using First Click Attribution, this would be the result:

1.	Both the phone (**item_id = phone1**) and the earbud (**item_id = earbud2**) would both be attributed to the Item-level “**Promotion 3 with Items**” bundle promotion.
    - “**Users Also Looked At**” item list would also be attributed to the sale, since Item Scoped Item Lists & Promotion are independent.
    - None of the Event-level promotions “**Promotion 1 without Items**” or “**Promotion 2 without Items**” would be attributed since Item-level trumps Event-level.

## Estimating cost
### Firestore
At the time of creating this solution, **50,000 Document Reads**, **20,000 Document Writes** and **20,000 Document Deletes** are free per day. See **[Firestore pricing](https://cloud.google.com/firestore/pricing)** for complete information.

Estimating potential cost is difficult, so use these numbers as a rough guidance.

#### Firestore Write
Number of writes would be around the same count of select_item, select_promotion and add_to_cart. If you use Cloud Functions to rewrite **expire_at**, estimate the count to be almost doubled.

#### Firestore Read
Number of Reads is difficult to estimate. Sum all GA4 Events that Reads from Firestore, and multiply that with 5-8. If you use Cloud Functions to rewrite **expire_at**, the coundt can be more than doubled.

#### Firestore Delete
This depends on how miuch traffic you have (more users equals more data stored), how often users return, and how many days you store the data in Firestore. Expect this to be the lowest Firestore cost.

### Server-side GTM
Server-side GTM cost will also be affected since attribution requires SGTM to do the processing.
