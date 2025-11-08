/// A robust HTTP client built on top of Dio, providing simplified API calls,
/// automatic authentication header injection, and custom exception mapping.
library;

// Export Dio types
export 'package:dio/dio.dart'
    show CancelToken, DioException, Interceptor, InterceptorsWrapper, Options;

// Export the main client class
export 'src/http_client.dart';
// Export the TokenProvider typedef for convenience
export 'src/interceptors/auth_interceptor.dart' show TokenProvider;
