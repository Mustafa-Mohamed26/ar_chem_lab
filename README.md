<div align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Unity-%23000000.svg?style=for-the-badge&logo=unity&logoColor=white" alt="Unity" />
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android" />
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white" alt="iOS" />
</div>

<h1 align="center">🧪 AR Chem Lab</h1>

<p align="center">
  <strong>An immersive, beautifully designed Augmented Reality Chemistry Laboratory built with Flutter and Unity.</strong>
</p>

---

## 📖 About The Project

**AR Chem Lab** reimagines how students and enthusiasts learn chemistry by bringing a fully interactive simulation lab right to their mobile devices.

By combining the cross-platform power of **Flutter** with the profound 3D rendering and augmented reality capabilities of **Unity**, this app provides a safe, highly-engaging environment to conduct chemical experiments, inspect molecular structures, and learn scientific concepts without the need for physical lab equipment.

## ✨ Key Features

- 🥽 **Augmented Reality Lab:** Perform interactive chemistry experiments safely using your device's camera. Unity integration smoothly overlays chemical reactions into your real-world environment.
- 🧬 **Interactive 3D Viewer:** Inspect and manipulate intricate 3D molecular structures in high detail using `model_viewer_plus`.
- 🤖 **AI Chemistry Assistant:** Get immediate help and guided walkthroughs. The built-in AI chatbot fully supports markdown rendering for structured, easy-to-read scientific explanations.
- 🎓 **Adaptive Difficulty:** Progress at your own pace through tailored scenes—from _Beginner_ to _Intermediate_ and _Expert_ levels.
- 🔐 **Secure Authentication:** Robust user management featuring login, registration, and secure password reset workflows.
- 💎 **Premium UI Design:** A modern, sleek, and responsive interface designed with Google Fonts, custom themes, and refined animations to provide a top-tier user experience.

---

## 🛠️ Technology Stack

The application leverages a modern technology stack to ensure performance, scalability, and an excellent developer experience:

- **Frontend Framework:** [Flutter](https://flutter.dev/)
- **AR Engine:** [Unity](https://unity.com/) via Flutter-Unity Bridge
- **State Management:** [BLoC / Cubit](https://bloclibrary.dev/)
- **Dependency Injection:** `get_it` and `injectable`
- **Networking API:** `dio`
- **UI/UX Tools:** `flutter_screenutil`, `google_fonts`, `flutter_markdown`

---

## 🏗️ Architecture & Design Patterns

This project follows **Clean Architecture** principles and **Layered/Feature-First** design to ensure separation of concerns, scalability, and testability.

- **Clean Architecture:** Divided into distinct layers (`presentation`, `domain`, `data`, `core`) allowing UI and business logic to evolve independently.
- **Repository Pattern:** Abstracted data sources ensure the rest of the application is agnostic to where the data comes from (e.g., local storage or remote API).
- **Dependency Injection:** Utilizing `get_it` combined with `injectable` for robust, code-generated service locators and factories.
- **State Management:** Powered by **BLoC (Business Logic Component)** and **Cubit**, separating the application state from the UI presentation layer, providing predictable and reactive state transitions across features.

---

## 📂 Folder Structure

The core `lib/` directory is cleanly organized around these architectural layers:

```text
lib/
├── api/             # Network configurations, Dio client setup, Interceptors
├── config/          # App-wide routing, Theme configs, Dependency Injection scripts
├── core/            # Shared utilities, constants, exceptions, global helpers
├── data/            # Data layer: Repositories implementations, Data Sources, DTOs
├── domain/          # Domain layer: Core Entities, Use Cases, Repository Interfaces
├── presentation/    # UI layer: Screens, Reusable Widgets, BLoCs, Cubits, ViewModels
└── main.dart        # Application entry point & MultiBlocProvider initialization
```

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install) (Version `^3.10.7` recommended)
- **Unity Hub / Editor**: Required for modifying or building the AR scenes (Make sure Android build support and NDK are installed)
- **Android Studio / Xcode**: For device emulation and compilation.

### Installation

1.  **Clone the repository**

    ```sh
    git clone https://github.com/Mustafa-Mohamed26/ar_chem_lab.git
    cd ar_chem_lab
    ```

2.  **Install Flutter Dependencies**

    ```sh
    flutter pub get
    ```

3.  **Generate DI and Routes (if applicable)**

    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the app**
    ```sh
    flutter run
    ```
    _Note: AR features require testing on a physical device, as emulators do not fully support ARCore/ARKit._

---

## 📸 Screenshots _(Placeholders)_

_(Add actual screenshots of the app here once available)_

<div align="center">
  <table>
    <tr>
      <td><p align="center"><b>Home Dashboard</b></p></td>
      <td><p align="center"><b>AR Experiment</b></p></td>
      <td><p align="center"><b>AI Assistant</b></p></td>
    </tr>
    <tr>
      <td><img src="https://via.placeholder.com/250x500?text=Home+Screen" width="200" alt="Home"></td>
      <td><img src="https://via.placeholder.com/250x500?text=AR+Lab" width="200" alt="AR Lab"></td>
      <td><img src="https://via.placeholder.com/250x500?text=AI+Chat" width="200" alt="AI Chat"></td>
    </tr>
  </table>
</div>

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">
  <i>Built with ❤️ to make learning chemistry fun and accessible.</i>
</p>
