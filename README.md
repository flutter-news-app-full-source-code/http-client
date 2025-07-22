# http_client

![coverage: percentage](https://img.shields.io/badge/coverage-XX-green)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: PolyForm Free Trial](https://img.shields.io/badge/License-PolyForm%20Free%20Trial-blue)](https://polyformproject.org/licenses/free-trial/1.0.0)

A robust and reusable Dart HTTP client built on top of the `dio` package. It simplifies API interactions by providing common HTTP methods, automatic authentication header injection, and mapping network/status code errors to specific custom exceptions.

## Description

This package provides an `HttpClient` class designed to be used as a foundational data access component in Dart or Flutter applications. It abstracts away the complexities of setting up `dio`, handling authentication tokens, and interpreting various HTTP error conditions, offering a cleaner interface for making API calls.

Key features include:
*   Base URL configuration.
*   Simplified `get`, `post`, `put`, `delete` methods.
*   Automatic injection of `Authorization: Bearer <token>` headers via an interceptor.
*   Token retrieval via a flexible `TokenProvider` function.
*   Mapping of `DioException` types and non-2xx HTTP status codes to specific `HttpException` subtypes (`NetworkException`, `BadRequestException`, `UnauthorizedException`, etc.) defined in the `core` package.
*   Support for request cancellation using `dio`'s `CancelToken`.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  http_client:
    git:
        url: https://github.com/flutter-news-app-full-source-code/http-client.git
  dio: ^5.8.0+1 # http_client relies on dio
```

Then run `dart pub get` or `flutter pub get`.

## Features

*   **`HttpClient` Class:** The main entry point for making requests.
*   **HTTP Methods:** `get<T>()`, `post<T>()`, `put<T>()`, `delete<T>()`.
*   **Authentication:** Automatic Bearer token injection using a provided `TokenProvider`.
*   **Error Handling:** Throws specific `HttpException` subtypes (defined in `core`) for easier error management.
*   **Cancellation:** Supports request cancellation via `CancelToken`.

## Usage

```dart
import 'package:http_client/http_client.dart';
import 'package:core/core.dart'; // Import for HttpException types
import 'package:dio/dio.dart'; // For CancelToken

// 1. Define your token provider function
// (This would typically fetch the token from secure storage, auth state, etc.)
Future<String?> myTokenProvider() async {
  // Replace with your actual token retrieval logic
  await Future.delayed(const Duration(milliseconds: 50)); // Simulate async fetch
  return 'your_super_secret_auth_token';
}

void main() async {
  // 2. Create an instance of the client
  final client = HttpClient(
    baseUrl: 'https://api.example.com/v1',
    tokenProvider: myTokenProvider,
  );

  // 3. Make requests

  // Example GET request
  try {
    final headlines = await client.get<List<dynamic>>('/headlines');
    print('Fetched headlines: $headlines');

    // Example GET with query parameters and cancellation
    final cancelToken = CancelToken();
    Future.delayed(const Duration(milliseconds: 100), () {
       print('Cancelling search request...');
       cancelToken.cancel('User navigated away');
    });

    final searchResults = await client.get<Map<String, dynamic>>(
      '/search',
      queryParameters: {'q': 'flutter', 'limit': 10},
      cancelToken: cancelToken, // Pass the token here
    );
    print('Search results: $searchResults');

  } on UnauthorizedException catch (e) {
    print('Authentication error: ${e.message}');
    // Handle token refresh or prompt user to login
  } on NetworkException catch (e) {
    print('Network error: ${e.message}');
    // Handle offline state or retry logic
  } on NotFoundException catch (e) {
    print('Resource not found: ${e.message}');
  } on HttpException catch (e) { // Catch other specific or general client errors
    print('HTTP Client Error: ${e.message}');
  } catch (e) { // Catch any other unexpected errors
    print('An unexpected error occurred: $e');
  }

  // Example POST request
  try {
    final newItem = await client.post<Map<String, dynamic>>(
      '/items',
      data: {'name': 'New Item', 'value': 123},
    );
    print('Created item: $newItem');
  } on HttpException catch (e) {
     print('Error creating item: ${e.message}');
  }
}

```

## 🔑 Licensing

This package is source-available and licensed under the [PolyForm Free Trial 1.0.0](LICENSE). Please review the terms before use.

For commercial licensing options that grant the right to build and distribute unlimited applications, please visit the main [**Flutter News App - Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code) organization.
