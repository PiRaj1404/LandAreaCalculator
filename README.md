# Land Area Calculator

## Overview
"Land Area Calculator" is a Flutter application that allows users to measure the area and perimeter of a space by simply walking around its perimeter. The app uses the device's GPS to track the walk and calculates the area covered.

## Features
- **Start/Stop Walk:** Users can start and stop the walk using buttons in the app.
- **Real-time GPS Tracking:** Tracks the user's location in real-time as they walk around the perimeter of the area.
- **Area and Perimeter Calculation:** Calculates the total area and perimeter based on the GPS coordinates collected during the walk.
- **Display on Map:** Shows the walked path on a Google Map along with the calculated area and perimeter.
- **Unit Conversion:** Allows users to view the area and perimeter in different units (square meters, square feet, etc.).

## Installation
To run "Land Area Calculator," you need to have Flutter installed on your machine. Follow these steps to get started:

### Prerequisites
- Flutter (Channel stable, latest version)
- Dart SDK (version corresponding to Flutter)
- An IDE (e.g., Android Studio, VS Code)
- A valid Google Maps API key for using the Google Maps features

### Setting Up
1. Clone the repository:
   ```bash
   git clone https://github.com/PiRaj1404/LandAreaCalculator
    ```
2. Navigate to the project directory in the repository:
   ```bash
   cd LandAreaCalculator
    ```
3. Install dependenciesryone the repository:
   ```bash
   flutter pub get
    ```
4. Add your Google Maps API key to the application:
- Open android/app/src/main/AndroidManifest.xml
- Replace YOUR_API_KEY_HERE with your actual Google Maps API key.


## Running the application
To run the app on a connected device or emulator, execute the following command:
```bash
flutter run
```

## Usage
After opening the app, follow these steps to use it:
1. Press the 'START' button to begin recording your walk.
2. Walk around the perimeter of the area you wish to measure.
3. Press the 'END' button once you have completed your walk. The app will then display the calculated area and perimeter on the map.
4. You can switch between different measurement units using the dropdown menus provided.


## Contributing
Contributions are welcome! Please read the contributing guidelines before submitting pull requests to the project.

## Contact
For questions or assistance, please contact Piyush at rajkarne@pdx.edu