# AroundEgypt iOS

An iOS application for exploring Egyptian tourism experiences, featuring virtual tours, experience discovery, and personalized recommendations.

## Overview

AroundEgypt is a modular iOS application built with SwiftUI that allows users to discover and explore tourist experiences across Egypt. The app features a clean architecture with separated concerns across multiple modules.

## Architecture

The project follows a modular architecture pattern with clear separation of concerns:

### Modules

- **AECore**: Core infrastructure layer
  - Network layer with Moya integration
  - SwiftData persistence
  - Logging system
  - Dependency injection

- **AEShared**: Shared resources and components
  - Design system (colors, typography, spacing, radius)
  - Reusable UI components
  - Common utilities and extensions
  - Coordinator pattern implementation

- **AETour**: Tour and experience features
  - Domain layer (entities, use cases, repositories)
  - Data layer (DTOs, mappers, data sources)
  - Presentation layer (views, view models)
  - Features: home, experience details, search, virtual tours

### Project Structure

```
AroundEgypt_iOS/
├── AEHub.xcworkspace          # Main Xcode workspace
├── AroundEgyptApp/             # Main application target
│   ├── AroundEgyptApp/         # App source code
│   ├── AroundEgyptAppTests/    # App unit tests
│   └── AroundEgyptAppUITests/  # App UI tests
└── Modules/
    ├── AECore/                 # Core infrastructure module
    ├── AEShared/               # Shared resources module
    └── AETour/                 # Tour feature module
```

## Requirements

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## Getting Started

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd AroundEgypt_iOS
   ```

2. Open the workspace:
   ```bash
   open AEHub.xcworkspace
   ```

3. Build and run the project in Xcode

### Running Tests

The project currently includes:

- Unit tests for use cases (implemented)
- Repository tests (planned)
- Data source tests (implemented)

Run tests using:
- Xcode: `Cmd + U`

## Features

- Browse recent and recommended experiences
- Search for specific experiences
- View detailed experience information
- Virtual tour integration
- Like/favorite experiences
- Offline data persistence with SwiftData

## Technologies

- **UI Framework**: SwiftUI
- **Persistence**: SwiftData
- **Networking**: Moya
- **Dependency Injection**: Factory pattern with Container
- **Architecture**: Clean Architecture with MVVM-C (Coordinator)
- **Testing**: XCTest with mock implementations

## Development

### Design System

The app uses a centralized design system located in the `AEShared` module:
- `AppColors`: Color tokens
- `AppTypography`: Typography styles
- `AppSpacing`: Spacing values
- `AppRadius`: Border radius values

### Dependency Injection

The project uses a factory-based dependency injection system. Each module registers its dependencies in a `Container+[ModuleName].swift` file.

### Code Organization

Each feature module follows Clean Architecture principles:
- **Domain**: Business logic, entities, use cases
- **Data**: Data sources, repositories, DTOs, mappers
- **Presentation**: Views, view models, coordinators

