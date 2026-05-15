# Flutter App Structure Guide

## Project Architecture

This project follows:

```txt
Feature First + Clean Architecture + Riverpod
```

Architecture goals:

- Scalable
- Maintainable
- Reusable
- Testable
- Production-ready

---

# Root Structure

```txt
lib/
├── main.dart
└── src/
    ├── app.dart
    │
    ├── core/
    ├── shared/
    └── features/
```

---

# Core Folder

`core/` contains application-level infrastructure.

These are app-wide concerns shared across the entire application.

Examples:

```txt
core/
├── constants/
├── enums/
├── exceptions/
├── listeners/
├── models/
├── network/
├── providers/
├── routes/
├── services/
├── theme/
├── utils/
└── widgets/
```

---

# Core Folder Responsibilities

## constants/

Application constants.

Examples:

```txt
api_constants.dart
storage_key.dart
```

---

## enums/

Application-level enums.

Examples:

```txt
message_type.dart
connectivity_status.dart
permission_type.dart
```

---

## exceptions/

Centralized app exception handling.

Examples:

```txt
app_exception.dart
```

---

## listeners/

Global app listeners.

Examples:

```txt
app_listener.dart
```

---

## network/

Networking layer.

Examples:

```txt
api_client.dart
interceptors/
```

---

## providers/

Global providers.

Examples:

```txt
app_provider.dart
loading_provider.dart
connectivity_provider.dart
```

---

## routes/

Navigation layer.

Examples:

```txt
app_router.dart
app_routes.dart
```

---

## services/

Application services.

Examples:

```txt
storage_service.dart
permission_service.dart
notification_service.dart
connectivity_service.dart
flushbar_service.dart
```

---

## theme/

App theming.

Examples:

```txt
app_theme.dart
app_colors.dart
```

---

## widgets/

Global reusable app-level widgets.

Examples:

```txt
app_loader.dart
connectivity_listener.dart
```

---

# Shared Folder

`shared/` contains reusable generic utilities/components.

These should NOT know:
- auth
- navigation
- features
- app business logic

Structure:

```txt
shared/
├── design_system/
├── extensions/
├── models/
├── utils/
└── widgets/
```

---

# Shared Folder Responsibilities

## design_system/

Reusable design constants.

Examples:

```txt
app_spacing.dart
app_radius.dart
app_typography.dart
app_duration.dart
app_shadows.dart
```

---

## extensions/

Reusable extensions.

Examples:

```txt
context_extension.dart
```

---

## models/

Reusable shared models.

Examples:

```txt
api_response_model.dart
permission_result.dart
```

---

## utils/

Reusable utility functions.

Examples:

```txt
validators.dart
date_formatter.dart
retry_helper.dart
```

---

## widgets/

Reusable shared widgets.

Examples:

```txt
app_button.dart
app_textfield.dart
```

---

# Features Folder

Each feature contains its own:

- data
- domain
- presentation

Structure:

```txt
features/
├── auth/
├── home/
├── splash/
└── profile/
```

---

# Feature Structure

Example:

```txt
features/auth/
├── data/
├── domain/
└── presentation/
```

---

# Data Layer

Responsible for:
- API calls
- DTO models
- repository implementations

Structure:

```txt
data/
├── datasources/
├── models/
└── repositories/
```

---

# Domain Layer

Responsible for:
- business logic
- entities
- repository contracts
- usecases

Structure:

```txt
domain/
├── entities/
├── repositories/
└── usecases/
```

---

# Presentation Layer

Responsible for:
- screens
- providers
- states
- widgets

Structure:

```txt
presentation/
├── providers/
├── screens/
├── states/
└── widgets/
```

---

# API Integration Flow

When integrating APIs ALWAYS follow this order:

```txt
1. Understand backend request/response
2. Add endpoint constants
3. Create/update request model
4. Create/update response model
5. Implement datasource
6. Update repository
7. Update usecase
8. Update provider
9. Test UI
```

DO NOT start from UI.

Backend contract is the source of truth.

---

# Clean Architecture Rules

## UI Layer MUST NOT

- Call Dio directly
- Access storage directly
- Handle business logic
- Parse API response
- Navigate inside repository/provider

---

## Providers SHOULD Handle

- loading state
- app messages
- async operations
- UI state

---

## Repository SHOULD Handle

- data orchestration
- caching
- token storage
- response transformation

---

## Datasource SHOULD Handle

- API calls
- JSON parsing
- DTO conversion

ONLY.

---

# Navigation Rule

Navigation belongs ONLY in UI layer.

Correct:

```dart
ref.listen(provider, (_, next) {
  Navigator.pushNamed(...);
});
```

Wrong:

```dart
Navigator.pushNamed(...)
```

inside:
- repository
- provider
- usecase
- datasource

---

# Global App Architecture

Global app concerns are centralized.

Examples:

```txt
Global Messages
Global Loader
Connectivity
Notifications
Session Handling
```

Handled using:
- providers
- listeners
- services

---

# Current Global Systems

Implemented:

```txt
✅ Connectivity Architecture
✅ Global Loader
✅ Global Toast System
✅ Permission System
✅ Notification System
✅ Dio Networking
✅ Interceptors
✅ Global App Messages
✅ Localization (l10n)
```

---

# Localization (l10n)

