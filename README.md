**Smart Home Management System with 3D Visualization**

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


<img width="1901" height="116" alt="image" src="https://github.com/user-attachments/assets/b49e3d2b-ecba-42d7-aa4d-1d189ce71d31" />


  2. Energy Analytics

<img width="1307" height="676" alt="image" src="https://github.com/user-attachments/assets/11053a94-ab4f-4233-8558-7bbd4c42c926" />

<img width="1291" height="637" alt="image" src="https://github.com/user-attachments/assets/411a0838-75a3-46d5-b9bb-f954d86ae4d3" />

<img width="1271" height="603" alt="image" src="https://github.com/user-attachments/assets/d53bf508-b4e8-469a-a1c3-7a4c1892528c" />


  3. Network & Security Status


<img width="1633" height="875" alt="image" src="https://github.com/user-attachments/assets/ab4c0e03-6ae6-4476-aa17-d8c1966f27df" />

<img width="1600" height="860" alt="image" src="https://github.com/user-attachments/assets/1e0b0c70-cd32-4210-b465-00a1dd02a5cd" />


  4.Device status: on and off 


<img width="1882" height="121" alt="image" src="https://github.com/user-attachments/assets/619b39ef-243f-47d4-abba-6fb241b58196" />

<img width="1873" height="121" alt="image" src="https://github.com/user-attachments/assets/128d38d6-680c-484d-9146-4994a7f45fd0" />


  5. Dynamic changes in electricity consumption depending on the load on the power grid

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

  
