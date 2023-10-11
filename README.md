# Roadside Assistance Provider App

The Roadside Assistance Provider App is a mobile application designed for service providers to manage and fulfill user service requests. It offers a comprehensive set of features, including authentication, real-time service management, and integration with Google Maps for location tracking and navigation. Service providers can accept or reject booking requests, mark services as completed or canceled, and utilize Firebase for authentication, notifications, and data storage.

## Features

- **Authentication:** Secure user authentication with Firebase.
- **Service Management:** Providers can view, accept, or reject service booking requests.
- **Service Status:** Mark services as completed or canceled.
- **Real-time Location:** Real-time user location tracking and navigation with Google Maps integration.
- **Notification:** Push notifications for new booking requests.
- **Firebase Integration:** Utilizes Firebase for authentication, notifications, and data storage.

## Technologies Used

- Android Studio
- Kotlin
- Google Maps API
- RecyclerView and CardView for UI components
- Firebase Authentication for user sign-in and security
- Firebase Realtime Database for real-time service updates and tracking
- Firebase Cloud Messaging (FCM) for push notifications
- Retrofit for API communication

## Getting Started

1. Clone the repository to your local machine:

git clone https://github.com/Rohaid-Bhatti/Provider-App.git

2. Open the project in Android Studio.

3. Build and run the app on an Android emulator or device.

## Usage

- Providers can sign in using Firebase authentication.
- Upon sign-in, providers can view service booking requests.
- Providers can accept or reject booking requests and update the status of services.
- The app displays user locations and provides navigation via Google Maps with polygon lines.
- Push notifications are sent to providers for new booking requests.

## Contributing

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix: `git checkout -b feature-name`.
3. Commit your changes: `git commit -m 'Add new feature'`.
4. Push to your forked repository: `git push origin feature-name`.
5. Create a pull request on the original repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Thanks to Google Maps API for enabling location tracking and navigation.
- Thanks to Firebase for providing real-time database functionality and push notifications.