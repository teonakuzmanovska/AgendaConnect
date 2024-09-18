# Client meeting scheduling system - AgendaConnect

Flutter-based client meeting scheduler aimed at synchronizing all meetings in one place to enhance professional organization. This README provides an overview of the project, Firebase setup instructions, and a description of the app's features.<br><br>

##  Project Description

AgendaConnect is a Flutter-based app designed to manage client meetings efficiently. Users can create, manage, and store meetings using Firebase Firestore. The app supports scheduling, specifying meeting locations, saving client details, and integrating various location-based features.<br><br>

## Features

### Firebase Integration
The app uses Firebase services for authentication and real-time database functionality. To integrate Firebase into your Flutter project:

Add Firebase core to your project by running the following command:

    flutter pub add firebase_core

Additional Firebase plugins used:

- `firebase_auth` for user authentication.

- `cloud_firestore` for real-time database.

<br>

### Meeting Management<br>
**Client Repository** : Fetches and manages client data from Firestore.<br>

**Meeting Repository** : Handles meeting details like client, location, and date-time.
Create Meeting Form: Allows users to add meetings, select clients, and set locations via a map.<br><br>

### Custom UI Elements<br>
AgendaConnect incorporates several custom UI elements for a clean and functional user interface:

**Group Card Widget** : Displays client and meeting information in a visually engaging format.<br><br>
**Location Map Preview** : Provides an interactive map overview for each meeting.<br><br>

### Mobile Design Patterns<br>
AgendaConnect integrates effective mobile design patterns for enhanced user experience:

**Tab Bar Navigation** : Organizes content into tabs for easy access.<br>

**List View** : Displays client and meeting details efficiently.<br>

**Cards** : Uses card-based UI elements to display upcoming meetings, quick actions, and more.

**Splash Screen** : Displays a splash screen with a custom logo for brand consistency.<br>

**Floating Action Button (FAB)** : Provides quick access to adding meetings and clients.<br>

**State Persistence** : Saves and restores user data like location and meeting details, ensuring a seamless experience across app restarts.<br>
<br>
>More on these patterns: [Mobile Desing Paterns](https://www.designrush.com/best-designs/apps/trends/mobile-design-patterns)

<br>

### Location Features<br>
**Location Sensors** : Accesses the user's current location to suggest nearby locations for meetings or to help navigate to the meeting location.<br>

**Geocoding and Geolocation** : Converts location data between coordinates and addresses.<br>

**Google Maps Integration**: Displays meeting locations on a map and allows users to select locations via the map interface.<br><br>

### Calendar Integration
AgendaConnect incorporates a weekly calendar view (via `table_calendar`) to display scheduled meetings, making it easy for users to manage their time. Meetings are color-coded and can be refreshed using pull-to-refresh or automatic refresh.<br><br>

### CRUD Features
Users can manage clients and meetings with add, edit, and delete functionality for easy updates and corrections. Under refinement.<br><br>

### Mobile Sensors
**Gyroscope**: The app responds to changes in device orientation, switching between landscape and portrait modes as needed.

**Location**: Tracks both user and client locations, enhancing location-based functionality for scheduling.

<br>

##  Demo

The following demo demonstrates all features discussed above.

<img src="Screen_Recording_20240918_180558.gif" alt="Demo" width="auto" height="450">


<br>

##  Getting Started

### Prerequisites
To get started with this project, ensure you have:

- Flutter installed.

- A Firebase account to configure Firebase services.


### Clone the repository

https: `git clone https://github.com/teonakuzmanovska/AgendaConnect.git`

ssh: `git clone git@github.com:teonakuzmanovska/AgendaConnect.git`
<br><br>

##  Set up Firebase
### Steps:
1. Create a Firebase project on the Firebase Console.
2. Add the necessary Firebase configuration files:

    `google-services.json` (for Android)

3. Run the following command to install dependencies:

    `flutter pub get`

### Configure Firebase Authentication
Set up authentication and Firestore rules in the Firebase Console to match your app's requirements. Ensure Firebase is correctly configured for user authentication and meeting data management.
<br><br>

## Connecting a device or emulator
**Connecting physical device (recommended)**: Enable developer options on your android device. Then enable USB debbuging

**Connecting emulator**: To start an emulator, open Android Studio, go to AVD Manager, and launch an emulator of your choice.

>You can switch between devices with
`Ctrl + Shift + P -> Flutter: Select Device`

<br>

## Running the App

Add the following dependencies in your `pubspec.yaml` file:

```
cupertino_icons: ^1.0.6
firebase_core: ^3.0.0
firebase_auth: ^5.0.0
intl: ^0.19.0
calendar_view: ^1.0.4
google_maps_flutter: ^2.6.1
flutter_polyline_points: ^1.0.0
location: ^6.0.2
flutter_svg: 2.0.9
envied: ^0.5.4+1
flutter_dotenv: ^5.1.0
geocoding: ^3.0.0
geolocator: ^12.0.0
provider: ^6.1.2
flutter_local_notifications: ^17.2.2
cloud_firestore: ^5.4.0
table_calendar: ^3.1.2
```
Once all dependencies are installed and Firebase is configured, run the app using the following command: 

`flutter run`
