import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quick_note/controllers/auth_controller.dart';
import 'package:quick_note/controllers/note_controller.dart';
import 'package:quick_note/controllers/user_controller.dart';
import 'package:quick_note/gen/assets.gen.dart';
import 'package:quick_note/screens/add_note_screen.dart';
import 'package:quick_note/screens/login_screen.dart';
import 'package:quick_note/shared/widgets/button_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  Widget build(BuildContext context, ref) {
    final noteController = ref.watch(noteControllerProvider);
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox.shrink(),
          leadingWidth: 0,
          title: Text(
            'ملاحظاتي',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w700,
              fontSize: 18.h,
            ),
          ),
          actions: [
            SizedBox(width: 16.h),
            GestureDetector(
              onTap: () {
                ref.read(authControllerProvider.notifier).logout();
                ref.invalidate(noteControllerProvider);
                ref.invalidate(userControllerProvider);
                Navigator.pushReplacementNamed(context, LoginScreen.route);
              },
              child: Assets.icons.logout.svg(color: Colors.blue, height: 25.h),
            ),
            SizedBox(width: 16.h),
          ],
        ),
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.h),
            child: ButtonWidget(
              onPressed: () {
                Navigator.pushNamed(context, AddNoteScreen.route);
              },
              text: 'إضافة',
            ),
          ),
        ],
        body: noteController.when(
          error: (error, stackTrace) => Center(
            child: Text(
              'نأسف، حدث خطأ غير متوقع.',
              style: TextStyle(fontSize: 20.h, color: Colors.black),
            ),
          ),
          loading: () => Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) => RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(noteControllerProvider.future);
            },
            child: Builder(builder: (context) {
              if (data.isNotEmpty) {
                return ListView.separated(
                  padding: EdgeInsets.all(20.h),
                  itemCount: data.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) => Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: index.isOdd
                          ? Colors.blue.withOpacity(0.34)
                          : Colors.green.withOpacity(0.34),
                      borderRadius: BorderRadius.circular(16.h),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[index].title,
                                style: TextStyle(
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                data[index].details,
                                style: TextStyle(
                                  fontSize: 16.h,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20.h),
                        Column(
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    AddNoteScreen.route,
                                    arguments: data[index],
                                  );
                                },
                                child: Assets.icons.edit.svg()),
                            SizedBox(height: 15.h),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Text('هل أنت متأكد أن تريد الحذف'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(noteControllerProvider
                                                  .notifier)
                                              .deleteNote(data[index].id);
                                          ref.refresh(
                                              noteControllerProvider.notifier);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'نعم',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'تراجع',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Assets.icons.trash.svg(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Center(
                child: Text(
                  'لا يوجد بيانات',
                  style: TextStyle(
                    fontSize: 20.h,
                    color: Colors.blue,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
