/// A generic class for representing the result of an API operation.
///
/// The `ARoResult` class is a generic wrapper that holds the outcome of an API
/// operation. It can represent either a successful result or a failure. This
/// class helps in managing and handling responses from API calls more effectively
/// by providing a unified way to handle both success and failure cases.
///
/// **Generic Type Parameters**:
/// - `Failure`: The type of the failure result, if the operation fails.
/// - `Success`: The type of the success result, if the operation succeeds.
///
/// **Properties**:
/// - `failure`: An instance of `Failure` representing the error result, or `null` if the operation was successful.
/// - `success`: An instance of `Success` representing the successful result, or `null` if the operation failed.
/// - `isFailure`: A boolean indicating whether the result represents a failure (`true`) or a success (`false`).
///
/// **Factory Constructors**:
/// - `ARoResult.failure(Failure failure)`
///    Creates an `ARoResult` instance representing a failure.
///
/// - `ARoResult.success(Success success)`
///    Creates an `ARoResult` instance representing a success.
///
/// **Methods**:
/// - `when<T>(T Function(Failure) failure, T Function(Success) success)`
///    Executes the appropriate function based on whether the result is a failure or a success.
///
///   - `failure`: A function to handle the failure case, taking a `Failure` parameter and returning a value of type `T`.
///
///   - `success`: A function to handle the success case, taking a `Success` parameter and returning a value of type `T`.
///
///   - Returns the result of the function that matches the current state (`failure` or `success`).
///
/// **Example**:
/// ```dart
///     ARoResult<String, int> result = ARoResult.success(42);
///
///     result.when(
///       (failure) => print('Failure: $failure'),
///       (success) => print('Success: $success'),
///     ); // Output: Success: 42
///
///     ARoResult<String, int> errorResult = ARoResult.failure('An error occurred');
///
///     errorResult.when(
///       (failure) => print('Failure: $failure'),
///       (success) => print('Success: $success'),
///     ); // Output: Failure: An error occurred
/// ```
class ARoResult<Failure, Success> {
  ARoResult._(this.failure, this.success, this.isFailure);

  final Failure? failure;
  final Success? success;
  final bool isFailure;

  factory ARoResult.failure(Failure failure) {
    /// Creates an `ARoResult` instance representing a failure.
    ///
    /// This factory constructor initializes an `ARoResult` with the provided
    /// failure value and sets `isFailure` to `true`.
    return ARoResult._(failure, null, true);
  }

  factory ARoResult.success(Success success) {
    /// Creates an `ARoResult` instance representing a success.
    ///
    /// This factory constructor initializes an `ARoResult` with the provided
    /// success value and sets `isFailure` to `false`.
    return ARoResult._(null, success, false);
  }

  T when<T>(T Function(Failure) failure, T Function(Success) success) {
    /// Executes the appropriate function based on whether the result is a failure or a success.
    ///
    /// - `failure`: A function to handle the failure case, taking a `Failure` parameter and returning a value of type `T`.
    /// - `success`: A function to handle the success case, taking a `Success` parameter and returning a value of type `T`.
    ///
    /// Returns the result of the function that matches the current state (`failure` or `success`).
    if (isFailure) {
      return failure(this.failure as Failure);
    } else {
      return success(this.success as Success);
    }
  }
}
