# chatapp

A chatapp built with Flutter and Firebase. 

## Problem Identification
Have a hard time understanding what someone means through their text? SocraticChat uses the Socratic Method to examine sentiments in a more meaningful way by providing questions to think about for each message receive. Of course, it should also aim to expand your conversation potential by allowing you to think about different things to ask about. In other words, Generate questions, and generate new conversation perspectives to consider.

What differentiates this from the general GPT4 bot?
- The general GPT4 bot uses a chatbot interface, while I am integrating it into a chat application.
- The assistant should be able to provide questions and analyzes the receiver text.
- Limitations
    - In a private setting, this implementation violates privacy rules and concerns. This is because we are sending input to GPT-4, OpenAI can collect the input.
        - However, this also means that the input is annonymized because the input can be coming from different sources. In this case openAI won't know that the input is provided by the sender.
        - 
## Architecture
This chat application consists of several components, including:

1. <mark style="background: #ffd300;">Backend server:</mark> This handles storing and retrieving chat messages, as well as user authentication and authorization.

2. <mark style="background: #a1ff0a;">Client app:</mark> This is the mobile or web application used by users to interact with the chat service. It communicates with the backend server to send and receive messages.

3. <mark style="background: #0aff99;">Database:</mark>This is used to store the chat messages and related data. Common databases used for chat apps include MongoDB and Firebase.

4. <mark style="background: #0aefff;">Real-time messaging system:</mark> This is used to send and receive messages in real-time. Common real-time messaging systems include WebSockets and Firebase Realtime Database.

5. <mark style="background: #147df5;">User authentication and authorization system:</mark> This is used to verify the identity of users and ensure they have permission to access certain chat rooms or conversations.

6. <mark style="background: #D2B3FFA6;">UI/UX design:</mark> This includes the visual and interactive components of the app, such as the chat interface and settings menus.

Overall, the architecture should prioritize real-time communication, scalability, and security to provide a smooth and reliable chat experience for users.