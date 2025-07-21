export 'unsupported_adapter.dart'
    if (dart.library.html) 'http_adapter_web.dart'
    if (dart.library.io) 'http_adapter_io.dart';
