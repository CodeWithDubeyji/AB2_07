# RaktVeer

## Team Name
3beans4coffee

## Problem Statement
PS 07: BLOOD DONATION & EMERGENCY HELP

## Team Members
- Gaurav Dubey
- Ganesh Mishra
- Himanshu Mishra
- Harsh Goilkar

## Project Description
RaktVeer is a project aimed at creating a seamless connection between blood donors and recipients. The platform will facilitate easy and quick access to blood donations, ensuring that those in need can find donors efficiently.

## Installation
1. Clone the repository.
2. Run npm install in the Backend folder.
3. Create a .env file and set MONGO_URI to your MongoDB connection string.
4. Ensure Flutter SDK and Dart are installed.
5. Go to frontend/my_app directory:
   ```
   cd frontend/my_app
   ```
6. Install dependencies:
   ```
   flutter pub get
   ```

## Commands & Usage
To install dependencies and start the server, run:
```bash
cd Backend
npm install
npm run dev
```
• To run the frontend:  
  ```
  flutter run
  ```
• To build release version:  
  ```
  flutter build apk
  ```

## Usage
1. Start the server with npm start or node index.js in the Backend folder.
2. Access the endpoints using the documented routes (e.g., /request, /addcampaign, etc.).

## Detailed Flow
1. User signs up and provides blood type and location.
2. Users can request blood, donate, or organize/participate in a campaign.
3. The system checks inventory/campaigns in nearby locations using geospatial queries and sorts by distance.
4. Blood banks and campaigns update their status in real-time when new requests or donations are added.
5. The home screen loads key sections (carousel, donation requests).  
6. Navigation is managed by a bottom tab in HomeProvider.  
7. Donate form validates time/date before submitting.  
8. Campaigns screen lists all campaigns, allows toggling participation.

## Folder Structure
- Backend
  - src
    - routes
    - models
    - config
  - package.json
- frontend/
  - my_app/
    - lib/
      - provider/
        - home_screen_provider.dart
        - notification_provider.dart
      - screens/
        - home_screen.dart
        - donorlist.dart
        - donate_form.dart
        - campaign_screen.dart

## Additional Information
• Keep your SDK updated to avoid unexpected compilation issues.  
• Refer to the code comments for provider usage and UI structure.  
• Use "flutter doctor" to verify your environment setup.