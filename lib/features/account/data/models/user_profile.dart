/// The user details returned by the authenticated profile endpoint.
class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.userId,
    this.avatarUrl,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String? userId;
  final String? avatarUrl;

  String get displayName => [
    firstName,
    lastName,
  ].where((name) => name.trim().isNotEmpty).join(' ').trim();

  String get initials => displayName
      .split(RegExp(r'\s+'))
      .where((name) => name.isNotEmpty)
      .take(2)
      .map((name) => name[0].toUpperCase())
      .join();

  factory UserProfile.fromJson(Object? responseData) {
    final data = _profileMap(responseData);
    final firstName = _string(data, const ['firstName', 'first_name']);
    final lastName = _string(data, const ['lastName', 'last_name']);
    final fullName = _string(data, const ['name', 'fullName', 'displayName']);
    final nameParts = fullName?.split(RegExp(r'\s+')) ?? const <String>[];

    return UserProfile(
      firstName: firstName ?? (nameParts.isNotEmpty ? nameParts.first : ''),
      lastName:
          lastName ?? (nameParts.length > 1 ? nameParts.skip(1).join(' ') : ''),
      email: _string(data, const ['email']) ?? '',
      userId: _string(data, const ['userId', 'id']),
      avatarUrl: _string(data, const [
        'profilePhotoUrl',
        'avatarUrl',
        'profileImageUrl',
        'photoUrl',
      ]),
    );
  }

  static Map _profileMap(Object? value) {
    if (value is! Map) return const <Object?, Object?>{};
    for (final key in const ['data', 'profile', 'user', 'result']) {
      final nested = value[key];
      if (nested is Map) return _profileMap(nested);
    }
    return value;
  }

  static String? _string(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value.trim();
      if (value is num) return value.toString();
    }
    return null;
  }
}
