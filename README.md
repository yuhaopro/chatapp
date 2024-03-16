# chatapp

A chatapp built with Flutter and Firebase 

## Architecture
The chat app architecture consists of the following components:

1. <mark style="background: #ffd300;">Backend server:</mark> This handles storing and retrieving chat messages, as well as user authentication and authorization. 

2. <mark style="background: #a1ff0a;">Client app:</mark> This is the mobile or web application used by users to interact with the chat service. It communicates with the backend server to send and receive messages.

3. <mark style="background: #0aff99;">Database:</mark>This is used to store the chat messages and related data. Common databases used for chat apps include MongoDB and Firebase. I will be using Firebase Firestore for storing data.

4. <mark style="background: #0aefff;">Real-time messaging system:</mark> This is used to send and receive messages in real-time. Common real-time messaging systems include WebSockets and Firebase Realtime Database. I will use Firestore since it can handle more complex queries than Firebase Realtime Database.

5. <mark style="background: #147df5;">User authentication and authorization system:</mark> This is used to verify the identity of users and ensure they have permission to access certain chat rooms or conversations. I will be using Firebase Authentication (Email and Password).

6. <mark style="background: #D2B3FFA6;">UI/UX design:</mark> This includes the visual and interactive components of the app, such as the chat interface and settings menus. I am considering implementing Material Design from Material 3.
