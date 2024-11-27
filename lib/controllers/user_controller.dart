import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:quick_note/di/injection_container.dart';
import 'package:quick_note/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  @override
  User? build() => _getUser();

  void refresh() => state = _getUser();

  User? _getUser() {
    final preferences = ref.read(preferencesProvider);
    final userDataString = preferences.get('user');
    if (userDataString == null) return null;
    final userData = jsonDecode(userDataString.toString());
    final user = User.fromMap(userData);
    return user;
  }


  set user(User? user) {
    state = user;
  }

  Future<void> logout() async {
    final _preferences = ref.read(preferencesProvider);
    if (state == null) {
      return;
    }
    user = null;
    await _preferences.clear();
    PaintingBinding.instance.imageCache.clear();
  }

  User? getUserData() {
    try {
      final _preferences = ref.read(preferencesProvider);
      final userDataString = _preferences.get('user');
      if (userDataString == null) return null;
      final userData = jsonDecode(_preferences.get('user').toString());
      final user = User.fromMap(userData);
      return user;
    } catch (e) {
      return null;
    }
  }
}
