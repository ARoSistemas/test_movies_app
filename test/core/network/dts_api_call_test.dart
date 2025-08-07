import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aro_movies_app/core/network/dts_api_call.dart';
import 'package:aro_movies_app/core/errors/dts_http_failure.dart';
import 'package:aro_movies_app/core/network/mdl_api_success.dart';

import 'package:aro_movies_app/app/config/constans/app_enums.dart';
import 'package:aro_movies_app/app/data/datasources/local/dts_user_pref.dart';

void main() {
  late UserPref userPref;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    userPref = UserPref();
    await userPref.initPrefs();
  });

  test('constructor ApiCall', () {
    final client = Client();
    final env = 'dev';
    final apiCall = ApiCall(client, env, userPref);
    expect(apiCall, isNotNull);
  });

  test('getBaseUri retorna la url correcta para dev', () {
    final client = Client();
    final env = 'dev';
    final apiCall = ApiCall(client, env, userPref);
    final uri = apiCall.getBaseUri('dev', '/test');
    expect(uri, 'https://api.themoviedb.org/test');
  });

  test('getBaseUri retorna la url correcta para qa', () {
    final client = Client();
    final env = 'qa';
    final apiCall = ApiCall(client, env, userPref);
    final uri = apiCall.getBaseUri('qa', '/test');
    expect(uri, 'https://api.themoviedb.org/test');
  });

  test('getBaseUri retorna la url correcta para prod', () {
    final client = Client();
    final env = 'prod';
    final apiCall = ApiCall(client, env, userPref);
    final uri = apiCall.getBaseUri('prod', '/test');
    expect(uri, 'https://api.themoviedb.org/test');
  });

  test('getBaseUri retorna la url por defecto si env no existe', () {
    final client = Client();
    final env = 'otro';
    final apiCall = ApiCall(client, env, userPref);
    final uri = apiCall.getBaseUri('otro', '/test');
    expect(uri, 'https://api.themoviedb.org/test');
  });

  test('request retorna success cuando status 200', () async {
    final mockClient = MockClient((request) async {
      return Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
    );
    expect(result.isFailure, false);
    expect(result.success, isA<ApiSuccess>());
    expect(result.success?.code, 200);
    expect(result.success?.data, contains('ok'));
  });

  test('request retorna failure cuando status != 200', () async {
    final mockClient = MockClient((request) async {
      return Response(jsonEncode({'code': 404, 'message': 'error'}), 404);
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
    );
    expect(result.isFailure, true);
    expect(result.failure, isA<ApiFailure>());
    expect(result.failure?.code, 404);
    expect(result.failure?.message, contains('error'));
  });

  test('request retorna failure en excepción de red', () async {
    final mockClient = MockClient((request) async {
      throw ClientException('Network error');
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
    );
    expect(result.isFailure, true);
    expect(result.failure, isA<ApiFailure>());
    expect(result.failure?.message, contains('Network error'));
  });

  test(
    'request retorna failure en excepción no ClientException ni SocketException',
    () async {
      final mockClient = MockClient((request) async {
        throw Exception('Otro error');
      });
      final apiCall = ApiCall(mockClient, 'dev', userPref);
      final result = await apiCall.request(
        endpoint: '/test',
        body: jsonEncode({'foo': 'bar'}),
      );
      expect(result.isFailure, true);
      expect(result.failure, isA<ApiFailure>());
      expect(result.failure?.message, contains('Otro error'));
      // El código debe ser el hashCode de la excepción
      expect(result.failure?.code, isA<int>());
    },
  );

  test('request usa queryParameters en la url', () async {
    final mockClient = MockClient((request) async {
      expect(request.url.queryParameters, containsPair('foo', 'bar'));
      return Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
      queryParameters: {'foo': 'bar'},
    );
    expect(result.isFailure, false);
    expect(result.success?.code, 200);
  });

  test('request usa método POST', () async {
    final mockClient = MockClient((request) async {
      expect(request.method, 'POST');
      return Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
      method: HttpMethod.post,
    );
    expect(result.isFailure, false);
    expect(result.success?.code, 200);
  });

  test('request usa método default (GET)', () async {
    final mockClient = MockClient((request) async {
      expect(request.method, 'GET');
      return Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    });
    final apiCall = ApiCall(mockClient, 'dev', userPref);
    final result = await apiCall.request(
      endpoint: '/test',
      body: jsonEncode({'foo': 'bar'}),
      method: HttpMethod.put,
    );
    expect(result.isFailure, false);
    expect(result.success?.code, 200);
  });
}
