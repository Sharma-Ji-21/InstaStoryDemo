# 📸 Instagram Stories Demo

A Flutter application mimicking Instagram's story viewer with smooth animations, gesture-based navigation, and modular design. Built to demonstrate Flutter performance, scalability, and intuitive UI/UX principles.

## 🚀 Features

### Core
* View multiple users' stories with swipe & tap gestures
* Tap right/left to navigate, hold to pause
* Auto-progress every 5 seconds
* Horizontal swiping between users

### UI/UX
* Instagram-like interface and layout
* Gradient-bordered profile avatars
* Visual story progress bars
* Loading placeholders with animations

## 🏗️ Architecture & Design Choices

### Clean & Scalable Structure
* **Modular folder structure** (models/, screens/, services/)
* **Single-responsibility components**: Each file handles a distinct concern
* Separation of **UI logic, data models, and services** for easy scaling

### Performance Optimization
* Efficient PageView and AnimationController usage
* Controlled rebuilds with setState only where needed
* Lightweight widget trees with proper disposal of controllers

### Gesture Handling
* Custom tap zones (left/right/hold) for story navigation
* Smooth transitions with animation curves for immersive UX

## 🧪 Testing

### Included Test Coverage
* ✅ **Models**: JSON parsing, data structure validation
* ✅ **Services**: Mock story generation and data flow
* ✅ **Widgets**: UI rendering, navigation, pause/resume behavior

### Run Tests
```bash
flutter test
```

### Run with Coverage
```bash
flutter test --coverage
```

## 📱 Screenshots & Demo
<table>
  <tr>
    <th>Home Screen</th>
    <th>Story View</th>
    <th>Loading State</th>
  </tr>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/5f388792-e881-4528-9806-5432e7880181" width="300"/></td>
    <td><img src="https://github.com/user-attachments/assets/bec6adac-7700-420e-a80e-398bbfc3f79b" width="300"/></td>
    <td><img src="https://github.com/user-attachments/assets/5d3b021a-c183-424f-810a-5b27f20b5c6b" width="300"/></td>
  </tr>
  <tr>
    <td colspan="3" align="center">
      <video src="https://github.com/user-attachments/assets/58cbff85-0a31-4d6a-b1d2-75ef40329272" width="600" controls></video>
    </td>
  </tr>
</table>



## ⚙️ Setup Instructions

### Prerequisites
* Flutter SDK >=3.0.0
* Dart SDK >=2.17.0
* Android Studio / VS Code
* Android/iOS Emulator

### Steps

1. **Clone Repo**
   ```bash
   git clone <repo-url>
   cd insta_story_demo
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Add Assets**
   ```
   assets/profileImageUrl/
   ├── 0.jpg
   ├── 1.jpg
   └── ... up to 9.jpg
   ```

4. **Configure pubspec.yaml**
   ```yaml
   flutter:
     assets:
       - assets/profileImageUrl/
   ```

5. **Run App**
   ```bash
   flutter run
   ```

## 📦 Assumptions Made

* No backend or API integration; mock data used via StoryService
* Stories consist only of images (not videos or boomerangs)
* Users are limited to 10 mock profiles with 3–5 stories each
* Profile pictures are loaded from local assets, not network

## 🔧 Customization

| Change | How to Do It |
|--------|--------------|
| Story duration | Adjust AnimationController(duration) |
| Number of stories | Edit StoryService.fetchStory() |
| Theme or colors | Modify widget styles and gradients |

## 📌 Limitations

* No video support
* No story creation/upload feature
* No persistent data or backend
* Limited mock user profiles

## 🌱 Roadmap

* Add video story support
* Enable reactions/replies
* Backend integration
* User story creation
* Story highlights + Dark mode

---

**Built with ❤️ using Flutter**
