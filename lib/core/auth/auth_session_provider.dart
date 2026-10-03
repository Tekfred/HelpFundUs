import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication tokens for the active app session. Tokens intentionally
/// remain in memory until a refresh-token persistence policy is introduced.
final authSessionProvider =
    NotifierProvider<AuthSessionNotifier, AuthSessionState>(
      AuthSessionNotifier.new,
    );

class AuthSessionState {
  const AuthSessionState({this.accessToken, this.refreshToken});

  final String? accessToken;
  final String? refreshToken;

  bool get isAuthenticated => accessToken?.isNotEmpty == true;
}

class AuthSessionNotifier extends Notifier<AuthSessionState> {
  @override
  AuthSessionState build() => const AuthSessionState();

  void establish({required String accessToken, String? refreshToken}) {
    state = AuthSessionState(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  void clear() => state = const AuthSessionState();
}
