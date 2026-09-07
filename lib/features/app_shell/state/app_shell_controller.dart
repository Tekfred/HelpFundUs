// name=lib/features/app_shell/state/app_shell_controller.dart
import 'package:flutter/foundation.dart';

/// The active experience of an account that can both donate and fundraise.
enum ShellRole { donor, fundraiser }

/// UI-focused authenticated session state. This is deliberately independent
/// of the shell widgets so API-backed account state can replace it later.
class AppShellController extends ChangeNotifier {
  AppShellController({
    ShellRole startRole = ShellRole.donor,
    int startTab = 0,
    bool startOnline = true,
    int startUnreadActivity = 1,
    int startUnreadInbox = 3,
  }) : _role = startRole,
       _tabIndex = startTab.clamp(0, 4),
       _online = startOnline,
       _unreadActivity = startUnreadActivity,
       _unreadInbox = startUnreadInbox;

  ShellRole _role;
  int _tabIndex;
  bool _online;
  int _unreadActivity;
  int _unreadInbox;

  ShellRole get role => _role;
  int get tabIndex => _tabIndex;
  bool get online => _online;
  int get unreadActivity => _unreadActivity;
  int get unreadInbox => _unreadInbox;

  List<String> get tabLabels => _role == ShellRole.donor
      ? const ['Home', 'Explore', 'Activity', 'Inbox', 'Account']
      : const ['Home', 'Campaigns', 'Activity', 'Inbox', 'Account'];

  String get routePath {
    final segment = switch (tabIndex) {
      0 => 'home',
      1 => role == ShellRole.donor ? 'explore' : 'campaigns',
      2 => 'activity',
      3 => 'inbox',
      _ => 'account',
    };
    return '/app-shell/$segment';
  }

  void setRole(ShellRole r) {
    if (_role == r) return;
    _role = r;
    notifyListeners();
  }

  void setTab(int i) {
    if (i < 0 || i > 4) return;
    final changed = _tabIndex != i;
    _tabIndex = i;
    // per spec: opening Activity/Inbox clears their unread counters immediately
    if (tabLabels[i] == 'Activity') _unreadActivity = 0;
    if (tabLabels[i] == 'Inbox') _unreadInbox = 0;
    if (changed) notifyListeners();
  }

  void setOnline(bool v) {
    if (_online == v) return;
    _online = v;
    notifyListeners();
  }

  void setUnreadActivity(int v) {
    _unreadActivity = v;
    notifyListeners();
  }

  void setUnreadInbox(int v) {
    _unreadInbox = v;
    notifyListeners();
  }

  /// Handles authenticated links including `/explore`, `/campaigns`, and the
  /// shared Activity, Inbox, and Account destinations.
  bool handleDeepLink(Uri uri) {
    final segment = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
    final index = switch (segment) {
      'home' => 0,
      'explore' || 'campaigns' => 1,
      'activity' => 2,
      'inbox' => 3,
      'account' => 4,
      _ => -1,
    };
    if (index < 0) return false;
    if (segment == 'campaigns') _role = ShellRole.fundraiser;
    if (segment == 'explore') _role = ShellRole.donor;
    _tabIndex = index;
    notifyListeners();
    return true;
  }
}
