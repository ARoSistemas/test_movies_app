import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/core/errors/dts_http_failure.dart';

void main() {
  test('constructor por defecto', () {
    final failure = ApiFailure();
    expect(failure.code, 0);
    expect(failure.status, '');
    expect(failure.description, '');
    expect(failure.message, '');
  });

  test('constructor con valores', () {
    final failure = ApiFailure(
      code: 404,
      status: 'error',
      description: 'No encontrado',
      message: 'Recurso no disponible',
    );
    expect(failure.code, 404);
    expect(failure.status, 'error');
    expect(failure.description, 'No encontrado');
    expect(failure.message, 'Recurso no disponible');
  });

  test('fromJson parsea correctamente', () {
    final jsonStr =
        '{"code":401,"status":"fail","description":"No autorizado","message":"Token inválido"}';
    final failure = ApiFailure.fromJson(jsonStr);
    expect(failure.code, 401);
    expect(failure.status, 'fail');
    expect(failure.description, 'No autorizado');
    expect(failure.message, 'Token inválido');
  });

  test('fromMap parsea correctamente con valores faltantes', () {
    final map = {"code": 500};
    final failure = ApiFailure.fromMap(map);
    expect(failure.code, 500);
    expect(failure.status, '');
    expect(failure.description, '');
    expect(failure.message, '');
  });
}
