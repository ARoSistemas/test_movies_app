/// The `HttpMethod` enum defines various HTTP methods for API requests.
///
/// **Values:**
/// - `get`: Represents an HTTP GET request.
/// - `post`: Represents an HTTP POST request.
/// - `put`: Represents an HTTP PUT request.
/// - `patch`: Represents an HTTP PATCH request.
/// - `delete`: Represents an HTTP DELETE request.
/// - `other`: Represents any other HTTP method.
enum HttpMethod { get, post, put, patch, delete, other }

/// The `PlatformOs` enum defines various operating systems supported by the application.
///
/// **Values:**
/// - `android`: Represents the Android operating system.
/// - `iOS`: Represents the iOS operating system.
/// - `web`: Represents web platforms.
enum PlatformOs {
  android('Android'),
  iOS('iOS'),
  web('Web');

  const PlatformOs(this.name);

  /// The name of the operating system.
  final String name;
}

/// The `TransitionType` enum defines various transition effects that can be applied
/// to page transitions in a Flutter application.
///
/// **Values:**
/// - `defaultTransition`: Default transition, usually a fade.
/// - `none`: No transition.
/// - `size`: Transition that changes the size of the page.
/// - `scale`: Transition that scales the page.
/// - `fade`: Transition that fades the page in and out.
/// - `rotate`: Transition that rotates the page.
/// - `slideDown`: Transition that slides the page down from the top.
/// - `slideUp`: Transition that slides the page up from the bottom.
/// - `slideLeft`: Transition that slides the page left from the right.
/// - `slideRight`: Transition that slides the page right from the left.
enum TransitionType {
  defaultTransition,
  none,
  size,
  scale,
  fade,
  rotate,
  slideDown,
  slideUp,
  slideLeft,
  slideRight,
}
