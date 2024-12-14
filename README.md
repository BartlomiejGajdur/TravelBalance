# <p align=center> <a name="top">TravelBalance</a></p>

<p align=center><strong>Official website: <i>https://www.travelbalance.pl</i></strong></p>


## Short overview
**TravelBalance** is a mobile application for iOS and Android designed to help you manage your expenses while traveling. It allows users to easily create trips to any destination, add expenses in any currency, and seamlessly display all statistics, converting them into a chosen base currency. Our goal is to provide a practical solution for managing travel finances and helping travelers stay organized and stress-free.

This app was created by a team of two passionate developers and avid travelers:
- the mobile application frontend and logic was created by me
- the backend and <i><a href="https://www.travelbalance.pl">official website</a></i> were implemented by https://github.com/krzysztofgrabczynski

<br>

## Preview

<p align="center">
  <img src="https://github.com/user-attachments/assets/1e4b0d98-51d7-4402-b492-3e69d2cf7305" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/7c886830-262f-47f8-bad6-2e19aaa0f14d" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/55dd0d2e-ce72-4cea-8e99-21b7d3fb9ddf" width="253" height="549"/>
</p>
<p align="center">
  <img src="https://github.com/user-attachments/assets/2fa2fec7-7009-43d6-83f0-cc51a1377cd5" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/c09ae67a-0620-4748-b9bf-617dd2c3b6d6" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/15e983f1-3ae1-4987-b3d5-369baa9c8436" width="253" height="549"/>
</p>

## Description
TravelBalance is a comprehensive mobile application designed for managing travel expenses, available on both iOS and Android platforms. It lets users add trips by choosing a photo from a set of default images and optionally selecting the countries they plan to visit. Within each trip, expenses can be logged in any currency, and the app automatically converts them to the user's selected base currency (configurable in the main settings). The app provides detailed visual statistics, including graphs showing spending across different categories during each trip. The main screen displays overall statistics, such as the number of trips taken, countries visited, and total spending in the base currency. TravelBalance also offers a Pro version, which removes ads for an enhanced, distraction-free experience.

The app's design was crafted in Figma to ensure a clean and user-friendly interface. I developed the frontend using Flutter, delivering a smooth, responsive experience across both iOS and Android devices. This approach ensures consistency with the app's design patterns while maintaining high performance and visual appeal. The backend was handled by another developer using Django Rest Framework.

To improve user convenience, the app includes TokenAuthentication and social-oauth2, enabling seamless registration and login with Google or Apple ID accounts. Additionally, the app features robust functionality, adhering closely to modern design and usability standards.

## Features
- [x] [user management](#user-management)
- [x] [trip management](#trip-management)
- [x] [toggle trip view](#toggle-trip-view)
- [x] [expense management](#expense-management)
- [x] [set base currency](#set-base-currency)
- [x] [purchase a premium version](#purchase-a-premium-version) 

## User management
- Users can sign up in the traditional way by providing their username, email and password. After registration, they will receive an activation link via email. Clicking this link activates their account and grants access to the platform. Users can also log in using Google Sign-In or Apple Sign-In for a faster and more convenient experience.
<p align="center"><img src="https://github.com/user-attachments/assets/855c35b8-3b97-4b96-b140-b0b29cc635b5" width="253" height="549"/></p>

- Password Recovery:
If users forget their password, they can easily recover it by requesting a 5-digit token, which will be sent to their registered email address. This token can be used to securely reset their password.
<p align="center"><img src="https://github.com/user-attachments/assets/e74e0d63-a925-483e-97b4-e0b9a8524fde" width="253" height="549"/></p>

- Password Management:
Users who registered traditionally can change their password at any time through the application settings.
<p align="center">
  <img src="https://github.com/user-attachments/assets/11e23ff4-0493-4133-8e03-65a0851dcf4b" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/12ebf07e-2679-4a93-99f0-f8105249ca8d" width="253" height="549"/>
</p>

[Go to top](#top) 


## Trip management
Adding/Editing/Deleting a Trip:
Users can create a new trip by providing a name, selecting one of the available default images, and adding the countries they plan to visit. Users can then edit a trip by clicking the edit icon in the top-right corner of the trip view. There are also two ways to delete a specific trip: either during the editing process or by simply swiping left on the trip in the main screen for quick deletion.
<p align="center">
  <img src="https://github.com/user-attachments/assets/d4cf54c4-a1a5-4d27-8ffe-94ad03f1115e" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/e7284f41-7143-4749-8325-1401741d0f15" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/f87f879f-4ecb-4314-813b-9a285dfb715c" width="253" height="549"/>
</p>

[Go to top](#top) 

## Toggle trip view
Users can use a switch on the main screen of the application to toggle between two trip views: normal view with all information and detailed view without images, providing a more streamlined and detailed list.
<p align="center">
  <img src="https://github.com/user-attachments/assets/9db6ea47-c1c8-427b-a0c0-7b762d04fa35" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/e74b1d3a-fa24-48ad-bedf-4517642afc6d" width="253" height="549"/>
</p>

[Go to top](#top) 

## Expense management
Adding/Editing/Deleting an Expense:
Users can add an expense to a trip by providing details such as the name, amount, currency, and category. Every expense can be edited by tapping on it in the expense list. Users can delete an expense in two ways: either during the editing process or by swiping left on the expense in the list for quick deletion.

Note: The value of each expense is displayed in the currency it was originally added in. However, for the total trip expenses, each expense is automatically converted to the base currency, which can be configured by the user in the application settings.
<p align="center">
  <img src="https://github.com/user-attachments/assets/52be91cd-6cbb-4698-a841-06a23fc8ad2c" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/7b3431dc-5be3-4644-8117-4549fb73c46c" width="253" height="549"/>
</p>

[Go to top](#top) 

## Set base currency
In the main settings of the application, users can set their **base currency**. All expenses will be automatically converted to this base currency. This allows users to see the total cost of each trip on the main screen in their chosen base currency, providing a more convenient and consistent view for better user experience. User can change the **base currency** at any time.
<p align="center">
  <img src="https://github.com/user-attachments/assets/0b49ef51-b31d-42d2-9622-e784d3d0f457" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/7efadccc-609b-422e-937e-a7289e794ddc" width="253" height="549"/>
</p>

[Go to top](#top)  

## Purchase a premium version
In the main settings, users can also purchase a lifetime premium version of the app. With the premium version, users will enjoy an ad-free experience and have access to unlimited features, without any restrictions.
<p align="center">
  <img src="https://github.com/user-attachments/assets/e0403d61-e335-44f6-9e76-dcea0d3c40af" width="253" height="549"/>
  <img src="https://github.com/user-attachments/assets/310087f3-b15f-4029-9458-e42f14239c2f" width="253" height="549"/>
</p>

[Go to top](#top) 
