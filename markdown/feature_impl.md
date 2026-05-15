# Clean Architecture + API Integration Flow Guide

# Most Important Understanding

Clean Architecture is NOT about folders.

It is about:

```txt
Separation of Responsibility
```

Flow:

```txt
UI
↓
Provider
↓
Usecase
↓
Repository
↓
Datasource
↓
API
```

UI should NEVER directly:
- call Dio
- parse JSON
- access storage
- know API structure

---

# Real Feature Development Flow

Whenever creating a new feature ALWAYS follow this order:

```txt
1. Understand requirement
2. Create feature folders
3. Create Domain layer
4. Create Data layer
5. Create Presentation layer
6. Add routing
7. Test feature
```

---

# Example Feature

We will create:

```txt
Profile Feature
```

Requirements:

```txt
- Get profile data
- Show profile screen
- Update profile
```

---

# STEP 1 — Create Feature Folder

## macOS/Linux

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

# STEP 2 — DOMAIN Layer

Domain defines BUSINESS LOGIC.

Domain does NOT know:
- Dio
- Flutter
- JSON
- APIs

---

# 2.1 Entity

## File

```txt
domain/entities/profile_entity.dart
```

## Code

```dart
class ProfileEntity {
  final String id;
  final String name;
  final String email;

  ProfileEntity({
    required this.id,
    required this.name,
    required this.email,
  });
}
```

Entity is PURE business object.

No JSON parsing.

---

# 2.2 Repository Contract

## File

```txt
domain/repositories/profile_repository.dart
```

## Code

```dart
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
}
```

Repository contract defines:
- what feature can do

NOT how it works.

---

# 2.3 Usecase

## File

```txt
domain/usecases/get_profile_usecase.dart
```

## Code

```dart
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<ProfileEntity> call() {
    return repository.getProfile();
  }
}
```

Usecase contains:
- business operation

---

# STEP 3 — DATA Layer

Data layer handles:
- API calls
- JSON parsing
- Models
- Storage
- Mapping

---

# IMPORTANT UNDERSTANDING

# Entity != Model

---

# Entity

Business object.

```dart
ProfileEntity
```

---

# Model

API/storage object.

```dart
ProfileModel
```

Knows JSON.

---

# Backend Response Example

Suppose backend gives:

```json
{
  "success": true,
  "message": "Profile fetched",
  "data": {
    "id": "1",
    "name": "Smit",
    "email": "smit@gmail.com"
  }
}
```

Backend response controls DATA layer.

---

# 3.1 API Endpoint

## File

```txt
core/constants/api_constants.dart
```

## Code

```dart
class ApiConstants {
  ApiConstants._();

  static const String getProfile =
      "/profile";
}
```

---

# 3.2 Response Model

## File

```txt
data/models/profile_model.dart
```

## Code

```dart
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory ProfileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProfileModel(
      id: json["id"],
      name: json["name"],
      email: json["email"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
    };
  }
}
```

Model:
- parses JSON
- converts data

---

# 3.3 Datasource

Datasource ONLY handles:
- API call
- parsing

NOT business logic.

---

## File

```txt
data/datasources/profile_remote_datasource.dart
```

## Code

```dart
import '../models/profile_model.dart';

abstract class ProfileRemoteDatasource {
  Future<ProfileModel> getProfile();
}
```

---

# 3.4 Datasource Implementation

## File

```txt
data/datasources/profile_remote_datasource_impl.dart
```

## Code

```dart
import 'package:flutter_template/src/core/constants/api_constants.dart';
import 'package:flutter_template/src/core/network/api_client.dart';

import '../models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDatasourceImpl
    implements ProfileRemoteDatasource {

  @override
  Future<ProfileModel> getProfile() async {
    final response = await ApiClient.get(
      ApiConstants.getProfile,
    );

    return ProfileModel.fromJson(
      response.data["data"],
    );
  }
}
```

Datasource ONLY calls API.

---

# 3.5 Repository Implementation

Repository bridges:
- Domain
- Data

Responsibilities:
- call datasource
- storage
- cache
- mapping

---

## File

```txt
data/repositories/profile_repository_impl.dart
```

## Code

```dart
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';

import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl
    implements ProfileRepository {

  final ProfileRemoteDatasource
      remoteDatasource;

  ProfileRepositoryImpl(
    this.remoteDatasource,
  );

  @override
  Future<ProfileEntity> getProfile() async {
    return await remoteDatasource.getProfile();
  }
}
```

---

# STEP 4 — PRESENTATION Layer

Presentation layer handles:
- UI
- state
- user interaction

---

# 4.1 State

## File

```txt
presentation/states/profile_state.dart
```

## Code

```dart
class ProfileState {
  final bool isLoading;

  const ProfileState({
    this.isLoading = false,
  });

  ProfileState copyWith({
    bool? isLoading,
  }) {
    return ProfileState(
      isLoading:
          isLoading ?? this.isLoading,
    );
  }
}
```

---

# 4.2 Provider

Provider handles:
- loading
- UI state
- calling usecase

---

## File

```txt
presentation/providers/profile_provider.dart
```

## Code

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/get_profile_usecase.dart';

final profileProvider =
    NotifierProvider<
        ProfileNotifier,
        ProfileState>(
  ProfileNotifier.new,
);

class ProfileNotifier
    extends Notifier<ProfileState> {

  late final GetProfileUsecase
      _getProfileUsecase;

  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> getProfile() async {
    state = state.copyWith(
      isLoading: true,
    );

    try {
      final profile =
          await _getProfileUsecase();

      print(profile.name);

    } catch (e) {

    } finally {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }
}
```

Provider coordinates:
- UI
- business logic

---

# 4.3 Screen

Screen ONLY builds UI.

Should NOT:
- parse JSON
- call Dio
- know API

---

## File

```txt
presentation/screens/profile_screen.dart
```

## Code

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';

class ProfileScreen
    extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final state =
        ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref
                .read(
                  profileProvider.notifier,
                )
                .getProfile();
          },
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Text("Get Profile"),
        ),
      ),
    );
  }
}
```

---

# FULL FLOW VISUALIZATION

```txt
User taps button
↓
Provider
↓
Usecase
↓
Repository
↓
Datasource
↓
API

Response comes back

API
↑
Datasource
↑
Repository
↑
Usecase
↑
Provider
↑
UI updates
```

---

# IMPORTANT RULES

# UI Layer MUST NOT

- Call Dio
- Parse JSON
- Access storage
- Know API response

---

# Datasource MUST ONLY

- Call API
- Parse JSON

---

# Repository SHOULD

- Handle storage
- Handle caching
- Handle mapping
- Handle orchestration

---

# Usecase SHOULD

- Represent business operation

---

# Provider SHOULD

- Handle loading
- Handle messages
- Update UI state

---

# GOLDEN RULE

Backend response changes should ONLY affect:

```txt
data/models/
data/datasources/
data/repositories/
```

NOT:
- UI
- Provider
- Screens

This is WHY clean architecture scales.

---

# FINAL DEVELOPMENT FLOW

Whenever creating ANY feature:

```txt
1. Understand requirement
2. Create folders
3. Create entity
4. Create repository contract
5. Create usecase
6. Understand backend request/response
7. Create models
8. Create datasource
9. Create repository implementation
10. Create provider
11. Create UI
12. Add routes
13. Test
```

Follow this sequence EVERY time.