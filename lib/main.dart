import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sql_crud_app/db_handler.dart';
import 'package:sql_crud_app/screens/add_user/add_or_edit_user_controller.dart';
import 'package:sql_crud_app/screens/home/home_controller.dart';
import 'package:sql_crud_app/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHandler.createDB();
  Get.put(AddOrEditUserController());
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SQL CRUD APP',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(title: 'SQL CRUD APP'),
    );
  }
}
