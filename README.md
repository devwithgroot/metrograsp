# Metrograsp

Metrograsp is a period tracker app developed as a submission round project for Metrograsp. The app aims to provide users with an easy way to track their menstrual cycle, get notifications about upcoming periods, and monitor related health metrics. The app is built with potential future expansions in mind, with features such as user authentication, real-time updates, and dynamic form submissions. The final goal is to integrate these features into a super app for Metrograsp.

## Key Features Overview

- **User Authentication (Login/Signup)**: Allows users to securely create an account and log in to access personalized features.
- **Real-Time Updates**: The app tracks the user’s period cycle and provides notifications based on their cycle dates.
- **Dynamic Form Submissions**: Users can input their period start and end dates, and the app will calculate the next cycle, notifying them in advance.

## Step-by-Step Setup Instructions

### Prerequisites

1. **Flutter SDK**: Make sure Flutter SDK is installed on your system.
2. **Firebase Setup**: Create a Firebase project and add the necessary Firebase configuration to your app (Google services JSON file).
3. **Permissions**: Ensure the required permissions for notifications and alarm management are handled in the app.

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repository-url
   cd metrograsp
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Set up Firebase:
   - Go to Firebase Console and create a project.
   - Download the `google-services.json` file and add it to your `android/app` directory.

4. Update your package name in the `AndroidManifest.xml` file as `com.sandeep.metrograsp`.

5. Make sure to configure any necessary Firebase services like Firestore and Authentication.

6. Run the app:
   ```bash
   flutter run
   ```

## Dependencies

- **cupertino_icons**: Provides iOS-style icons.
- **animated_text_kit**: For animated text effects.
- **firebase_core**: Core library for Firebase integration.
- **firebase_auth**: For user authentication with Firebase.
- **cloud_firestore**: For Firebase Firestore database.
- **modal_progress_hud_nsn**: For displaying progress indicators.
- **intl**: For internationalization and date/time formatting.
- **carousel_slider**: For creating a carousel effect.
- **fl_chart**: For displaying charts related to the user’s cycle data.
- **flutter_local_notifications**: For scheduling and displaying local notifications.
- **timezone**: For handling time zone-specific notifications.
- **permission_handler**: For requesting permissions for notifications and alarms.

---
