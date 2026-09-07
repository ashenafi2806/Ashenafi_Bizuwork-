# Safaricom M-PESA Flutter Task

A Flutter implementation of a Safaricom M-PESA user flow with PIN authentication and a balance dashboard.

## Implemented Flow

The app contains three user-facing screens:

1. **Welcome screen**
   - M-PESA branding
   - Red `Sign in` action
   - M-PESA status text

2. **PIN sign-in screen**
   - English/Amharic language selector
   - Welcome profile header
   - Four-digit PIN keypad
   - PIN validation
   - Loading state while signing in
   - API error feedback
   - Continue button and support links

3. **Home dashboard**
   - Morning greeting and notifications icon
   - Main, Reward, and Errif balances
   - Balance visibility toggle
   - Add Money button
   - Six-service grid:
     - Merchant Payment
     - Bill Payment
     - Credit & Saving
     - Transfer Money
     - Airtime / Package
     - More Services
   - Three demonstration transaction cards

## Architecture

The project uses a lightweight Clean Architecture structure:

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   └── network/dio/
├── data/
│   ├── data_sources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── presentation/
│   ├── bloc/
│   ├── pages/
│   └── widgets/
└── main.dart
```

- **Domain** contains `UserEntity`, the `AuthRepository` contract, and `LoginUseCase`.
- **Data** contains the Dio remote data source and repository implementation that maps API responses into domain entities.
- **Presentation** contains the pages and `AuthCubit`, which manages validation, loading, success, and failure states.
- **Core** contains networking, exception handling, constants, and GetIt dependency injection.

This separation keeps API details out of the UI and allows repositories or use cases to be replaced with test doubles.

## API

The sign-in request uses the supplied mock endpoint:

```text
POST https://api.mockfly.dev/mocks/5064738f-5131-4b0a-8909-ca1634e26c27/login
```

Request body:

```json
{
  "pin": "1111"
}
```

The demo API documentation specifies `1111` as the successful PIN. The app sends the request only after exactly four digits have been entered.

## Packages

- `dio`: HTTP client and API communication.
- `flutter_bloc`: Cubit-based authentication state management.
- `get_it`: dependency injection.
- `iconsax`: icons used throughout the interface.
- `equatable`: value equality for network exceptions.
- `flutter_dotenv`: available for environment configuration if API settings move to environment files.

The UI uses Flutter Material components with sharp-corner controls to match the requested M-PESA design.

## Important Technical Decisions

- A `Cubit` is used instead of event-based Bloc because the authentication flow has one focused action: submit a PIN.
- The API response is mapped directly into `UserEntity`; generated JSON models are not required for this small mock response.
- PIN and balance values are masked by default where appropriate.
- Add Money, notifications, service tiles, and support links are currently UI actions only because no APIs were supplied for those features.
- Demo transactions are static presentation data as requested.

## Testing

The widget test covers:

- Welcome-to-PIN navigation.
- PIN length validation.
- Home-page service labels.
- Transaction list rendering.
- Balance masking and visibility toggling.

Run tests with:

```bash
flutter test
```

## Running the App

Prerequisites:

- Flutter SDK compatible with Dart `3.12.0` or newer.
- Android emulator, iOS simulator, or a connected physical device.

From the project root:

```bash
flutter pub get
flutter run
```

## AI Tools

AI assistance was used to inspect the supplied workflow and architecture guides, implement the Clean Architecture layers, build the requested UI screens, integrate the mock API, update widget tests, and review the project documentation. The implementation was checked against the project requirements and local Dart diagnostics.
