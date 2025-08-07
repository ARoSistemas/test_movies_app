import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';
import 'package:flutter/foundation.dart';

import 'aro_result.dart';
import 'mdl_api_success.dart';

import '../errors/dts_http_failure.dart';

import '../../app/config/constans/app_env.dart';
import '../../app/config/constans/app_enums.dart';
import '../../app/data/datasources/local/dts_user_pref.dart';

/// A service class for handling API requests with enhanced logging and error handling.
///
/// The `ApiCall` class facilitates communication with external APIs by wrapping
/// HTTP requests with configurable parameters, timeout settings, and structured
/// logging. It supports both GET and POST methods and can attach authorization headers.
///
/// ## Example
///
/// ```dart
/// void main() async {
///   final client = Client();
///   final env = 'https://api.example.com';
///   final userPrefs = UserPref();
///   await userPrefs.initPrefs();
///
///   final apiService = ApiCall(client, env, userPrefs);
///   final result = await apiService.request(
///     endpoint: '/login',
///     bearer: 'your-auth-token',
///     body: jsonEncode({'username': 'user', 'password': 'pass'}),
///   );
///
///   result.when(
///     success: (data) => print('Success: ${data.data}'),
///     failure: (error) => print('Error: ${error.message}'),
///   );
/// }
/// ```
///
/// ## Properties
///
/// - `_client` (`Client`): The HTTP client used for making API requests.
/// - `_env` (`String`): The base URL or environment for API endpoints.
/// - `_userPrefs` (`UserPref`): Instance of `UserPref` for storing request logs.
///
/// ### `Future<ApiWrapper<ApiFailure, ApiSuccess>> request({...})`
/// Makes an API request with the provided parameters.
///
/// #### Parameters:
/// - `body` (`String`): The request body in JSON format.
/// - `bearer` (`String`): Bearer token for authorization (optional).
/// - `endpoint` (`String`): The endpoint to append to the base URL.
/// - `epName` (`String`): An optional identifier for the endpoint (default: `-|`).
/// - `method` (`HttpMethod`): The HTTP method, defaulting to POST.
/// - `headers` (`Map<String, String>`): Additional headers (default: content type JSON).
/// - `queryParameters` (`Map<String, String>`): Query parameters (default: empty).
/// - `tkMovil` (`String`): Mobile token (optional).
///
/// #### Returns:
/// - `ApiWrapper.success`: Contains `ApiSuccess` with the status code and response data.
/// - `ApiWrapper.failure`: Contains `ApiFailure` with the error code and message.
///
/// #### Example:
/// ```dart
/// final response = await apiService.request(
///   endpoint: '/user/profile',
///   bearer: 'auth-token',
///   method: HttpMethod.get,
/// );
///
/// response.when(
///   success: (success) {
///     print('Response data: ${success.data}');
///   },
///   failure: (failure) {
///     print('Error: ${failure.message}');
///   },
/// );
/// ```
class ApiCall {
  ApiCall(this._client, this._env, this._userPrefs);

  final Client _client;
  final String _env;
  final UserPref _userPrefs;

