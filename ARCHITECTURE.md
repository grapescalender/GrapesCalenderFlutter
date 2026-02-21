# Drakshsetu - Architecture Overview

## 🏗️ Clean Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │  Pages   │  │ Providers│  │ Widgets  │  │  Theme   │             │
│  │ (UI)     │  │(Riverpod)│  │(Reusable)│  │  Mode    │             │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘             │
│       ↓               ↓               ↓              ↓               │
│  ┌─────────────────────────────────────────────────────────┐         │
│  │            Navigation (GoRouter)                        │         │
│  └─────────────────────────────────────────────────────────┘         │
└────────────────┬────────────────────────────────────────────────────┘
                 │
┌────────────────┴────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                                    │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐                            │
│  │  Use      │  │  Entity  │  │ Repository │                         │
│  │  Cases   │  │  Models  │  │Interfaces  │                         │
│  └──────────┘  └──────────┘  └──────────┘                            │
│                                                                      │
│  Business Logic & Rules Independent of Framework                   │
└────────────────┬────────────────────────────────────────────────────┘
                 │
┌────────────────┴────────────────────────────────────────────────────┐
│                     DATA LAYER                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐               │
│  │  Repositories│  │ Remote Source│  │  Local Source│               │
│  │  (Interface) │  │   (API Calls)│  │  (Database)  │               │
│  └──────────────┘  └──────────────┘  └──────────────┘               │
│                            ↓                   ↓                    │
│                  ┌─────────────────────────────────┐                │
│                  │   Freezed Models & Mappers      │                │
│                  └─────────────────────────────────┘                │
└────────────────┬────────────────────────────────────────────────────┘
                 │
┌────────────────┴────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                             │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │   Dio    │  │ Secure   │  │Shared    │  │ Local    │             │
│  │ (HTTP)   │  │ Storage  │  │Pref      │  │Storage   │             │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘             │
│                                                                      │
│  External Services & APIs                                          │
└──────────────────────────────────────────────────────────────────────┘
```

## 🔄 Data Flow Example

### Authentication Flow
```
User Input (Login Page)
    ↓
    ├─→ Validation (app_utils.dart)
    ↓
    ├─→ AuthProvider (Riverpod)
    ↓
    ├─→ AuthRepository.login()
    ↓
    ├─→ RemoteDataSource.loginAPI()
    ↓
    ├─→ Dio Client
    │   ├─→ Token Interceptor
    │   ├─→ Error Interceptor
    │   └─→ Logging Interceptor
    ↓
    ├─→ API Response
    ↓
    ├─→ Freezed Model Conversion
    ↓
    ├─→ Secure Storage (Save Token)
    ↓
    ├─→ Navigation (GoRouter) → Home Page
    ↓
Success/Error Feedback
```

## 🏃 Feature Structure

Each feature follows this structure:

```
feature/
├── data/
│   ├── datasources/
│   │   ├── remote_datasource.dart     # API calls
│   │   └── local_datasource.dart      # Local storage
│   ├── models/
│   │   ├── model_name.dart            # Freezed models
│   │   └── model_name.freezed.dart    # Generated
│   └── repositories/
│       └── repository_impl.dart       # Repository implementation
├── domain/
│   ├── entities/
│   │   └── entity.dart                # Domain entity
│   └── repositories/
│       └── repository.dart            # Interface definition
└── presentation/
    ├── pages/
    │   └── page_name.dart             # Full screen widget
    ├── providers/
    │   └── providers.dart             # Riverpod state
    └── widgets/
        └── component.dart             # Reusable widgets
```

## 🧠 State Management Pattern (Riverpod)

```
┌─────────────────────────────────────────┐
│         Provider (Read-only)            │
│    Computes values from other providers │
└─────────────────────────────────────────┘
          ↓
┌─────────────────────────────────────────┐
│  StateNotifierProvider (Mutable)        │
│    Manages state changes via notifier   │
└─────────────────────────────────────────┘
          ↓
┌─────────────────────────────────────────┐
│  FutureProvider (Async)                 │
│    Handles async data fetching          │
└─────────────────────────────────────────┘

Example Provider Chain:
User Input → ref.read(themeProvider.notifier).toggleTheme()
             ↓
         StateNotifier updates state
             ↓
         UI rebuilds with new value
             ↓
         SharedPreferences.setString()
```

## 🌐 Network Layer Architecture

```
┌──────────────────────────────────────────────┐
│           Dio HTTP Client                    │
│        (with interceptors)                   │
└────────┬──────────────────────────────┬──────┘
         │                              │
    ┌────▼────────┐          ┌──────────▼────┐
    │   Request   │          │   Response    │
    │ Interceptor │          │ Interceptor   │
    └──────┬──────┘          └──────┬────────┘
           │                        │
    ┌──────▼──────┐          ┌──────▼────────┐
    │   Attach    │          │    Error      │
    │  JWT Token  │          │  Handling     │
    └─────────────┘          └───────────────┘
           │                        │
    ┌──────▼──────────────────────▼────────┐
    │      Logging Interceptor             │
    │   (Request & Response logging)       │
    └──────────────────────────────────────┘
           ↓
    API Server Response
           ↓
    Error Handling & Parsing
           ↓
    Repository Layer
