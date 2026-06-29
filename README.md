<div align="center">
  <img src="assets/images/readme_banner.png" alt="AR Chem Lab Banner" width="100%" />

  <br />

  [![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
  [![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![Unity](https://img.shields.io/badge/Unity-%23000000.svg?style=for-the-badge&logo=unity&logoColor=white)](https://unity.com/)
  [![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-blue?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

  <h1>🧪 AR Chem Lab</h1>

  <p>
    <strong>A high-fidelity Augmented Reality Chemistry Laboratory.</strong><br />
    Bridging the gap between theoretical science and immersive discovery.
  </p>
</div>

---

## 🌟 Overview

**AR Chem Lab** is a professional-grade educational ecosystem designed to make chemistry interactive and safe. By embedding a native **Unity AR Engine** within a **Flutter** host application, the project delivers a seamless transition between traditional UI and immersive 3D laboratory environments.

Built with **Clean Architecture**, the app is engineered for stability, using advanced native techniques like **Process Isolation** to handle complex AR memory requirements.

---

## ✨ Core Features

### 🥽 Augmented Reality Laboratory
- **Native Process Isolation:** Unity runs in a dedicated `:unityplayer` process, preventing engine crashes from affecting the host app.
- **Dynamic Scene Loading:** Seamlessly transition to specific AR experiments via a custom Native Intent bridge.
- **Accurate Physics:** Scientifically accurate chemical reactions and visual particle effects.

### 🧬 Professional 3D Molecular Viewer
- **High-Fidelity Assets:** Explore 100+ molecules with atomic precision using modern glTF rendering.
- **Interactive Inspection:** Rotate, zoom, and analyze bonding structures in real-time.

### 🤖 AI Science Assistant (ScienceBot)
- **Generative AI Tutor:** A scientifically-tuned AI assistant capable of explaining complex formulas and reaction mechanisms.
- **Polished UX:** Real-time typewriter feedback and markdown formula support ($H_2O$, $CH_4$, etc.).

### 📊 Periodic Table & Data Exploration
- **Interactive Grid:** Comprehensive data on all 118 elements.
- **Sub-atomic Details:** View electron configurations, electronegativity, and atomic weights with one tap.

---

## 🏗️ Technical Architecture

The project follows the **Clean Architecture** pattern, ensuring a strict separation of concerns:

- **Presentation Layer:** Event-driven UI using **BLoC / Cubit**.
- **Domain Layer:** Pure Dart business logic containing Entities and Use Cases.
- **Data Layer:** Repository implementations using **Dio** (Networking) and **Shared Preferences** (Persistence).
- **Native Layer:** Custom **Kotlin** bridge for Unity lifecycle management and cross-process communication.

> [!IMPORTANT]
> For a deep dive into the architectural implementation and Unity integration logic, see the [PROJECT_DOCUMENTATION.md](PROJECT_DOCUMENTATION.md).

---

## 🚀 Installation & Setup

### Prerequisites
- **Flutter SDK:** `^3.10.7`
- **NDK:** `23.1.7779620` (Required for Unity 2022.3 stabilization)
- **Unity Hub:** Version `2022.3.62f3` (for modifying AR scenes)

### Quick Start
1. **Clone & Install**
   ```bash
   git clone https://github.com/Mustafa-Mohamed26/ar_chem_lab.git
   cd ar_chem_lab
   flutter pub get
   ```

2. **Generate Code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Configure Unity**
   Ensure the `unityLibrary` is correctly referenced in your `settings.gradle.kts`. Refer to the [Unity Integration Guide](UNITY_INTEGRATION_GUIDE.md) for detailed native setup.

4. **Run**
   ```bash
   flutter run
   ```

---

## 🛠️ Integrated Fixes & Stability
The project includes several custom native fixes not found in standard integrations:
- **The "Return" Fix:** Solves the app-closing bug by isolating the Unity lifecycle.
- **NDK Pinning:** Prevents `[CXX1100]` errors by forcing toolchain compatibility.
- **Silent Crash Patch:** Fixes the native `game_view_content_description` resource error.

---

<p align="center">
  <i>Developed with ❤️ for Science and Education.</i><br />
  <i>Making Chemistry Interactive, Immersive, and Accessible.</i>
</p>
