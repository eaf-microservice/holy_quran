# القرآن الكريم - Holy Quran App

A beautiful, feature-rich offline Quran reading application built with Flutter. Read the Holy Quran anytime, anywhere without an internet connection.

## 📱 Features

### Core Features
- **Complete Quran**: Full 604-page Madani Mushaf (المصحف المدني)
- **Offline Access**: All content works completely offline - no internet required
- **Dual Reading Modes**:
  - **Normal Mode**: Standard high-quality
  - **Tajweed Mode**: Color-coded tajweed pages for proper pronunciation

### Reading Experience
- **3D Page Flip Animation**: Smooth, realistic page-turning effect with LTR/RTL support
- **Interactive Zoom**: Pinch to zoom up to 3x for detailed reading
- **Smart Navigation**: 
  - Swipe to turn pages
  - Quick jump to any page (1-604)
  - Page slider for fast navigation
  - Previous/Next page buttons

### Search & Organization
- **Advanced Search**: Find surahs by:
  - Arabic name
  - English name
  - Surah number
- **Complete Index**: Browse all 114 surahs with page ranges
- **Quick Access**: Continue reading from last page

### Bookmarks & Personalization
- **Bookmarks**: Save your favorite pages for quick access
- **Last Read Page**: Automatically resume where you left off
- **Bookmark Management**: View, navigate, and delete bookmarks

### Themes & Settings
- **Night Mode**: Dark theme for comfortable reading in low light
- **Light Mode**: Clean, bright interface for daytime reading
- **Settings Screen**: Easy access to all preferences
- **Persistent Settings**: Your preferences are saved automatically

### User Interface
- **RTL/LTR Support**: Full right-to-left and left-to-right text support
- **Arabic Interface**: Native Arabic UI elements
- **Material Design 3**: Modern, beautiful interface
- **Screen Wake Lock**: Screen stays on while reading

## 🛠️ Technical Details

### Built With
- **Flutter SDK**: ^3.10.1
- **Dart**: Latest stable version
- **Material Design 3**: Modern UI components

### Dependencies
- `shared_preferences`: Local data persistence
- `wakelock_plus`: Keep screen awake during reading
- `page_flip`: Page flip animations (optional)
- `cupertino_icons`: iOS-style icons

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── home_screen.dart      # Main screen with surah list
│   └── settings_screen.dart  # Settings and preferences
├── utils/
│   └── quran_surahs.dart    # Surah metadata (114 surahs)
└── widgets/
    └── about.dart           # About dialog
```

### Assets
- **Quran Pages**: 604 PNG images in `assets/images/quran/`
- **Tajweed Pages**: 604 GIF images in `assets/images/tajweed/`
- **Icons**: App icons and UI assets in `assets/icon/`

## 📦 Installation

### Prerequisites
- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/eaf-microservice/holy_quran.git
   cd holy_quran
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release

flutter build ipa
```

## 🎯 Usage

### Reading the Quran
1. Open the app to see the surah index
2. Tap any surah to jump to its starting page
3. Swipe left/right or use navigation buttons to turn pages
4. Tap the screen to show/hide UI controls
5. Use pinch gesture to zoom in/out

### Searching
- Use the search bar at the top
- Type in Arabic, English, or surah number
- Results filter in real-time

### Bookmarks
- While reading, tap the bookmark button (bottom right)
- Access bookmarks from the app bar menu
- Delete bookmarks from the bookmark list or settings

### Settings
- Tap the settings icon in the app bar
- Switch between Normal and Tajweed modes
- Toggle between Light and Night themes
- Manage bookmarks and last read page

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

## 🙏 Acknowledgments

- The Holy Quran text and pages
- Flutter community for excellent tools and resources
- All contributors and users of this app

## 📝 Version

**Current Version**: 1.0.1

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## ⚠️ Note

This app is for educational and personal use. The Quranic text and images are provided for reading purposes only.

---

**May this app help you in your journey of reading and understanding the Holy Quran. بارك الله فيك**

**لا تنسونا من صالح الدعاء**

## Contact

- Developer : Fouad El Azb
- Company : EAF microservice
- Phone Company : +212 645 994 904
- Email : EAF.microservice@gmail.com
- Web site : https://eaf-microservice.netlify.app/