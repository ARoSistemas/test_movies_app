import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aro_movies_app/app/data/datasources/local/favorites_service.dart';

export 'mocks.mocks.dart';

@GenerateMocks([http.Client, SharedPreferences, FavoritesService])
class MyMocks extends Mock {}
