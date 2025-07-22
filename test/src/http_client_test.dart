// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:http_client/src/http_client.dart';
import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

// Mocks
class MockDio extends Mock implements Dio {}

class MockLogger extends Mock implements Logger {}

class MockHttpClientAdapter extends Mock implements HttpClientAdapter {}

// Local typedef to resolve analyzer issue
typedef TokenProvider = Future<String?> Function();

void main() {
  setUpAll(() {
    registerFallbackValue(BaseOptions());
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(StackTrace.empty);
  });

  group('HttpClient', () {
    late Dio mockDio;
    late Logger mockLogger;
    late HttpClient httpClient;
    late TokenProvider tokenProvider;
    late MockHttpClientAdapter mockHttpClientAdapter;

    const baseUrl = 'http://test.com/api';

    setUp(() {
      mockDio = MockDio();
      mockLogger = MockLogger();
      tokenProvider = () async => 'test_token';
      mockHttpClientAdapter = MockHttpClientAdapter();

      // Stubbing Dio's properties
      when(() => mockDio.options).thenReturn(BaseOptions());
      when(() => mockDio.interceptors).thenReturn(Interceptors());
      when(() => mockDio.httpClientAdapter).thenReturn(mockHttpClientAdapter);
      when(() => mockDio.options = any()).thenReturn(BaseOptions());

      // Stub logger calls to prevent UnimplementedError
      when(() => mockLogger.info(any())).thenReturn(null);
      when(() => mockLogger.severe(any())).thenReturn(null);

      httpClient = HttpClient(
        baseUrl: baseUrl,
        tokenProvider: tokenProvider,
        dioInstance: mockDio,
        logger: mockLogger,
      );
    });

    test('constructor configures Dio instance correctly', () {
      // Arrange
      final capturedOptions =
          verify(() => mockDio.options = captureAny()).captured.single
              as BaseOptions;

      // Assert
      expect(capturedOptions.baseUrl, baseUrl);
      expect(capturedOptions.connectTimeout, const Duration(seconds: 15));
      expect(capturedOptions.receiveTimeout, const Duration(seconds: 15));
      expect(capturedOptions.sendTimeout, const Duration(seconds: 15));

      verify(() => mockDio.interceptors.addAll(any())).called(1);
    });

    group('get', () {
      const path = '/test';
      final responseData = {'key': 'value'};
      final requestOptions = RequestOptions(path: path);
      final response = Response(
        requestOptions: requestOptions,
        data: responseData,
        statusCode: 200,
      );

      test('returns data on successful request', () async {
        // Arrange
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        final result = await httpClient.get<Map<String, dynamic>>(path);

        // Assert
        expect(result, responseData);
        verify(
          () => mockDio.get<Map<String, dynamic>>(
            path,
            queryParameters: null,
            options: null,
            cancelToken: null,
          ),
        ).called(1);
        verify(
          () => mockLogger.info('GET request to $path successful. Status: 200'),
        ).called(1);
      });

      test(
        'throws HttpException when dio throws DioException with HttpException',
        () async {
          // Arrange
          final exception = UnauthorizedException('Invalid token');
          when(
            () => mockDio.get<dynamic>(
              any(),
              queryParameters: any(named: 'queryParameters'),
              options: any(named: 'options'),
              cancelToken: any(named: 'cancelToken'),
            ),
          ).thenThrow(
            DioException(requestOptions: requestOptions, error: exception),
          );

          // Act & Assert
          expect(
            () => httpClient.get<Map<String, dynamic>>(path),
            throwsA(isA<UnauthorizedException>()),
          );
          verify(
            () => mockLogger.severe(
              'GET request to $path failed with HttpException: $exception',
            ),
          ).called(1);
        },
      );

      test('rethrows DioException for other errors', () async {
        // Arrange
        final exception = DioException(
          requestOptions: requestOptions,
          error: 'Some error',
        );
        when(
          () => mockDio.get<dynamic>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenThrow(exception);

        // Act & Assert
        expect(
          () => httpClient.get<Map<String, dynamic>>(path),
          throwsA(isA<DioException>()),
        );
        verify(
          () => mockLogger.severe(
            'GET request to $path failed with DioException: $exception',
          ),
        ).called(1);
      });
    });

    // Similar test groups for post, put, delete
    group('post', () {
      const path = '/test';
      final requestData = {'name': 'test'};
      final responseData = {'id': '1', 'name': 'test'};
      final requestOptions = RequestOptions(path: path);
      final response = Response(
        requestOptions: requestOptions,
        data: responseData,
        statusCode: 201,
      );

      test('returns data on successful request', () async {
        // Arrange
        when(
          () => mockDio.post<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        final result = await httpClient.post<Map<String, dynamic>>(
          path,
          data: requestData,
        );

        // Assert
        expect(result, responseData);
        verify(
          () => mockDio.post<Map<String, dynamic>>(
            path,
            data: requestData,
            queryParameters: null,
            options: null,
            cancelToken: null,
          ),
        ).called(1);
      });
    });

    group('put', () {
      const path = '/test/1';
      final requestData = {'name': 'updated'};
      final responseData = {'id': '1', 'name': 'updated'};
      final requestOptions = RequestOptions(path: path);
      final response = Response(
        requestOptions: requestOptions,
        data: responseData,
        statusCode: 200,
      );

      test('returns data on successful request', () async {
        // Arrange
        when(
          () => mockDio.put<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => response);

        // Act
        final result = await httpClient.put<Map<String, dynamic>>(
          path,
          data: requestData,
        );

        // Assert
        expect(result, responseData);
        verify(
          () => mockDio.put<Map<String, dynamic>>(
            path,
            data: requestData,
            queryParameters: null,
            options: null,
            cancelToken: null,
          ),
        ).called(1);
      });
    });

    group('delete', () {
      const path = '/test/1';
      final requestOptions = RequestOptions(path: path);
      final response = Response(
        requestOptions: requestOptions,
        data: null,
        statusCode: 204,
      );

      test('completes on successful request', () async {
        // Arrange
        when(
          () => mockDio.delete<dynamic>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
            cancelToken: any(named: 'cancelToken'),
          ),
        ).thenAnswer((_) async => response);

        // Act & Assert
        await expectLater(httpClient.delete<void>(path), completes);
        verify(
          () => mockDio.delete<void>(
            path,
            data: null,
            queryParameters: null,
            options: null,
            cancelToken: null,
          ),
        ).called(1);
      });
    });
  });
}
