import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/core/network/api_response.dart';

void main() {
  test('constructor y propiedades', () {
    final response = ApiResponse<String>(
      statusCode: 200,
      headers: {'Content-Type': 'application/json'},
      body: 'ok',
      exception: '',
      isSuccess: true,
    );
    expect(response.statusCode, 200);
    expect(response.headers, {'Content-Type': 'application/json'});
    expect(response.body, 'ok');
    expect(response.exception, '');
    expect(response.isSuccess, true);
  });

  test('copyWith actualiza los valores correctamente', () {
    final response = ApiResponse<String>(
      statusCode: 200,
      headers: {'Content-Type': 'application/json'},
      body: 'ok',
      exception: '',
      isSuccess: true,
    );
    final updated = response.copyWith(
      body: 'nuevo',
      headers: {'Content-Type': 'text/plain'},
      statusCode: 404,
      exception: 'error',
      isSuccess: false,
    );
    expect(updated.statusCode, 404);
    expect(updated.headers, {'Content-Type': 'text/plain'});
    expect(updated.body, 'nuevo');
    expect(updated.exception, 'error');
    expect(updated.isSuccess, false);
  });

  test('copyWith mantiene valores originales si no se pasan argumentos', () {
    final response = ApiResponse<String>(
      statusCode: 200,
      headers: {'Content-Type': 'application/json'},
      body: 'ok',
      exception: '',
      isSuccess: true,
    );
    final updated = response.copyWith();
    expect(updated.statusCode, 200);
    expect(updated.headers, {'Content-Type': 'application/json'});
    expect(updated.body, 'ok');
    expect(updated.exception, '');
    expect(updated.isSuccess, true);
  });
}
