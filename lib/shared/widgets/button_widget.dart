import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    super.key,
    this.onPressed,
    this.text,
    this.disable,
    this.isLoading,
  });

  final String? text;
  final dynamic Function()? onPressed;
  final bool? disable;
  final bool? isLoading;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  late bool isLoading;

  Future<void> _handlePress() async {
    setState(() {
      isLoading = true;
    });
    await widget.onPressed!();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    isLoading = widget.isLoading ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: true == widget.disable ? 0.2 : 1,
      child: SizedBox(
        height: 60.h,
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: widget.onPressed != null ? _handlePress : null,
          elevation: 0,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.h),
            borderSide: BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h),
          color: Colors.blue,
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 10.h,
                );
              }
              return Center(
                child: Text(
                  widget.text ?? '',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
