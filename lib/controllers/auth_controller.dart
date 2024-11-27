import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_note/controllers/note_controller.dart';
import 'package:quick_note/controllers/user_controller.dart';
import 'package:quick_note/di/injection_container.dart';
import 'package:quick_note/models/login_request.dart';
import 'package:quick_note/models/register_request.dart';
import 'package:quick_note/models/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void build() {}

  Future<bool> login(LoginRequest request) async {
    try {
      // Query Firestore for the user by username
      final querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: request.username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("User not found");
      }

      // Get the user document
      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      // Validate password
      if (userData['password'] == request.password) {
        final user = User(
          id: userDoc.id,
          username: userData['username'],
          lastName: userData['lastName'],
          firstName: userData['firstName'],
        );

        _saveUserToLocal(user); // Save to local
        return true; // Login successful
      } else {
        throw Exception("Invalid password");
      }
    } catch (e) {
      // Handle errors
      print("Login failed: $e");
      return false; // Login failed
    }
  }

  Future<bool> register(RegisterRequest request) async {
    try {
      // Check if the username already exists
      final querySnapshot = await firestore
          .collection('users')
          .where('username', isEqualTo: request.username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception("Username already exists");
      }

      // Add the new user to Firestore
      final docRef = await firestore.collection('users').add(request.toJson());

      final user = User(
        id: docRef.id,
        username: request.username,
        lastName: request.lastName,
        firstName: request.firstName,
      );

      _saveUserToLocal(user); // Save to local
      return true; // Registration successful
    } catch (e) {
      // Handle errors
      print("Registration failed: $e");
      return false; // Registration failed
    }
  }

  Future<void> _saveUserToLocal(User user) async {
    final preferences = ref.read(preferencesProvider);
    await preferences.insert('user', jsonEncode(user.toMap()));
    ref.refresh(userControllerProvider);
    ref.refresh(noteControllerProvider);
  }

  Future<void> logout() async {
    final preferences = ref.read(preferencesProvider);
    await preferences.clear();
  }
}
