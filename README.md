# classico

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
A new Flutter project.

**Assignment Title:** Flutter App with Back4App Integration

**Assignment Description:** In this assignment, you will create a Flutter app that connects to Back4App, a Backend-as-a-Service (BaaS) platform, to manage tasks. You will be responsible for setting up the Back4App backend, creating the Flutter app, and implementing the necessary features to interact with the backend.

**Getting Started**
This app uses Back4App for the database, please create an account for the same. Once the account is created, create a new table named 'Task' and add two string columns named title and description. Replace the application key and client keys in the code to connect your application to the database.
Prerequisites An account on Back4App. Flutter (version 2.2.x or later). Android Studio or VS Code with Dart and Flutter plugins installed​​.

Set Up and Run Back4App Setup: Sign up and create a new app on Back4App. Define a class named Task with columns for title and description​​. Flutter Setup: Create a new Flutter project and add the necessary dependencies for Parse in the pubspec.yaml file​​. Running the App: Navigate to the project directory and use flutter run to start the application​​.

final keyApplicationId = 'YOUR_APPLICATION_KEY_HERE';

final keyClientKey = 'YOUR_CLIENT_KEY_HERE';

Clone the repository and go to the project folder in the command line. Run the below command to resolve dependencies (the newly added dependency is parse sdk).

flutter pub get

Once the above command is successful, run the command to start the application.

flutter run.

Now we can see a model getting built and data will be stored in the backend.
