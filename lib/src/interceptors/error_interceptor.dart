import 'dart:io';

import 'package:core/core.dart';
import 'package:dio/dio.dart';

/// Dio interceptor that catches [DioException]s and maps them to specific
/// [HttpException] subtypes for clearer error handling downstream.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final HttpException mappedException;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        // Handle specific connection-related errors
        mappedException = const NetworkException();
      case DioExceptionType.badResponse:
        // Handle errors based on HTTP status codes
        final statusCode = err.response?.statusCode;
        final responseData = err.response?.data;
        // Attempt to extract a message from the response, default otherwise
        final message =
            _extractErrorMessage(responseData) ??
            err.message ??
            'Unknown error occurred';

        // Handle null status code explicitly before the switch
        if (statusCode == null) {
          mappedException = UnknownException(
            'Received response with null status code. Message: $message',
          );
        } else {
          // Proceed with the switch only if statusCode is not null
          switch (statusCode) {
            case HttpStatus.badRequest: // 400
              mappedException = BadRequestException(message);
            case HttpStatus.unauthorized: // 401
              mappedException = UnauthorizedException(message);
            case HttpStatus.forbidden: // 403
              mappedException = ForbiddenException(message);
            case HttpStatus.notFound: // 404
              mappedException = NotFoundException(message);
            case >= HttpStatus.internalServerError: // 500 and above
              mappedException = ServerException(message);
            default:
              mappedException = UnknownException(
                'Received invalid status code: $statusCode. Message: $message',
              );
          }
        }
      case DioExceptionType.cancel:
        // Request was cancelled, potentially intentionally.
        mappedException = const UnknownException('Request cancelled');
      // Explicitly handle badCertificate, often related to network/setup issues
      case DioExceptionType.badCertificate:
        mappedException =
            const NetworkException(); // Or UnknownException if preferred
      // Explicitly handle unknown type
      case DioExceptionType.unknown:
        // Check if the underlying error is a SocketException (network issue)
        if (err.error is SocketException) {
          mappedException = const NetworkException();
        } else {
          // Otherwise, treat as a generic unknown error
          mappedException = UnknownException(
            err.message ?? 'An unknown error occurred',
          );
        }
    } // End of switch (err.type)

    // Instead of resolving, we reject the handler with the mapped exception
    // This ensures the error propagates correctly through the Dio call stack.
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mappedException, // Embed our custom exception here
      ),
    );
  }

  /// Attempts to extract a meaningful error message from various
  /// response formats.
  String? _extractErrorMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map) {
      // New Pattern: Check for the nested {"error": {"message": "..."}}
      if (responseData.containsKey('error') && responseData['error'] is Map) {
        final errorMap = responseData['error'] as Map;
        if (errorMap.containsKey('message') && errorMap['message'] is String) {
          return errorMap['message'] as String;
        }
      }

      // Fallback to common flat patterns: 'message', 'error', 'detail' keys.
      if (responseData.containsKey('message') &&
          responseData['message'] is String) {
        return responseData['message'] as String;
      }
      if (responseData.containsKey('error') &&
          responseData['error'] is String) {
        return responseData['error'] as String;
      }
      if (responseData.containsKey('detail') &&
          responseData['detail'] is String) {
        return responseData['detail'] as String;
      }
    } else if (responseData is String) {
      return responseData;
    }
    return null; // No standard message found
  }
}
