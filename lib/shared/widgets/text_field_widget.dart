
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    this.controller,
    this.validator,
    this.onChanged,
    this.constraints,
    this.onTap,
    this.hintText,
    this.decoration,
    this.contentPadding,
    this.radius,
    this.color,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.none,
    this.initialValue,
    this.style,
    this.onEditingComplete,
    this.focusNode,
    this.hintStyle,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText,
    this.maxLines,
    this.height,
    this.prefixWidget,
    this.suffixWidget,
    this.suffixIconConstraints,
    super.key,
  });

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final VoidCallback? onEditingComplete;
  final bool? obscureText;
  final bool autofocus;
  final int? maxLines;
  final double? height;
  final FormFieldValidator<String>? validator;
  final BoxConstraints? constraints;
  final ValueChanged<String>? onChanged;
  final Radius? radius;
  final GestureTapCallback? onTap;
  final bool readOnly;
  final String? hintText;
  final Decoration? decoration;
  final EdgeInsetsGeometry? contentPadding;
  final Color? color;

  final FocusNode? focusNode;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final BoxConstraints? suffixIconConstraints;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.obscureText ?? false,
      autofocus: widget.autofocus,
      focusNode: _focusNode,
      initialValue: widget.initialValue,
      controller: widget.controller,
      readOnly: widget.readOnly,
      onChanged: (value) {
        widget.onChanged?.call(value);
        setState(() {});
      },
      maxLines: widget.maxLines ?? 1,
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        constraints: widget.constraints,
        hintText: widget.hintText,
        suffixIconConstraints: widget.suffixIconConstraints,
        suffixIcon: widget.suffixWidget,
        contentPadding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 8.h,
        ),
        fillColor: Colors.white,
        filled: true,
        enabledBorder: _buildOutlineInputBorder(context),
        border: _buildOutlineInputBorder(context),
        focusedBorder: _buildOutlineInputBorder(context),
      ),
    );
  }

  OutlineInputBorder _buildOutlineInputBorder(BuildContext context) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.h,
      ),
      borderRadius: BorderRadius.circular(15.h),
    );
  }
}
