/// Represents a generic API response.
///
/// The [ApiResponse] class encapsulates the details of an HTTP response, including status code, headers, body, exception message, and success indicator.
///
/// ### Type Parameters
/// - [T]: The type of the response body.
///
/// ### Properties
/// - [statusCode]: HTTP status code of the response.
/// - [headers]: HTTP headers returned by the server.
/// - [body]: The response body of type [T].
/// - [exception]: Exception message if an error occurred.
/// - [isSuccess]: Indicates whether the response is successful.
///
/// ### Constructors
/// - [ApiResponse]: Creates an instance with the provided values.
///
/// ### Methods
/// - [copyWith]: Returns a copy of the instance with modified values.
///
/// ### Example
/// ```dart
/// final response = ApiResponse<String>(
///   statusCode: 200,
///   headers: {'Content-Type': 'application/json'},
///   body: '{"result":true}',
///   exception: '',
///   isSuccess: true,
/// );
/// print(response.statusCode); // 200
/// print(response.body); // '{"result":true}'
/// ```
class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.exception,
    required this.isSuccess,
  });

  /// HTTP status code of the response.
  final int statusCode;

  /// HTTP headers returned by the server.
  final Map<String, String> headers;

  /// The response body of type [T].
  final T body;

  /// Exception message if an error occurred.
  final String exception;

  /// Indicates whether the response is successful.
  final bool isSuccess;

  /// Returns a copy of the instance with modified values.
  ///
  /// [body]: New response body (optional).
  /// [headers]: New headers (optional).
  /// [statusCode]: New status code (optional).
  /// [exception]: New exception message (optional).
  /// [isSuccess]: New success indicator (optional).
  ApiResponse copyWith({
    dynamic body,
    Map<String, String>? headers,
    int? statusCode,
    String? exception,
    bool? isSuccess,
  }) {
    return ApiResponse(
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      exception: exception ?? this.exception,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