  Future<ARoResult<ApiFailure, ApiSuccess>> request({
    required String endpoint,
    required String body,
    String epName = '-|',
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'charset': 'UTF-8',
    },
    Map<String, String> queryParameters = const {},
  }) async {
    /// Makes an HTTP request to the specified endpoint with configurable options.
    ///
    /// Handles logging, timeout, error handling, and response decoding. The result
    /// is returned as an `ApiWrapper`, which is a wrapper for success and failure states.

    const timeout = Duration(seconds: 15);

    String uri = getBaseUri(_env, endpoint);
    DateTime startTime = DateTime.now();
    String resApiWithChartSet = '';
    Map<String, dynamic> logs = {'startTime': startTime.toString()};
    StackTrace? stackTrace;

    Response petitionResponse = Response('', 200);

    try {
      Uri url = Uri.parse(uri);
      logs = {'url': '$url'};

      if (queryParameters.isNotEmpty) {
        url = url.replace(queryParameters: queryParameters);
      }

      logs = {...logs, 'queryParameters': queryParameters};

      headers = {...headers, 'Authorization': 'Bearer $apiKey'};

      logs = {...logs, 'headers': headers};

      switch (method) {
        case HttpMethod.get:
          petitionResponse = await _client
              .get(url, headers: headers)
              .timeout(timeout);
          break;

        case HttpMethod.post:
          petitionResponse = await _client
              .post(url, headers: headers, body: body)
              .timeout(timeout);
          break;

        default:
          petitionResponse = await _client
              .get(url, headers: headers)
              .timeout(timeout);
          break;
      }

      logs = {
        ...logs,
        'body': (body == 'mock') ? body : jsonDecode(body),
        'Response::':
            '**************************************************************',
        'Response code:': petitionResponse.statusCode,
      };

      /// Change charSet UTF-8
      resApiWithChartSet = utf8.decode(petitionResponse.bodyBytes);

      logs = {...logs, 'Response body': jsonDecode(resApiWithChartSet)};

      if (petitionResponse.statusCode == 200) {
        //. Success root request
        return ARoResult.success(
          ApiSuccess(
            code: petitionResponse.statusCode,
            data: resApiWithChartSet,
          ),
        );
      } else {
        //. Failure root request
        ApiFailure resFailure = ApiFailure.fromJson(resApiWithChartSet);
        return ARoResult.failure(
          ApiFailure(
            code: petitionResponse.statusCode,
            message: resFailure.message,
          ),
        );
      }
    } catch (e, s) {
      stackTrace = s;
      logs = {...logs, 'error': e.toString()};

      if (e is ClientException || e.toString().contains('SocketException')) {
        return ARoResult.failure(
          ApiFailure(code: petitionResponse.statusCode, message: e.toString()),
        );
      } else {
        return ARoResult.failure(
          ApiFailure(code: e.hashCode, message: e.toString()),
        );
      }

      ///
    } finally {
      DateTime endTime = DateTime.now();
      String timeElapsed = endTime.difference(startTime).toString();
      logs = {
        ...logs,
        'endTime': DateTime.now().toString(),
        'TimeElapsed': timeElapsed,
      };

      /// Only for purpose QA
      // coverage:ignore-start

      List<String> oldData = _userPrefs.resHttp;

      if (body != 'mock') {
        oldData.add(
          '$epName~$body~$resApiWithChartSet~${startTime.toString().substring(0, 22)} -> ${endTime.toString().substring(0, 22)}~$timeElapsed~$uri~$queryParameters~${jsonEncode(headers)}',
        );

        _userPrefs.resHttp = oldData;
      }
      // coverage:ignore-end

      ///  Delete this snippet when finish
      if (kDebugMode) {
        log('''
$epName

Endpoint ::-> $endpoint
Url :: -> $uri
--------------------------------------------------------------
  ${const JsonEncoder.withIndent(' ').convert(logs)}
--------------------------------------------------------------
''', stackTrace: stackTrace);
      }
    }

    ///
  }

  /// Returns the base URL for the API environment based on the specified kind.
  ///
  /// This method provides the base URL for different environments (development, QA, production).
  /// It returns the corresponding API URL based on the provided environment kind.
  ///
  /// ***Parameters***:
  /// - `env` (String):
  ///    The environment kind, which determines the base URL to return. It can be one of the following:
  ///
  ///   - `'dev'` for the development environment.
  ///   - `'qa'` for the QA environment.
  ///   - `'prod'` for the production environment.
  ///
  /// ***Returns***:
  /// - [String]: The base URL corresponding to the given environment kind.
  ///   If the kind is not recognized, an empty string is returned.
  ///
  /// ***Notes***:
  /// - The method uses a map to store the base URLs for different environments.
  ///   Ensure that the URLs are up-to-date with the correct endpoints for each environment.
  ///
  /// **Example**:
  /// ```dart
  /// final uri = getBaseUri(_env);
  ///
  /// print('Base URL for dev environment: $uri');
  /// ```
  String getBaseUri(String env, String ep) {
    Map<String, String> map = {
      'dev': 'https://api.themoviedb.org$ep',
      'qa': 'https://api.themoviedb.org$ep',
      'prod': 'https://api.themoviedb.org$ep',
    };

    return map[env] ?? 'https://api.themoviedb.org$ep';
  }
}