```

## 🎯 Feature Navigation Map

```
                        ┌─────────────
                        │
                    ┌─►[HOME]◄──┐
                    │   ├─ Profile
                    │   ├─ Theme Toggle
                    │   └─ Language Selector
                    │
        ┌──────────►[SCHEDULE]
        │           ├─ Calendar View
        │           └─ Add Schedule
        │
    [LOGIN]─────────►[ACTIVITY]
        │           ├─ Timeline
        │           └─ Reports
        │
        └──────────►[PROFILE]
                    ├─ Edit Profile
                    ├─ Change Password
                    ├─ Settings
                    └─ Logout
```

## 📦 Dependency Injection (via Riverpod)

```
main.dart
    ↓
ProviderScope (Root)
    ↓
├─→ dioClientProvider
│   └─→ DioClient instance
│       └─→ Interceptors
├─→ themeModeProvider
│   └─→ ThemeModeNotifier
├─→ languageProvider
│   └─→ LanguageNotifier
├─→ localizationServiceProvider
│   └─→ LocalizationService
├─→ authTokenProvider
│   └─→ Reads from Secure Storage
└─→ goRouterProvider
    └─→ GoRouter instance
```

## 🔐 Security Layers

```
┌─────────────────────────────────────────┐
│    Application Security                 │
│  ├─ Input Validation                    │
│  ├─ Output Encoding                     │
│  └─ Rate Limiting (API level)           │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│    Transport Security                   │
│  ├─ HTTPS/TLS                           │
│  ├─ Certificate Pinning                 │
│  └─ Token in Secure Headers             │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│    Token Management                     │
│  ├─ JWT Tokens                          │
│  ├─ Secure Storage                      │
│  ├─ Automatic Refresh                   │
│  └─ Session Management                  │
└─────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────┐
│    Data Security                        │
│  ├─ Encryption at Rest                  │
│  ├─ Encryption in Transit               │
│  └─ Secure Cache                        │
└─────────────────────────────────────────┘
```

## 📱 Responsive Design Breakpoints

```
Device Width
     ↓
┌──────────────────────────────────────┐
│  < 600 dp: MOBILE                    │
│  └─ Single column layout             │
│  └─ Full width components            │
│  └─ Touch-friendly sizes             │
│  └─ Optimized navigation             │
├──────────────────────────────────────┤
│  600-900 dp: TABLET                  │
│  └─ Two column layout                │
│  └─ Larger touch targets             │
│  └─ Wider margins                    │
│  └─ Adaptive components              │
├──────────────────────────────────────┤
│  >= 900 dp: DESKTOP                  │
│  └─ Multi column layout              │
│  └─ Keyboard support                 │
│  └─ Sidebar navigation               │
│  └─ Advanced UI patterns             │
└──────────────────────────────────────┘
```

## 🎨 Theme System Flow

```
AppTheme (Static)
    ├─→ lightTheme (ThemeData)
    │   ├─ colorScheme (light colors)
    │   ├─ appBarTheme
    │   ├─ cardTheme
    │   ├─ inputDecorationTheme
    │   └─ textTheme
    └─→ darkTheme (ThemeData)
        ├─ colorScheme (dark colors)
        ├─ appBarTheme
        ├─ cardTheme
        ├─ inputDecorationTheme
        └─ textTheme
            ↓
        ThemeModeProvider (Riverpod)
            ↓
        MaterialApp(themeMode: ...)
            ↓
        UI Rebuilds
```

## 🌍 Localization Flow

```
assets/i18n/
├─ en.json (100+ keys)
├─ mr.json (100+ keys)
└─ hi.json (100+ keys)
    ↓
LocalizationService
├─ Load all language files
├─ Set current language
├─ Provide translate() method
└─ Persist selection
    ↓
languageProvider (Riverpod)
    ↓
ref.watch(languageProvider)
    ↓
Text(localizationService.translate('key'))
    ↓
UI Updates
```

## 🔗 API Integration Points

```
┌─────────────────────────┐
│  Features               │
├─────────────────────────┤
│  Auth Service           │ ──→ /auth/login
│  Plot Service           │ ──→ /plots/*
│  Schedule Service       │ ──→ /schedules/*
│  Activity Service       │ ──→ /activities/*
│  Profile Service        │ ──→ /profile/*
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  Dio Client             │
├─────────────────────────┤
│  Base URL Config        │
│  Interceptors           │
│  Timeout Config         │
│  Error Handling         │
└─────────────────────────┘
        ↓
┌─────────────────────────┐
│  API Server             │
│  (REST endpoints)       │
└─────────────────────────┘
```

## 💾 Local Storage Architecture

```
┌────────────────────────────────────────┐
│  Secure Storage (Encrypted)            │
│  - JWT Tokens                          │
│  - Sensitive user data                 │
│  └─ Flutter Secure Storage             │
├────────────────────────────────────────┤
│  Shared Preferences                    │
│  - Theme preference (dark/light)       │
│  - Language preference (en/mr/hi)      │
│  - User ID                             │
│  - Non-sensitive settings              │
├────────────────────────────────────────┤
│  SQLite/Hive (Future)                  │
│  - Plot data cache                     │
│  - Schedule cache                      │
│  - Activity history                    │
│  - Offline data                        │
└────────────────────────────────────────┘
```

---

**Architecture Diagram Version**: 1.0
**Last Updated**: February 17, 2026
**Architecture Style**: Clean Architecture + Feature-First Modular
**Suitable for**: Scalable, maintainable Flutter applications
