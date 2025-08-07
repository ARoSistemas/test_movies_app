import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' show Client;
import 'package:flutter/services.dart' show SystemChrome, DeviceOrientation;

import 'core/network/dts_api_call.dart';
import 'app/config/constans/app_env.dart';
import 'app/config/themes/app_theme.dart';

import 'app/data/repositories/impl_api_conn.dart';
import 'app/data/datasources/local/dts_user_pref.dart';
import 'app/data/datasources/local/favorites_service.dart';

import 'app/domain/repositories/repository_api_conn.dart';

import 'app/presentation/providers/movies_provider.dart';
import 'app/presentation/providers/favorites_provider.dart';
import 'app/presentation/pages/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables
  // await dotenv.load(fileName: "assets/.env");

  /// Configurar orientación preferida
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Initialize user preferences
  UserPref userPrefs = UserPref();
  await userPrefs.initPrefs();

  /// Initialize favorites service
  FavoritesService favoritesService = FavoritesService(userPrefs);

  Client client = Client();
  ApiCall apiCall = ApiCall(client, env, userPrefs);

  ApiConnRepository apiConnRepository = APIConnImpl(apiCall);

  runApp(
    MyApp(
      apiConnRepository: apiConnRepository,
      favoritesService: favoritesService,
    ),
  );
}

/// The main application widget that initializes the app with providers and themes.
///
/// This widget serves as the root of the application and configures:
/// - Multi-provider setup for state management
/// - Material Design theme
/// - Initial routing to the main navigation page
///
/// ### Parameters
/// - [apiConnRepository]: Repository for API connections
/// - [favoritesService]: Service for managing favorite movies
///
/// ### Usage
/// ```dart
/// MyApp(
///   apiConnRepository: apiConnRepository,
///   favoritesService: favoritesService,
/// )
/// ```
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.apiConnRepository,
    required this.favoritesService,
  });

  final ApiConnRepository apiConnRepository;
  final FavoritesService favoritesService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiConnRepository>(create: (_) => apiConnRepository),
        Provider<FavoritesService>(create: (_) => favoritesService),
        ChangeNotifierProvider<MoviesProvider>(
          create: (context) =>
              MoviesProvider(context.read<ApiConnRepository>()),
        ),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (context) =>
              FavoritesProvider(context.read<FavoritesService>()),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ARo Movies App',
        theme: AppTheme.lightTheme,
        home: const MainNavigationPage(),
      ),
    );
  }
}
