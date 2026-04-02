<img width="1919" height="1031" alt="image" src="https://github.com/user-attachments/assets/7533929d-ee43-4d53-a632-3a3745288c87" />**Smart Home Management System with 3D Visualization**

A cross-platform software complex designed for monitoring and controlling "Smart Home" ecosystems. This project integrates a hierarchical IoT device model, an interactive 3D environment, and real-time energy consumption analysis.

**🌟 Key Features**

  Interactive 3D Visualization: High-fidelity 3D house model rendering using Qt Quick 3D (GLB format).

  Dynamic HUD Interface: Interactive "Security Bubbles" (HUD) that automatically recalculate their screen positions (x, y) based on 3D world coordinates (x, y, z) during camera rotation.

  Energy Consumption Monitoring: Real-time calculation of total network load in kW based on individual power profiles for each device.

  Automated Scenarios: Pre-configured "Morning" and "Evening" modes that trigger group device actions (lighting, climate, appliances).

  Network Resilience Logic: A hierarchical system where the stability of the Ajax Hub and peripheral sensors depends on the Wi-Fi router status.

  REST API Integration: Fetching live meteorological data from the Open-Meteo service to adapt home scenarios to external weather conditions.

  Local Event Logging: Transactional event history and audit logs stored in a local SQLite database.

  **📸 Screenshots & Demo**
<img width="1919" height="1031" alt="image" src="https://github.com/user-attachments/assets/1e1011e8-f607-4079-8d9f-d239de777852" />

  1. Main 3D Interface

  2. Energy Analytics

  3. Network & Security Status


**🏗️ Architecture**

The project follows a modular MVC (Model-View-Controller) pattern to ensure a clean separation of concerns:

  Controller (C++): The System class handles the lifecycle of objects, validates device states, and performs energy calculations.

  View (QML & Qt Quick 3D): A reactive UI that renders the 3D scene and handles user interactions.

  Model (SQLite & JavaScript): Manages data persistence for event history and device configurations.

**🛠️ Tech Stack**

  Framework: Qt 6.8

  Languages: C++, QML, JavaScript

  3D Engine: Qt Quick 3D

  Database: SQLite

  API: Open-Meteo (REST API via XMLHttpRequest)

**🚀 Performance Metrics**

Tests conducted on the graphical pipeline demonstrate high efficiency:

  CPU Load: ~4% (Efficient data processing).

  GPU Load: ~24% (Optimized 3D rendering).

  Frame Rate: Stable 144 FPS for fluid animations.

**📂 Project Structure**

  main.cpp — Engine initialization and context property registration.

  system.cpp/h — Core logic and energy calculation algorithms.

  Main.qml — Primary UI layout and 3D scene environment.

  Database.js — Transactional logic for SQLite operations.

  assets/ — 3D models (.glb) and UI icons.

  
