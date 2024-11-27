import 'package:flutter/cupertino.dart';
import 'package:quick_note/screens/add_note_screen.dart';
import 'package:quick_note/screens/home_screen.dart';
import 'package:quick_note/screens/login_screen.dart';
import 'package:quick_note/screens/register_screen.dart';

abstract class AppRoutes {
  AppRoutes._();

  static Map<String, WidgetBuilder> routes = {
    HomeScreen.route: (context) => const HomeScreen(),
    LoginScreen.route: (context) => const LoginScreen(),
    RegisterScreen.route: (context) => const RegisterScreen(),
    AddNoteScreen.route: (context) => const AddNoteScreen(),
  };
}
