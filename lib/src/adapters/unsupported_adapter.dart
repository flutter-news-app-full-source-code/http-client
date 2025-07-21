import 'package:dio/dio.dart';

/// Throws an [UnsupportedError] because the current platform is not supported.
HttpClientAdapter createAdapter() =>
    throw UnsupportedError('Cannot create a client adapter for this platform.');
