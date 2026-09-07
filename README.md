# M-PESA Login UI

Two-screen Flutter implementation of the Safaricom M-PESA sign-in flow: a welcome page and a PIN authentication page.

## Architecture

The app follows a lightweight Clean Architecture structure:

- `domain`: `UserEntity`, `AuthRepository`, and `LoginUseCase` contain business contracts.
- `data`: `RemoteDataSource` performs the Dio request and `AuthRepositoryImpl` maps the API response.
- `presentation`: `AuthCubit` owns validation/loading/success/failure state, while the pages render and react to it.
- `core`: Dio configuration, exception mapping, constants, and GetIt dependency injection.

This keeps API details out of the UI and makes the use case and repository easy to replace with test doubles.

## Packages

- `flutter_bloc`: predictable authentication state management.
- `dio`: HTTP client for the supplied login endpoint.
- `get_it`: dependency registration at the composition root.
- `iconsax`: consistent icons for language, PIN, help, and navigation controls.
- `equatable`: existing network exception value semantics.

## Technical Decisions

- The supplied mock API is called only after a complete four-digit PIN is entered.
- API and network failures are surfaced as a SnackBar, while the Continue button shows a progress indicator during the request.
- The keypad is implemented as a reusable grid and uses fixed-size, sharp-corner PIN cells to match the requested design.
- The logo and user avatar are rendered locally so the two-screen flow does not depend on unavailable image assets.

## AI Tools

AI assistance was used to inspect the provided workflow and architecture guides, shape the clean-architecture slices, implement the UI and API integration, and update the widget test and documentation. All generated code was kept within the existing project structure and reviewed for the requested behavior.

## Run

1. Install Flutter 3.12 or newer and ensure `flutter` is available on PATH.
2. From the project root, run `flutter pub get`.
3. Start an emulator or connect a device.
4. Run `flutter run`.
5. Execute `flutter test` to run the widget test.

The mock API accepts PIN `1111` according to the supplied API brief.
