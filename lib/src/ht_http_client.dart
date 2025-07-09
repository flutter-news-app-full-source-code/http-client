//
// ignore_for_file: only_throw_errors

import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:ht_http_client/src/interceptors/auth_interceptor.dart';
import 'package:ht_http_client/src/interceptors/error_interceptor.dart';
import 'package:ht_shared/ht_shared.dart';
import 'package:logging/logging.dart';

/// {@template ht_http_client}
/// A robust HTTP client built on top of Dio, providing simplified API calls,
/// automatic authentication header injection, and custom exception mapping.
///
/// This client handles common HTTP methods (GET, POST, PUT, DELETE) and maps
/// Dio errors and non-2xx status codes to specific [HtHttpException] subtypes
/// defined in `exceptions.dart`.
/// {@endtemplate}
class HtHttpClient {
  /// {@macro ht_http_client}
  ///
  /// Creates an instance of [HtHttpClient].
  ///
  /// Requires a "baseUrl" for the API endpoint and a [tokenProvider] function
  /// to asynchronously retrieve the authentication token.
  ///
  /// Optionally accepts a:
  /// - pre-configured [dioInstance] for advanced customization
  ///   or testing
  /// - list of additional [interceptors] to be added alongside
  ///   the default Auth and Error interceptors.
  /// - [logger]: Optional [Logger] instance for logging HTTP requests and responses.
  HtHttpClient({
    required String baseUrl,
    required TokenProvider tokenProvider,
    required bool isWeb,
    Dio? dioInstance,
    List<Interceptor>? interceptors,
    Logger? logger,
  })  : _dio = dioInstance ?? Dio(),
        _logger = logger ?? Logger('HtHttpClient') {
    // Configure base options
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );

    // Set the appropriate HttpClientAdapter
    if (isWeb) {
      _dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
    } else {
      _dio.httpClientAdapter = IOHttpClientAdapter();
    }

    // Add default interceptors
    _dio.interceptors.addAll([
      AuthInterceptor(tokenProvider: tokenProvider),
      ErrorInterceptor(),
      // Add any custom interceptors provided
      ...?interceptors,
    ]);

    // Optionally add logging interceptor for debugging
    // _dio.interceptors.add(
    //  LogInterceptor(requestBody: true, responseBody: true)
    // );
  }

  /// The configured Dio instance used for making requests.
  final Dio _dio;

  /// The logger instance for this HTTP client.
  final Logger _logger;

  /// Performs a GET request.
  ///
  /// - [path]: The endpoint path appended to the "baseUrl".
  /// - [queryParameters]: Optional map of query parameters.
  /// - [options]: Optional [Options] to override Dio defaults for this request.
  /// - [cancelToken]: Optional [CancelToken] for request cancellation.
  ///
  /// Returns the response data decoded as type [T].
  /// Throws an [HtHttpException] on network errors or non-2xx status codes.
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _logger.info(
      'GET request to: $path, Query Parameters: $queryParameters',
    );
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _logger.info('GET request to $path successful. Status: ${response.statusCode}');
      // Dio automatically throws for non-2xx, ErrorInterceptor maps it
      return response.data as T;
    } on DioException catch (e) {
      if (e.error is HtHttpException) {
        _logger.severe(
          'GET request to $path failed with HtHttpException: ${e.error}',
        );
        throw e.error!;
      }
      _logger.severe('GET request to $path failed with DioException: $e');
      rethrow;
    }
  }

  /// Performs a POST request.
  ///
  /// - [path]: The endpoint path appended to the "baseUrl".
  /// - [data]: Optional request body data.
  /// - [queryParameters]: Optional map of query parameters.
  /// - [options]: Optional [Options] to override Dio defaults for this request.
  /// - [cancelToken]: Optional [CancelToken] for request cancellation.
  ///
  /// Returns the response data decoded as type [T].
  /// Throws an [HtHttpException] on network errors or non-2xx status codes.
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _logger.info(
      'POST request to: $path, Query Parameters: $queryParameters, Data: $data',
    );
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _logger.info('POST request to $path successful. Status: ${response.statusCode}');
      return response.data as T;
    } on DioException catch (e) {
      if (e.error is HtHttpException) {
        _logger.severe(
          'POST request to $path failed with HtHttpException: ${e.error}',
        );
        throw e.error!;
      }
      _logger.severe('POST request to $path failed with DioException: $e');
      rethrow;
    }
  }

  /// Performs a PUT request.
  ///
  /// - [path]: The endpoint path appended to the "baseUrl".
  /// - [data]: Optional request body data.
  /// - [queryParameters]: Optional map of query parameters.
  /// - [options]: Optional [Options] to override Dio defaults for this request.
  /// - [cancelToken]: Optional [CancelToken] for request cancellation.
  ///
  /// Returns the response data decoded as type [T].
  /// Throws an [HtHttpException] on network errors or non-2xx status codes.
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _logger.info(
      'PUT request to: $path, Query Parameters: $queryParameters, Data: $data',
    );
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _logger.info('PUT request to $path successful. Status: ${response.statusCode}');
      return response.data as T;
    } on DioException catch (e) {
      if (e.error is HtHttpException) {
        _logger.severe(
          'PUT request to $path failed with HtHttpException: ${e.error}',
        );
        throw e.error!;
      }
      _logger.severe('PUT request to $path failed with DioException: $e');
      rethrow;
    }
  }

  /// Performs a DELETE request.
  ///
  /// - [path]: The endpoint path appended to the "baseUrl".
  /// - [data]: Optional request body data (less common for DELETE).
  /// - [queryParameters]: Optional map of query parameters.
  /// - [options]: Optional [Options] to override Dio defaults for this request.
  /// - [cancelToken]: Optional [CancelToken] for request cancellation.
  ///
  /// Returns the response data decoded as type [T].
  /// Throws an [HtHttpException] on network errors or non-2xx status codes.
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _logger.info(
      'DELETE request to: $path, Query Parameters: $queryParameters, Data: $data',
    );
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _logger.info('DELETE request to $path successful. Status: ${response.statusCode}');
      return response.data as T;
    } on DioException catch (e) {
      if (e.error is HtHttpException) {
        _logger.severe(
          'DELETE request to $path failed with HtHttpException: ${e.error}',
        );
        throw e.error!;
      }
      _logger.severe('DELETE request to $path failed with DioException: $e');
      rethrow;
    }
  }
}
