# Duniya Deen

![iOS CI](https://github.com/daansari/duniyadeen/actions/workflows/ios-ci.yml/badge.svg)
![Code Coverage](https://raw.githubusercontent.com/daansari/duniyadeen/main/.github/badges/coverage.svg)
![iOS Version](https://img.shields.io/badge/iOS-17.6%2B-blue)
![Swift Version](https://img.shields.io/badge/Swift-5.0-orange)
![Xcode](https://img.shields.io/badge/Xcode-15%2B-blue)

A modern SwiftUI application for item tracking and management, built with Apple's latest SwiftData framework for seamless data persistence.

## Features

- **Modern SwiftUI Interface**: Clean, intuitive user experience with smooth animations
- **SwiftData Integration**: Apple's latest data persistence framework for efficient storage
- **Welcome Screen**: Onboarding flow for new users
- **Item Management**: Add, view, and delete timestamped items with master-detail navigation
- **Real-time Updates**: Live data synchronization across the app
- **Universal App**: Supports both iPhone and iPad
- **High Test Coverage**: 96% code coverage with comprehensive unit and UI tests
- **Automated CI/CD**: Full GitHub Actions pipeline with quality checks

## Architecture

- **MVVM Pattern**: Clean separation of concerns with SwiftUI's declarative approach
- **SwiftData Models**: Modern data modeling with `@Model` and persistent storage
- **Navigation**: Master-detail interface with SwiftUI NavigationStack
- **No External Dependencies**: Built entirely with Apple's native frameworks

## Requirements

- **iOS**: 17.6 or later
- **Xcode**: 15.0 or later
- **Swift**: 5.0
- **Device**: iPhone and iPad support

## Project Structure

```
duniyadeen/
├── duniyadeen/
│   ├── duniyadeenApp.swift      # Main app entry point
│   ├── ContentView.swift        # Primary interface
│   ├── WelcomeView.swift        # Onboarding screen
│   └── Item.swift               # SwiftData model
├── duniyadeenTests/
│   ├── ItemTest.swift           # Model unit tests
│   └── DuniyadeenAppTest.swift  # App-level tests
├── duniyadeenUITests/           # UI testing suite
└── .github/workflows/           # CI/CD pipeline
```

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/daansari/duniyadeen.git
   cd duniyadeen
   ```

2. **Open in Xcode**
   ```bash
   open duniyadeen.xcodeproj
   ```

3. **Build and run**
   - Select your target device or simulator
   - Press `⌘ + R` to build and run

## Testing

The project maintains high testing standards with comprehensive test coverage:

- **Unit Tests**: 96% code coverage testing core functionality
- **UI Tests**: Automated interface testing
- **Continuous Testing**: All tests run automatically on every push/PR

Run tests locally:
```bash
xcodebuild test -scheme duniyadeen -destination 'platform=iOS Simulator,OS=18.4,name=iPhone 16 Pro'
```

## CI/CD Pipeline

Our GitHub Actions workflow includes:

- **Unit Tests**: Comprehensive test execution with coverage reporting
- **UI Tests**: Automated interface validation
- **Code Quality**: SwiftFormat and SwiftLint checks
- **Build Verification**: Release build validation
- **Coverage Badges**: Automatic badge generation and updates

## Development

### Code Style
- **SwiftFormat**: Automatic code formatting
- **SwiftLint**: Code quality and style enforcement
- **Testing**: Minimum 85% code coverage requirement

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Ensure all CI checks pass
5. Submit a pull request

## Bundle Information

- **Bundle ID**: `com.deepturf.duniyadeen`
- **Version**: 1.0
- **Build**: 1
- **Team**: 4R4A5Y6466

## License

This project is available under the MIT license.
