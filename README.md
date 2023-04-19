# TransferListChallenge
A given challenge to display list of transfer destinations and their detail page 

The Home page loads list of transfer destinations and shows them in two sections:
1. Favorites: Selected items by user as Favorite.
2. All: Loaded items.


#### Scenarios (Acceptance criteria, Home page)

```
Given the customer has connectivity
When the customer requests to see their transfers
Then the app should display the latest transfers from remote

Given the customer has favorites transfers(locally)
When the customer requests to see their favorites transfers
Then the app should display the latest favorites transfers from local cache
otherwise should not display favorites section

Given the customer doesn't have connectivity
When the customer requests to see their favorites transfers
Then the app should display no connectivity label

Given the customer has transfers
When the customer requests to see details of transfers
Then the app should display details page

Given the customer might have many transfers
When the customer requests to see transfers
Then the app should display first 10 item 
and with requesting more items
then the app should fetch more items from remote 
and show to the user new received items from remote

Given the frequency of the transfers
When the customer swipes down the list 
Then the app should refresh the list from remote

```

#### Scenarios (Acceptance criteria, Details page)

```
Given the customer has transfer
When the customer taps on transfer 
Then the app should display detail page with more information 

When the customer taps on add to favorites 
Then the app should saves transfer locally 
and show as favorites on home page

When the customer taps on remove from favorites 
Then the app should remove transfer from local cache 
and update favorites transfers on home page
```

#### Scenarios (Acceptance criteria, Search)(*optional*)

```
Given the customer has transfers
When the customer searches by full_name  
Then the app should search for local items 
and display them in the home page 

Given the customer searched for transfers
when taps on the result   
Then the app should navigate to detail page of that item 

```

## Transfer List API

https://4e6774cc-4d63-41b2-8003-336545c0a86d.mock.pstmn.io/transfer-list/{page-number}


### Transfer

| Property          | Type                |
|-------------------|---------------------|
| `Person`          | `Person`            |
| `card`            | `Card`              |
| `last_transfer`   | `Date`              |
| `more_info`       | `MoreInfo`         |


### person

| Property          | Type                |
|-------------------|---------------------|
| `full_name`       | `String`            |
| `email`           | `String`(optional)  |
| `avatar`          | `String`            |

### Card

| Property          | Type                |
|-------------------|---------------------|
| `card_number`     | `String`            |
| `card_type`       | `String`(optional)  |

### MoreInfo

| Property              | Type   |
|-----------------------|--------|
| `number_of_transfers` | `Int`  |
| `total_transfer`      | `Int`  |


### Payload Contract

GET
200 RESPONSE

{
    "person": {
        "full_name": "Homerus Hammelberg",
        "email": "hhammelberg3@princeton.edu",
        "avatar": "https://www.dropbox.com/s/1j5yn8ao0hkr6w7/avatar2.png?dl=1"
    },
    "card": {
        "card_number": "30582279857081",
        "card_type": "diners-club-carte-blanche"
    },
    "last_transfer": "2022-07-14T02:47:58Z",
    "note": "Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.",
    "more_info": {
        "number_of_transfers": 6,
        "total_transfer": 71949624
    }
}
