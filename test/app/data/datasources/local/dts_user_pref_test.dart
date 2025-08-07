import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:aro_movies_app/app/data/datasources/local/dts_user_pref.dart';

void main() {
  late UserPref userPref;

  const resHttp = <String>[];
  const environment = '';
  const favorites = <String>[];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    userPref = UserPref();
    await userPref.initPrefs();
  });

  test('should get and set environment', () {
    userPref.environment = 'prod';
    expect(userPref.environment, 'prod');

    userPref.environment = 'qa';
    expect(userPref.environment, 'qa');
  });

  test('should get and set favorites', () {
    userPref.favorites = ['1', '2'];
    expect(userPref.favorites, ['1', '2']);

    userPref.favorites = ['3'];
    expect(userPref.favorites, ['3']);
  });

  group('Shared Preferences', () {
    test('Getters returns default value if not set yet', () {
      expect(userPref.resHttp, []);
      expect(userPref.environment, 'dev');
      expect(userPref.favorites, []);
    });

    test('Setter returns the set value previously setter', () {
      userPref.resHttp = resHttp;
      userPref.environment = environment;
      userPref.favorites = favorites;

      expect(userPref.resHttp, resHttp);
      expect(userPref.environment, environment);
      expect(userPref.favorites, favorites);
    });
  });

  test('should get and set resHttp', () {
    userPref.resHttp = ['a', 'b'];
    expect(userPref.resHttp, ['a', 'b']);

    userPref.resHttp = ['c'];
    expect(userPref.resHttp, ['c']);
  });
}
