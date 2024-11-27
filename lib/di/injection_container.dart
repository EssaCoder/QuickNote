import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_note/local/preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'injection_container.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError();

@Riverpod(keepAlive: true)
Preferences preferences(PreferencesRef ref) =>
    Preferences(ref.read(sharedPreferencesProvider));

