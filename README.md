# Smart Safety Band

## Description

The Smart Safety Band mobile application is designed to act as the central communication hub between the safety band and the user’s emergency contacts. Built using Flutter, the app ensures cross-platform compatibility and a smooth user experience. When the user is in danger and taps on their band three times, the mobile application instantly sends a notification along with the user’s live location to their registered emergency contacts. This ensures quick response and immediate assistance in critical situations.

## Key Functionality 

Bluetooth Connectivity: The app establishes a secure Bluetooth connection with the ESP32 module embedded in the safety band, ensuring real-time communication.

Emergency Alert Reception: Whenever the band detects a pre-defined trigger (e.g., three consecutive taps on the piezoelectric sensor), it immediately sends an alert to the app.

Automated SMS Alerts: On receiving the alert, the app automatically sends SMS notifications to three pre-configured emergency contacts. The message contains both the distress signal and the user’s real-time GPS location, allowing quick response.

Background Operation: The app works silently in the background, so the user does not need to open it during emergencies. The system is designed to minimize delay and respond within 2–3 seconds.

User Privacy: The app ensures that emergency notifications are sent only when an actual trigger is detected, thereby reducing the chances of false alarms.

##Screenshot
<img src="https://github.com/user-attachments/assets/cffa00b0-5a42-498e-b633-dac71f16e6b6" alt="img1" height="400"  /> 
<img src="https://github.com/user-attachments/assets/7da17608-6181-41a1-95df-2af8c3465ef6" alt="img2" height="400"  /> 
<img src="https://github.com/user-attachments/assets/28ca6768-efe8-4f7e-bee8-2739a55f6db5" alt="img3" height="400"  /> 
<img src="https://github.com/user-attachments/assets/7705385f-e21b-4143-af98-469b39c23cef" alt="img4" height="400"  /> 

