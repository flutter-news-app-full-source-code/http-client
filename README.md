<div align="center">
  <img src="https://avatars.githubusercontent.com/u/202675624?s=400&u=dc72a2b53e8158956a3b672f8e52e39394b6b610&v=4" alt="Flutter News App Toolkit Logo" width="220">
  <h1>HTTP Client</h1>
  <p><strong>A robust and reusable Dart HTTP client built on top of the `dio` package, serving as a crucial abstraction layer within the Flutter News App Full Source Code Toolkit.</strong></p>
</div>

<p align="center">
  <img src="https://img.shields.io/badge/coverage-68%25-green?style=for-the-badge" alt="coverage: XX%">
  <a href="https://flutter-news-app-full-source-code.github.io/docs/"><img src="https://img.shields.io/badge/LIVE_DOCS-VIEW-slategray?style=for-the-badge" alt="Live Docs: View"></a>
  <a href="https://github.com/flutter-news-app-full-source-code"><img src="https://img.shields.io/badge/MAIN_PROJECT-BROWSE-purple?style=for-the-badge" alt="Main Project: Browse"></a>
</p>

This `http_client` package serves as the foundational HTTP client for the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). Built on top of the `dio` package, it simplifies API interactions by providing common HTTP methods, automatic authentication header injection, and mapping network/status code errors to specific custom exceptions. It ensures consistent and robust communication with backend services across the Flutter mobile app, web dashboard, and Dart Frog backend API.

## ⭐ Feature Showcase: Streamlined & Secure API Communication

This package provides a comprehensive set of features for managing HTTP requests.

<details>
<summary><strong>🧱 Core Functionality</strong></summary>

### 🚀 Robust `HttpClient`
- **`HttpClient` Class:** The main entry point for making HTTP requests, abstracting away `dio` complexities.
- **Simplified HTTP Methods:** Provides `get<T>()`, `post<T>()`, `put<T>()`, and `delete<T>()` methods for common API interactions.

### 🔐 Automatic Authentication
- **`AuthInterceptor`:** Automatically injects `Authorization: Bearer <token>` headers into requests.
- **Flexible `TokenProvider`:** Retrieves authentication tokens via a configurable asynchronous function, allowing integration with various authentication mechanisms.

### 🛡️ Standardized Error Handling
- **`ErrorInterceptor`:** Maps `DioException` types and non-2xx HTTP status codes to specific `HttpException` subtypes (e.g., `NetworkException`, `BadRequestException`, `UnauthorizedException`, `NotFoundException`, `ServerException`, `UnknownException`) defined in the `core` package. This ensures predictable and consistent error management across the application layers.

### ⚡ Performance & Control
- **Request Cancellation:** Supports request cancellation using `dio`'s `CancelToken` for improved resource management and user experience.
- **Configurable Timeouts:** Allows configuration of connection, receive, and send timeouts for robust network operations.

### 🌐 Platform Adaptability
- **`BrowserHttpClientAdapter` & `IOHttpClientAdapter`:** Automatically selects the appropriate HTTP client adapter for web and non-web platforms, ensuring seamless operation across different environments.

> **💡 Your Advantage:** You get a meticulously designed, production-quality HTTP client that simplifies API interactions, ensures secure authentication, provides robust error handling, and adapts to different platforms. This package accelerates development by providing a solid foundation for network communication.

</details>

## 🔑 Licensing

This `http_client` package is an integral part of the [**Flutter News App Full Source Code Toolkit**](https://github.com/flutter-news-app-full-source-code). For comprehensive details regarding licensing, including trial and commercial options for the entire toolkit, please refer to the main toolkit organization page.
