# NASA Rover App

NASA Rover App allows users to view photos taken by NASA's Mars rovers throughout their operational periods. The data is fetched via the official NASA API.

## 🚀 Features

⚠️ Current Limitations:

Filtering by date and camera is not yet implemented.

Due to external API limitations, photos currently load only for the Curiosity rover, while Spirit and Opportunity do not return results.

📸 Browse NASA rover photos

🔍 Filter by date, camera, and rover

🔍 Open and zoom in on photos for a detailed view

❤️ Save photos to favorites

💾 Save photos in user's Photo Library

## 🛠 Technologies

Swift

SwiftUI

SwiftData

Combine

MVVM

## 📸 Screenshots

| Home Screen   | Rover Screen |
| ------------- |:-------------:|
|    <img src = "https://github.com/user-attachments/assets/3a9982c7-93c0-416e-8c86-9ffd83f0f463" width="280">| <img src = "https://github.com/user-attachments/assets/67892c88-c971-4f4d-a83f-758a6b7bb3d2" width="280">|



## 📦 Installation

1. Clone the repository.

2. Open the project in Xcode.

3. Build and run the app on a simulator or device.

## 🔑 API Key

To use the NASA API, you need an API key. Get one [here](https://api.nasa.gov).

Add the key to your Config.plist:

```xml
<key>apiKey</key>
<string>YOUR_API_KEY_HERE</string>
```

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENCE) file for details.

## 👨‍💻 Author

Arseny89

## Design Credits

The design of the main page was sourced from [Sketch App Sources](https://www.sketchappsources.com) and created by [Sidharth Sahoo](https://www.sketchappsources.com/contributor/sidharthsahoo). All credits go to the original designers.
