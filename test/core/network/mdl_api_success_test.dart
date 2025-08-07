import 'package:flutter_test/flutter_test.dart';
import 'package:aro_movies_app/core/network/mdl_api_success.dart';

void main() {
  test('constructor y propiedades', () {
    final success = ApiSuccess(code: 200, data: 'ok');
    expect(success.code, 200);
    expect(success.data, 'ok');
  });

  test('copyWith actualiza los valores', () {
    final success = ApiSuccess(code: 200, data: 'ok');
    final updated = success.copyWith(code: 404, data: 'nuevo');
    expect(updated.code, 404);
    expect(updated.data, 'nuevo');
  });

  test('copyWith actualiza solo code', () {
    final success = ApiSuccess(code: 200, data: 'ok');
    final updated = success.copyWith(code: 404);
    expect(updated.code, 404);
    expect(updated.data, 'ok');
  });

  test('copyWith actualiza solo data', () {
    final success = ApiSuccess(code: 200, data: 'ok');
    final updated = success.copyWith(data: 'nuevo');
    expect(updated.code, 200);
    expect(updated.data, 'nuevo');
  });

  test('fromJson parsea correctamente', () {
    final jsonStr = '{"code":201,"data":"creado"}';
    final success = ApiSuccess.fromJson(jsonStr);
    expect(success.code, 201);
    expect(success.data, 'creado');
  });

  test('fromMap parsea correctamente con valores faltantes', () {
    final map = {"code": 500};
    final success = ApiSuccess.fromMap(map);
    expect(success.code, 500);
    expect(success.data, '');
  });

  test('empty retorna instancia vacía', () {
    final empty = ApiSuccess.empty();
    expect(empty.code, 0);
    expect(empty.data, '');
  });
}
