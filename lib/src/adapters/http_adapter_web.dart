import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Returns a [BrowserHttpClientAdapter] for web platforms.
HttpClientAdapter createAdapter() =>
    BrowserHttpClientAdapter(withCredentials: true);
