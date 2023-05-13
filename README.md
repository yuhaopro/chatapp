# chatapp (In Progress)

A chatapp built with Flutter and Firebase 

## Problem Identification
Not everyone knows how to get the most out of their AI chatbot conversations. This chat application serves as an interface that not only holds the conventional chatting functions between users, it also allows users to customize AI agents based on their specifications, and what they want to ask about. This customization part aims to abstract away the prompt engineering process, and makes it easier for individuals to obtain the most out of their conversation.
## Architecture
A chat app architecture typically consists of several components, including:

1. <mark style="background: #ffd300;">Backend server:</mark> This handles storing and retrieving chat messages, as well as user authentication and authorization. 

2. <mark style="background: #a1ff0a;">Client app:</mark> This is the mobile or web application used by users to interact with the chat service. It communicates with the backend server to send and receive messages.

3. <mark style="background: #0aff99;">Database:</mark>This is used to store the chat messages and related data. Common databases used for chat apps include MongoDB and Firebase. I will be using Firebase Firestore for storing data.

4. <mark style="background: #0aefff;">Real-time messaging system:</mark> This is used to send and receive messages in real-time. Common real-time messaging systems include WebSockets and Firebase Realtime Database. I will use Firestore since it can handle more complex queries than Firebase Realtime Database.

5. <mark style="background: #147df5;">User authentication and authorization system:</mark> This is used to verify the identity of users and ensure they have permission to access certain chat rooms or conversations. I will be using Firebase Authentication (Email and Password).

6. <mark style="background: #D2B3FFA6;">UI/UX design:</mark> This includes the visual and interactive components of the app, such as the chat interface and settings menus. I am considering implementing Material Design from Mat
