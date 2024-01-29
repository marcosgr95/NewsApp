# Welcome to NewsApp!

This is a project to showcase my skills in SwiftUI + Combine. The project consists of a simple news app that retrieves data from https://newsapi.org.

The code is pretty self-explanatory, so here we'll focus on the structure of the app and some demoing of it.

## Sections of the app

The app consists, mainly, of two sections:

1. News list
2. News detail

### News list

Here the user can see the top headlines of the moment. Besides, they can also filter by text (for which we've added a floating button as an accessibility bonus!). In case there are no news to be had, an error ocurred while or after fetching the data, or the query by text yields no results, the user we'll be told what happened.

A system of pagination has been implemented to prevent the user from over fetching data, thus potentially harming their cellular data use.

Next we have the app in action in the aforementioned cases:


*News list*

---
<img src='https://github.com/marcosgr95/NewsApp/assets/26648516/2685da8d-5cb3-470e-8e9a-3444877d9ba5' alt='News List' width='500'/>

*Loading animation*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/2d17ab35-5e53-4dbc-af7c-2bf1442731fc" alt="Loading animation" width="500"/>

*Fetching more data / Paginating*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/e96f2604-2c4d-450a-9ddd-c18ff0848565" alt="Paginating" width="500"/>

*Filtering by text*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/a85f0e8e-6207-4a98-8539-4040e33d373e" alt="Filtering by text" width=500/>

*No results*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/c896bd1f-e1ef-4dd9-8f7b-f4d71527ffe3" alt="No results screen" width=500/>

*Error screen*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/eceef99b-3c27-44eb-8d0b-cbe582dc19ec" alt="Error screen" width=500/>


### News detail

Much as the list, some data about the news piece is displayed in the detail. However, here we can see the whole event thanks to a webView, to which we can access via a floating button. There's another floating bottom at the top left to pop the detail and go back to the list.

*Detail screen*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/3faa06ae-ecbe-4943-aa81-2e111ed3fbe5" alt="Detail screen" width=500/>

*In-app Safari webView*

---
<img src="https://github.com/marcosgr95/NewsApp/assets/26648516/b7a665e2-b153-452e-a040-b7786b5e3f73" alt="Safari web view" width=500/>
