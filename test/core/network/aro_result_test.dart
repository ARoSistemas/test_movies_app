import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/core/network/aro_result.dart';

void main() {
  test('ARoResult.success crea resultado exitoso', () {
    final result = ARoResult.success('ok');
    expect(result.isFailure, false);
    expect(result.success, 'ok');
    expect(result.failure, isNull);
  });

  test('ARoResult.failure crea resultado de error', () {
    final result = ARoResult.failure('error');
    expect(result.isFailure, true);
    expect(result.failure, 'error');
    expect(result.success, isNull);
  });

  test('when ejecuta función de éxito', () {
    final result = ARoResult.success(42);
    final output = result.when(
      (fail) => 'fail: $fail',
      (succ) => 'success: $succ',
    );
    expect(output, 'success: 42');
  });

  test('when ejecuta función de error', () {
    final result = ARoResult.failure('fail');
    final output = result.when(
      (fail) => 'fail: $fail',
      (succ) => 'success: $succ',
    );
    expect(output, 'fail: fail');
  });
}
