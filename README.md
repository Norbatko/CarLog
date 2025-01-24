# CarLog

This guide provides steps to set up and run the Flutter application on an Android device or emulator.

## Prerequisites

- **Flutter SDK:** Ensure Flutter is installed on your machine. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).
- **Android Studio/SDK:** Install Android Studio or at least the Android SDK on your machine.

## Steps

### 1. Install Dependencies

Navigate to the root directory of the CarLog project and install the required dependencies:

```bash
cd <project_directory>
flutter pub get
```

### 2. Set Up Android Virtual Device (AVD)

- **Using Android Studio:** Open Android Studio and create a virtual device using the AVD Manager. Ensure it matches the target API level of your Flutter app.

- **Using Command Line:** Alternatively, set up a virtual device using command line tools like `avdmanager` or `emulator`.

### 3. Run the App

- Ensure your Android device (or emulator) is running and accessible.
- In the project directory, execute the following command to run the app on the connected Android device:

```bash
flutter run
```

- If targeting a specific device, use the `-d <device_id>` flag where `<device_id>` is the identifier of your virtual device.

### Notes

- Verify that required Android SDK versions are installed.
- Check Flutter and Dart SDK paths are correctly configured.
- Ensure any platform-specific configurations (e.g., API keys) are set up properly on your local machine.