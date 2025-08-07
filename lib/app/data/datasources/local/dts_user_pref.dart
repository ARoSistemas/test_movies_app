import 'package:shared_preferences/shared_preferences.dart';

/// Singleton class for managing user preferences using `SharedPreferences`.
///
/// The [UserPref] class provides convenient getters and setters to access and
/// modify user-specific settings, such as environment, favorites, and HTTP responses.
/// It uses `SharedPreferences` to persist data locally across app sessions.
///
/// ### Singleton Pattern
/// - Only one instance of [UserPref] exists throughout the application.
/// - Use `UserPref()` to access the singleton instance.
///
/// ### Initialization
/// - Call [initPrefs] before accessing any preferences to initialize the underlying storage.
///
/// ### Getters & Setters
/// - [resHttp]: Gets or sets the list of HTTP responses as strings.
/// - [environment]: Gets or sets the current environment (default: 'dev').
/// - [favorites]: Gets or sets the list of favorite items as strings.
///
/// ### Example
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   final userPrefs = UserPref();
///   await userPrefs.initPrefs();
///
///   userPrefs.environment = 'production';
///   print(userPrefs.environment); // Output: production
///
///   userPrefs.favorites = ['item1', 'item2'];
///   print(userPrefs.favorites); // Output: [item1, item2]
///
///   userPrefs.resHttp = ['response1', 'response2'];
///   print(userPrefs.resHttp); // Output: [response1, response2]
/// }
/// ```
class UserPref {
  /// Private constructor to prevent instantiation from outside (singleton).
  UserPref._internal();

  /// Singleton instance of [UserPref].
  static final _instancia = UserPref._internal();

  /// Returns the singleton instance of [UserPref].
  factory UserPref() => _instancia;

  /// Underlying [SharedPreferences] instance.
  late SharedPreferences _userPref;

  /// Initializes the shared preferences instance.
  ///
  /// Must be called before accessing any preferences.
  Future<void> initPrefs() async {
    _userPref = await SharedPreferences.getInstance();
  }

  /// Gets the list of HTTP responses stored as strings.
  List<String> get resHttp => _userPref.getStringList('resHttp') ?? [];

  /// Sets the list of HTTP responses.
  set resHttp(List<String> value) => _userPref.setStringList('resHttp', value);

  /// Gets the current environment setting (default: 'dev').
  String get environment => _userPref.getString('environment') ?? 'dev';

  /// Sets the current environment.
  set environment(String value) => _userPref.setString('environment', value);

  /// Gets the list of favorite items stored as strings.
  List<String> get favorites => _userPref.getStringList('favorites') ?? [];

  /// Sets the list of favorite items.
  set favorites(List<String> value) =>
      _userPref.setStringList('favorites', value);
}
