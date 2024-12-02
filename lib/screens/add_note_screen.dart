import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_note/controllers/note_controller.dart';
import 'package:quick_note/models/note_request.dart';
import 'package:quick_note/screens/home_screen.dart';
import 'package:quick_note/shared/widgets/button_widget.dart';
import 'package:quick_note/shared/widgets/text_field_widget.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);
  static const String route = 'AddNoteScreen';

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailsController = TextEditingController();
  NoteRequest? request;

  @override
  void didChangeDependencies() {
    final request = ModalRoute.of(context)?.settings.arguments as NoteRequest?;
    if (request != null && this.request == null) {
      this.request = request;
      _titleController.text = request.title ?? '';
      _detailsController.text = request.details ?? '';
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.request == null?  'إنشاء ملاحظة':'تعديل الملاحظة',
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
              SizedBox(height: 40.h),
              TextFieldWidget(
                hintText: 'العنوان',
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال العنوان';
                  }
                  return null; // No error
                },
              ),
              SizedBox(height: 12.h),
              TextFieldWidget(
                hintText: 'الوصف',
                controller: _detailsController,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الوصف';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              ButtonWidget(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final request = NoteRequest(
                    id: this.request?.id,
                    title: _titleController.text,
                    details: _detailsController.text,
                  );
                  bool either = false;
                  if (this.request == null) {
                    either = await ref
                        .read(noteControllerProvider.notifier)
                        .addNote(request);
                  } else {
                    either = await ref
                        .read(noteControllerProvider.notifier)
                        .updateNote(request);
                  }
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
                  ref.refresh(noteControllerProvider);
                },
                text: request != null ? 'تعديل' : 'إضافة',
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
