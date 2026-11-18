# GA4 - Item List & Promotion Attribution - SGTM Variable (Server)
**Google Analytics 4 (GA4)** has **Item List & Promotion reports**. But - no revenue or conversions are attributed back to Promotion or Item Lists. You have to do this attribution yourself.

This Variable for  **Server-side GTM** makes it possible to attribute **GA4 Item List**, **Promotion** & **Search Term** to revenue or Ecommerce Events (ex. purchase) & Items.

**Update**: Any **Item & Event scoped parameter** can now be attributed.

* Last Click Attribution
* First Click Attribution
* Reset/delete Attribution Data after Purchase
* Attribution Time (for how long should Item List or Promotion be attributed)
  * Attribution Time can be either **GA4 Session** or **Custom Attribution Time**
* Works with both **Web** and **App** data (see [App setup](#app-setup))

![GA4 Item List Attribution example](images/ga4-item-list-attribution-animation.gif)

This Template is available in the **[Google Tag Manager Template Gallery](https://tagmanager.google.com/gallery/#/owners/gtm-templates-knowit-experience/templates/sgtm-ga4-ecom-item-list-promo-attribution)**.

A similar [Variable Template also exists for **GTM (Web)**](https://github.com/gtm-templates-knowit-experience/gtm-ga4-ecom-item-list-promo-attribution). Differences between doing the attribution with GTM (Web) vs. Server-side GTM (SGTM) are listed below.

| Functionality  | GTM (Web) | Server-side GTM |
| ------------- | ------------- | ------------- |
| Cross (sub)domain tracking | No * | Yes |
| Server to Server-side (Measurement Protocol) | No | Yes |
| App supported | No | Yes |
| Attribution/processing | Users browser | Server-side |
| Storage Limitation | Yes | No |
| Costs Money | No | Yes |

\* Cookies can do cross subdomain tracking, but are not very suitable due to very low storage capacity.

## Attribution solutions

2 different solutions for handling the attribution are presented:

1. [**Firestore** solution](01-Firestore):
	* [Firestore](https://cloud.google.com/firestore/) is a serverless, NoSQL document database from **Google**.
2. [**Stape Data Store** solution](02-Stape-Store):
	* [Data Store](https://stape.io/solutions/data-store?pt=vsahefle&rs=site&rr=eu) is a serverless, NoSQL document database from [**Stape**](https://stape.io?pt=vsahefle&rs=site&rr=eu).
		* If you are running Server-side GTM using Stape, Data Store is recommended. Data Store was previously called Stape Store.

Firestore data example below.
![Firestore storage example](images/firestore-storage-example.png)

## Attribution explained

This solution can do either **Last Click** or **First Click Attribution**.

Attribution happens on 2 levels: 
1. Event-level
    - Promotion without Items
    - Search Term
	- Custom Event Parameters
2. Item-level
    - Implemented Items data (ex. Item List name) trumps attributed Items data. Ex. if you are adding a Item to cart directly from a Item List, the implemented Item List Name will be used. If you are adding the Item to cart from a product page (where you shouldn't have a Item List implemented), the attributed Item List Name will be used.
	- Item Scoped Item List & Promotion attribution are independent of each other. 

* Item-level trumps the Event-level.
  * Promotion without Items will not be attributed to a Item when Promotion with Items are attributed 
  * With the **Add Event-level Promotion to Items** setting, the attributed Event-level promotion (including **location_id**) is added to Items that don't have a promotion of their own.

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

## Web implementation
To make the attribution work, also the implementation on the website must be correct. It’s especially implementation of Item List that can be incorrect.

**All attribution in this solution is tied back to the following Events:**
*	select_item, add_to_cart (from a list) or select_promotion
*	search (or view_search_results), if you attribute **Search Term**
*	Any Event that contains the **Custom Item or Event Parameters** you have chosen to attribute

When it comes to filling out the **location_id** parameter, if you don’t have **Place ID** as Google suggest using, fill this parameter with **Page Path** instead. Then you will get Page Path attributed as well.

The GA4 Event documentation allows for implementation of Item List and Promotion on both the Event-level and Item-level. This Template supports both implementations.

### Promotion implementation
It’s recommended to implement all promotion parameters, but as a minimum for this attribution to work you must implement either **promotion_id** or **promotion_name** with the **[select_promotion](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#select_promotion)** Event.

### Item List Implementation

The following Events should have Item List implemented. The rest of the ecommerce Events will read the Item List data using this Template.
*	[view_item_list](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#view_item_list)
* [select_item](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#select_item)
* [add_to_cart](https://developers.google.com/analytics/devguides/collection/ga4/reference/events#add_to_cart)

Implementing Item List for the **add_to_cart** Event has one exception. Item Lists should only be implemented if the Item is added to cart directly from an Item List. 

You should never implement a **Product Page Item List**. The reason for this is that this will overwrite the Item List the user arrived from (ex. a “Related Products” list), and you will not be able to tell how well the “Related Products” list is working in terms of sales.

## GTM (Web) Setup
To make the attribution work, the **GTM (Web)** setup must also be correct.

### select_item, view_item_list, select_promotion & view_promotion
One GA4 Event Tag handles **select_item**, **view_item_list**, **select_promotion** & **view_promotion**. Ecommerce data is read from the Data Layer.

![select_item, view_item_list, select_promotion & view_promotion](images/gtm-ga4-tag-select_item-select_promotion.png)

### location_id
**location_id** is set up in **Server-side GTM**, in the same way for Web and App. You don't have to add **location_id** in GTM (Web). If you do (as in the image above), the implemented value is kept.

* **select_item** & **select_promotion** get **location_id** from a Transformation.
* **add_to_cart** gets **location_id** from the **Location ID Value** setting in the Template, but only when the Item is added to cart from an Item List. For this to work, an **add_to_cart** from a product page must not send **item_list_id**, **item_list_name** or Promotion parameters.

See the [Firestore](01-Firestore) or [Stape Data Store](02-Stape-Store) setup for details.

## App setup
The Template also works with **App data** sent to Server-side GTM with the **GA4 (App)** Client. The implementation requirements described above for the website are the same for the app, and the Server-side GTM setup is identical to the Web setup, with the exceptions below.

### Identifier
Apps don't have a **client_id**. Use an identifier that exists for your app data instead, ex. **x-ga-app_instance_id** (Event Data), and use it everywhere the Web setup uses the Client ID / User ID.

### Attribution Time
As standard, attribution time is the same as a GA4 Session. For apps, the session id is read from the user properties sent with the Event. No setup is needed.

### Client Name
Triggers and Transformations in the setup use **Client Name** as a condition. Use the name of your **GA4 (App)** Client for the app setup.

### location_id
Apps don't have a Page Path, so the **screen name** is used as **location_id** instead. The setup is the same as for Web: the **ecom - location_id - value - LT** Variable returns the screen name for your **GA4 (App)** Client.

---

Solution by [**Eivind Savio**](https://www.savio.no/google-tag-manager/ga4-item-list-promotion-search-term-attribution-with-gtm?utm_source=github.com&utm_medium=referral&utm_campaign=knowit-ai-analytics&utm_content=sgtm-ga4-ecom-item-list-promo-attribution) from [**Knowit AI & Analytics**](https://www.knowit.no/?utm_source=github.com&utm_medium=referral&utm_campaign=knowit-ai-analytics&utm_content=sgtm-ga4-ecom-item-list-promo-attribution) (Oslo, Norway). Not officially supported by Knowit.
