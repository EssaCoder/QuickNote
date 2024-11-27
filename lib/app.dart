import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_note/controllers/user_controller.dart';
import 'package:quick_note/routes/app_routes.dart';
import 'package:quick_note/screens/home_screen.dart';
import 'package:quick_note/screens/login_screen.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userControllerProvider);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return ScreenUtilInit(
      designSize: const Size(428, 926),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'QuickNote',
        themeMode: ThemeMode.light,
        routes: AppRoutes.routes,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: const Color(0xffF8FBFE),
          dividerColor: Colors.transparent,
          colorScheme: const ColorScheme.light(
            primary: Color(0xff137ACE),
            secondary: Color(0xff2AADE0),
          ),
          primaryColor: const Color(0xff137ACE),
          fontFamily: 'Alexandria',
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xff137ACE),
            selectionColor: Color(0xff2AADE0),
            selectionHandleColor: Color(0xff137ACE),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: const Color(0xff999A98).withOpacity(0.5),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: false,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        initialRoute: () {
          if (user != null) {
            return HomeScreen.route;
          }
          return LoginScreen.route;
        }(),
        builder: (context, widget) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.noScaling),
            child: widget ?? const SizedBox(),
          );
        },
      ),
    );
  }
}
