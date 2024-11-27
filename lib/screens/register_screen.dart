import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_note/controllers/auth_controller.dart';
import 'package:quick_note/gen/assets.gen.dart';
import 'package:quick_note/models/register_request.dart';
import 'package:quick_note/screens/home_screen.dart';
import 'package:quick_note/shared/widgets/button_widget.dart';
import 'package:quick_note/shared/widgets/text_field_widget.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  static const String route = 'RegisterScreen';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إنشاء حسابك',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w700,
            fontSize: 18.h,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 80.h),
              Text(
                'إدخل بياناتك',
                style: TextStyle(fontSize: 32.h, color: Colors.black),
              ),
              SizedBox(height: 16.h),
              Text(
                'أدخل بياناتك لتجربة مُصممة لاجلك.',
                style: TextStyle(fontSize: 16.h, color: Colors.black),
              ),
              SizedBox(height: 60.h),
              TextFieldWidget(
                hintText: 'الاسم الأول',
                controller: _firstNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الأول';
                  }
                  return null; // No error
                },
              ),
              SizedBox(height: 12.h),
              TextFieldWidget(
                hintText: 'الاسم الثاني',
                controller: _lastNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الاسم الثاني';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              TextFieldWidget(
                hintText: 'اسم المستخدم',
                controller: _usernameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال اسم المستخدم';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              TextFieldWidget(
                hintText: 'كلمة المرور',
                suffixIconConstraints: BoxConstraints(maxWidth: 32.h),
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال كلمة المرور';
                  } else if (value.length < 6) {
                    return 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل';
                  }
                  return null;
                },
                suffixWidget: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: () {
                      setState(() => _showPassword = !_showPassword);
                    },
                    child: _showPassword
                        ? Assets.icons.eye.svg(
                            height: 16.h,
                            color: Colors.grey,
                          )
                        : Assets.icons.eyeSlash.svg(
                            height: 16.h,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // TextWidget(
              //   'هل نسيت كلمة السر؟',
              //   style: context.textStyles.titleBold
              //       .copyWith(color: context.colors.brandDark),
              // ),
              // SizedBox(height: context.insets.xl),
              ButtonWidget(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final request = RegisterRequest(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    username: _usernameController.text,
                    password: _passwordController.text,
                  );
                  final either = await ref
                      .read(authControllerProvider.notifier)
                      .register(request);
                  if (!mounted) return;
                  if (either) {
                    unawaited(Navigator.pushReplacementNamed(
                        context, HomeScreen.route));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('نأسف، حدث خطأ غير متوقع.'),
                      ),
                    );
                  }
                },
                text: 'متابعة',
              ),
              SizedBox(height: 20.h),
              Center(
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(
                      text: 'لست عضوا؟ ',
                      style: TextStyle(color: Colors.grey, fontSize: 16.h),
                    ),
                    TextSpan(
                      text: 'سجل الآن',
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      style: TextStyle(color: Colors.blue, fontSize: 16.h),
                    ),
                  ]),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
