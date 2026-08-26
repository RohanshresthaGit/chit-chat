# 💬 Chat Application

A modern, real-time messaging application built with **Flutter** and a scalable backend architecture. The application supports one-to-one messaging, real-time communication, message status, media sharing, scheduled messages, notifications, and other features expected from a modern chat platform.

The project is designed with **scalability, maintainability, security, and clean architecture** in mind.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Goals](#-goals)
- [Features](#-features)
- [Application Flow](#-application-flow)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Authentication](#-authentication)
- [Messaging](#-messaging)
- [Scheduled Messages](#-scheduled-messages)
- [Real-Time Communication](#-real-time-communication)
- [Message Status](#-message-status)
- [Presence & Typing](#-presence--typing)
- [Media Messages](#-media-messages)
- [Notifications](#-notifications)
- [Database](#-database)
- [API Overview](#-api-overview)
- [WebSocket Events](#-websocket-events)
- [Security](#-security)
- [Error Handling](#-error-handling)
- [Offline Support](#-offline-support)
- [Testing](#-testing)
- [Development Setup](#-development-setup)
- [Environment Variables](#-environment-variables)
- [Documentation](#-documentation)
- [Future Features](#-future-features)
- [Development Roadmap](#-development-roadmap)
- [Contributing](#-contributing)
- [License](#-license)

---

# 📖 Overview

The Chat Application is a real-time communication platform that allows users to communicate through text and media messages.

The application provides both traditional REST APIs and WebSocket-based real-time communication.

The main objective is to create a production-oriented chat system that can support:

- Real-time messaging
- Reliable message delivery
- Scheduled messages
- Media sharing
- Push notifications
- Multiple conversations
- Offline users
- Scalable backend services

The system is designed so that additional functionality such as group chats, voice messages, message reactions, and calls can be introduced without requiring a major architectural rewrite.

---

# 🎯 Goals

The main goals of this project are:

- Build a modern real-time chat application.
- Learn and implement WebSocket communication.
- Design a scalable messaging architecture.
- Implement secure authentication.
- Support scheduled messages reliably.
- Handle online and offline users.
- Maintain message delivery and read states.
- Build reusable Flutter components.
- Follow clean architecture and maintainable coding practices.
- Create comprehensive technical documentation.

---

# 🚀 Features

## 🔐 Authentication

- User registration
- User login
- Logout
- JWT authentication
- Access tokens
- Refresh tokens
- Password hashing
- Token expiration
- Session management

---

## 👤 User Management

Users can:

- Create a profile
- Update profile information
- Upload profile picture
- Search for users
- View another user's profile
- View online status
- View last seen

---

## 💬 One-to-One Messaging

Users can:

- Start a conversation
- Send text messages
- Receive messages in real time
- Edit messages
- Delete messages
- Reply to messages
- Copy messages
- Forward messages
- Search messages

---

## 📎 Media Messages

The application can support:

- Images
- Documents
- Files
- Videos
- Audio messages

Media files are uploaded separately from the messaging API and referenced by the message.

---

## 📅 Scheduled Messages

Users can schedule a message to be delivered at a future date and time.

### Supported Operations

- Create scheduled message
- View scheduled messages
- Edit scheduled message
- Reschedule message
- Cancel scheduled message
- Delete scheduled message
- Automatically send scheduled message

### Example

```text
User writes message
       │
       ▼
Select "Schedule"
       │
       ▼
Select date and time
       │
       ▼
Backend stores scheduled message
       │
       ▼
Background worker waits
       │
       ▼
Scheduled time reached
       │
       ▼
Message becomes normal message
       │
       ├── WebSocket event
       └── Push notification