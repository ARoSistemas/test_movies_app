import 'dart:convert';

/// Represents a successful API response.
///
/// The [ApiSuccess] class encapsulates the data of a successful response, including the HTTP status code and the returned data.
///
/// ### Properties
/// - [code]: HTTP status code of the response.
/// - [data]: Data returned by the API (usually JSON or plain text).
///
/// ### Constructors
/// - [ApiSuccess]: Creates an instance with the provided values.
/// - [ApiSuccess.fromJson]: Creates an instance from a JSON string.
/// - [ApiSuccess.fromMap]: Creates an instance from a Map.
/// - [ApiSuccess.empty]: Creates an empty instance (code=0, data='').
///
/// ### Methods
/// - [copyWith]: Returns a copy of the instance with modified values.
///
/// ### Example
/// ```dart
/// final success = ApiSuccess(code: 200, data: '{"result":true}');
/// print(success.code); // 200
/// print(success.data); // '{"result":true}'
/// ```
class ApiSuccess {
  /// HTTP status code of the response.
  final int code;

  /// Data returned by the API (usually JSON or plain text).
  final String data;

  /// Main constructor.
  ///
  /// [code]: HTTP status code.
  /// [data]: Data returned by the API.
  ApiSuccess({required this.code, required this.data});

  /// Returns a copy of the instance with modified values.
  ///
  /// [code]: New status code (optional).
  /// [data]: New data (optional).
  /// [message]: Not used, only for compatibility.
  ApiSuccess copyWith({int? code, String? data, String? message}) =>
      ApiSuccess(code: code ?? this.code, data: data ?? this.data);

  /// Creates an instance from a JSON string.
  ///
  /// [str]: JSON string representing the response.
  factory ApiSuccess.fromJson(String str) =>
      ApiSuccess.fromMap(json.decode(str));

  /// Creates an instance from a Map.
  ///
  /// [json]: Map with the response data.
  factory ApiSuccess.fromMap(Map<String, dynamic> json) =>
      ApiSuccess(code: json["code"] ?? 0, data: json["data"] ?? '');

  /// Creates an empty instance (code=0, data='').
  factory ApiSuccess.empty() => ApiSuccess(code: 0, data: '');
}
