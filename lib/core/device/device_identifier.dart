import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

/// Provides one stable, anonymous identifier for this app installation.
class DeviceIdentifier {
  DeviceIdentifier._();

  static const _storageKey = 'helpfundus_device_id';

  static Future<String> getOrCreate() async {
    final preferences = await SharedPreferences.getInstance();
    final existing = preferences.getString(_storageKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final entropy = List.generate(
      24,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
    final identifier = 'hf-$entropy';
    await preferences.setString(_storageKey, identifier);
    return identifier;
  }
}
  