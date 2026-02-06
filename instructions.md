# 🏃 Fitness Running App – Architecture & Design Specification (MVP)

> **Purpose**: This document defines the **complete system architecture**, **backend choices**, **communication methods**, and **database schema** for the Flutter-based fitness running app MVP.

---

## 1️⃣ System Overview

The application is a **mobile-first fitness running app** with real-time tracking, social competition, gamification, and notifications.

### Core Principles

* MVP-first, scalable later
* Event-driven design
* Clear separation of concerns
* Minimal operational overhead

---

## 2️⃣ High-Level Architecture

```
Flutter Mobile App
│
├── Presentation Layer (UI)
├── State Management (BLoC / Cubit)
├── Domain Logic (Use Cases)
└── Data Layer (Repositories & SDKs)
        │
        ▼
Backend (Serverless)
│
├── Firebase Authentication
├── Cloud Functions (Business Logic)
├── Firestore (NoSQL Database)
└── Firebase Cloud Messaging (Push)
```

---

## 3️⃣ Frontend Architecture (Flutter)

### Architectural Pattern

* **Clean Architecture**
* **BLoC / Cubit** for state management

### Layer Responsibilities

#### Presentation Layer

* Flutter Widgets
* Screen navigation
* UI rendering only

#### State Management (BLoC / Cubit)

* Manage UI state
* Subscribe to streams (GPS, Firestore, FCM)
* Orchestrate app behavior

Example Cubits:

* `AuthCubit`
* `RunCubit`
* `LeaderboardCubit`
* `NotificationCubit`

#### Domain Layer

* Business use cases
* Pure Dart logic
* No framework dependencies

#### Data Layer

* Firebase SDKs
* Geolocator
* REST calls

---

## 4️⃣ Backend Architecture

### Backend Type

**Serverless, Event-Driven Backend**

### Components

#### Firebase Authentication

* Google Sign-In
* Token-based authentication

#### Cloud Functions

Responsible for:

* Run validation
* Points (PTS) calculation
* Leaderboard updates
* Event emission
* Notification triggers

#### Event-Driven Flow

```
Run Completed
→ Cloud Function Triggered
→ Calculate PTS
→ Update Firestore
→ Emit Event
→ Send Notifications
```

---

## 5️⃣ Communication Methods

### 1️⃣ HTTPS (REST)

Used for **command-based operations**:

* Submit run summary
* Fetch user profile
* Fetch run history

**Why REST?**

* Simple
* Secure
* Reliable

---

### 2️⃣ Realtime Streams (Firestore Listeners)

Used for **live updates**:

* Leaderboard changes
* Friend activity
* Rank updates

**Why Firestore Streams?**

* Real-time by default
* No polling
* Auto-scaled

---

### 3️⃣ Push Notifications (FCM)

Used for **out-of-band communication**:

* Friend earned points
* Rank changes

**Why FCM?**

* Battery efficient
* Works when app is closed
* Globally scalable

---

## 6️⃣ GPS Data Strategy

### ❌ What NOT to do

* Do not stream GPS points continuously to backend

### ✅ Correct Strategy

* GPS tracked locally on device
* Distance, pace calculated locally
* Only **run summary** sent to backend

**Benefits**:

* Reduced cost
* Better battery life
* Higher reliability

---

## 7️⃣ Database Selection

### Chosen Database

**Firestore (NoSQL)**

### Why Firestore

* Realtime updates
* Scales automatically
* Perfect for social & leaderboard data
* Minimal operational overhead

---

## 8️⃣ Firestore Database Schema

### users (collection)

```json
{
  "uid": "string",
  "name": "string",
  "email": "string",
  "photoUrl": "string",
  "totalPoints": number,
  "createdAt": timestamp
}
```

---

### friends (collection)

```json
{
  "userId": "string",
  "friendId": "string",
  "status": "accepted | pending",
  "createdAt": timestamp
}
```

---

### runs (collection)

```json
{
  "runId": "string",
  "userId": "string",
  "distance": number,
  "duration": number,
  "pace": number,
  "pointsEarned": number,
  "routePolyline": "string",
  "createdAt": timestamp
}
```

---

### leaderboards (collection)

```json
{
  "userId": "string",
  "points": number,
  "rank": number,
  "updatedAt": timestamp
}
```

---

### notifications (collection)

```json
{
  "toUserId": "string",
  "type": "points | rank",
  "message": "string",
  "read": false,
  "createdAt": timestamp
}
```

---

## 9️⃣ Security Model

### Client (Untrusted)

* UI only
* No business logic

### Backend (Trusted)

* PTS calculation
* Leaderboard logic
* Validation

### Firestore Security Rules

* User-based access
* Backend-only writes for sensitive fields

---

## 🔟 Scalability & Future Evolution

### MVP Phase

* Firebase + Firestore

### Scale Phase

* Replace Cloud Functions with NestJS
* Introduce PostgreSQL for analytics
* Event bus (Pub/Sub or Kafka)

---

## 1️⃣1️⃣ Final Architecture Summary

* **Frontend**: Flutter + Clean Architecture + Cubit
* **Backend**: Serverless (Cloud Functions)
* **Database**: Firestore
* **Realtime**: Firestore listeners
* **Notifications**: Firebase Cloud Messaging
* **Communication**: REST + Realtime + Push

---

## ✅ Architect Verdict

This architecture is:

* MVP-fast
* Cost-efficient
* Secure
* Evolvable

It is **professionally sound** and **production-ready** for early-stage growth.