The project uses Flutter's official `flutter_localizations` + `intl` ARB
workflow with a Riverpod-driven locale switcher.

## Supported Locales

```txt
en — English (default)
gu — Gujarati
```

## File Layout

```txt
l10n.yaml                          # gen-l10n config
lib/l10n/
├── app_en.arb                     # English translations (template)
├── app_gu.arb                     # Gujarati translations
├── app_localizations.dart         # generated (do not edit)
├── app_localizations_en.dart      # generated (do not edit)
└── app_localizations_gu.dart      # generated (do not edit)
```

## Key Components

```txt
lib/src/core/providers/locale_provider.dart   # Locale state + supportedLocales
lib/src/app.dart                              # Wires locale into MaterialApp
```

`localeProvider` is a `StateNotifierProvider<LocaleNotifier, Locale>`
that holds the active `Locale`. The `App` widget watches it and rebuilds
`MaterialApp` whenever the locale changes.

---

# Adding a New String

1. Add the key to `lib/l10n/app_en.arb` (the template):

   ```json
   {
     "greeting": "Hello {name}!",
     "@greeting": {
       "placeholders": { "name": { "type": "String" } }
     }
   }
   ```

2. Add the same key to every other ARB file (e.g. `app_gu.arb`).

3. Regenerate the bindings:

   ```bash
   flutter gen-l10n
   ```

4. Use it in any widget:

   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.greeting("Dhaval"));
   ```

---

# Adding a New Language

1. Create `lib/l10n/app_<code>.arb` with all keys from `app_en.arb`.
2. Add the `Locale` to `supportedLocales` in `locale_provider.dart`.
3. Add a setter to `LocaleNotifier` (e.g. `setHindi()`), or rely on
   `setLocale(Locale)`.
4. Add a menu item in the language switcher (see `home_screen.dart`).
5. Run `flutter gen-l10n`.

---

# Switching Language at Runtime

Read the notifier and call `setLocale`:

```dart
ref.read(localeProvider.notifier).setLocale(const Locale('gu'));
```

A live example lives in the Home AppBar — the globe icon opens a
`PopupMenuButton<Locale>` of supported languages and updates
`localeProvider` on selection. `MaterialApp` rebuilds and every
`AppLocalizations.of(context)` call reflects the new locale.

---

# Localization Rules

## DO

- Put every user-visible string in ARB files
- Use `AppLocalizations.of(context)!` inside `build`
- Use placeholders for dynamic values, not string interpolation
- Keep all ARB files in sync — same keys, all locales

## DO NOT

- Hardcode user-visible text in widgets
- Concatenate translated fragments — write a single ARB entry with
  placeholders so translators can reorder words naturally
- Edit `app_localizations*.dart` by hand (they are regenerated)

---

# Feature Creation Commands

## macOS / Linux

```bash
FEATURE=profile && \
mkdir -p lib/src/features/$FEATURE/data/datasources && \
mkdir -p lib/src/features/$FEATURE/data/models && \
mkdir -p lib/src/features/$FEATURE/data/repositories && \
mkdir -p lib/src/features/$FEATURE/domain/entities && \
mkdir -p lib/src/features/$FEATURE/domain/repositories && \
mkdir -p lib/src/features/$FEATURE/domain/usecases && \
mkdir -p lib/src/features/$FEATURE/presentation/providers && \
mkdir -p lib/src/features/$FEATURE/presentation/screens && \
mkdir -p lib/src/features/$FEATURE/presentation/states && \
mkdir -p lib/src/features/$FEATURE/presentation/widgets
```

---

## Windows PowerShell

```powershell
$FEATURE="profile"

mkdir "lib/src/features/$FEATURE/data/datasources"
mkdir "lib/src/features/$FEATURE/data/models"
mkdir "lib/src/features/$FEATURE/data/repositories"

mkdir "lib/src/features/$FEATURE/domain/entities"
mkdir "lib/src/features/$FEATURE/domain/repositories"
mkdir "lib/src/features/$FEATURE/domain/usecases"

mkdir "lib/src/features/$FEATURE/presentation/providers"
mkdir "lib/src/features/$FEATURE/presentation/screens"
mkdir "lib/src/features/$FEATURE/presentation/states"
mkdir "lib/src/features/$FEATURE/presentation/widgets"
```

---

# Recommended Future Improvements

Planned architecture additions:

```txt
- Token Refresh Flow
- Environment Config
- Route Guards
- Theme Switching
- Localization
- Pagination
- Offline Cache
- Analytics
- WebSocket Architecture
- Feature Generator CLI
```

---

# Important Development Rules

## DO

- Keep business logic outside UI
- Keep providers clean
- Use repository abstraction
- Use usecases
- Reuse shared widgets
- Centralize global concerns

---

## DO NOT

- Put navigation inside providers
- Put Dio calls inside UI
- Put feature logic inside core
- Duplicate reusable widgets
- Parse API directly in screens

---

# Architecture Philosophy

The project prioritizes:

- Scalability
- Maintainability
- Separation of Concerns
- Reusability
- Clear Boundaries
- Enterprise-grade structure

---

# Important AI Instruction

Before generating modifications:
- inspect existing architecture
- follow naming conventions
- avoid duplicate implementations
- respect feature boundaries

If implementation requires existing code context,
ask for the specific file before modifying.