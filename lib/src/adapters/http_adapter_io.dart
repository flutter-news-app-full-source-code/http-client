import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// Returns a [IOHttpClientAdapter] for native platforms.
HttpClientAdapter createAdapter() => IOHttpClientAdapter();
