import 'dart:convert';

/// Represents an API failure.
///
/// This class is used to encapsulate the details of an API failure, including an error code and a description of the error.
///
/// **Properties**:
/// - [String] `code`: A string representing the error code associated with the failure. This code can be used to identify the type of error that occurred.
/// - [String] `description`: A string providing a description of the failure. This message typically contains information about why the failure occurred or additional details for debugging.
///
/// **Constructor**:
/// - `ApiFailure({required this.code, required this.description})`: Initializes an instance of [ApiFailure] with the provided error code and description.
///
/// **Notes**:
/// - This class is commonly used in error handling within API responses. The `code` and `description` fields can be used to provide detailed information about errors and to handle different types of failures appropriately.
///
/// **Example**:
/// ```dart
/// ApiFailure failure = ApiFailure(
///   code: '404',
///   description: 'Resource not found',
/// );
/// print('Error Code: ${failure.code}');
/// print('Error Description: ${failure.description}');
/// ```
class ApiFailure {
  ApiFailure({
    this.status = '',
    this.code = 0,
    this.description = '',
    this.message = '',
  });

  final int code;
  final String status;
  final String description;
  final String message;

  factory ApiFailure.fromJson(String str) =>
      ApiFailure.fromMap(json.decode(str));

  factory ApiFailure.fromMap(Map<String, dynamic> json) => ApiFailure(
    code: json["code"] ?? 0,
    status: json["status"] ?? '',
    message: json["message"] ?? '',
    description: json["description"] ?? '',
  );
}
