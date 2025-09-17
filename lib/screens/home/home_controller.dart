import 'package:get/get.dart';
import 'package:sql_crud_app/db_handler.dart';
import 'package:sql_crud_app/model/user_model.dart';

class HomeController extends GetxController {
  ///For fetch user...
  bool fetching = false;
  startFetch() {
    fetching = true;
    update();
  }

  stopFetch() {
    fetching = false;
    update();
  }

  List<UserModel> userList = [];
  getUserList() async {
    startFetch();
    await dbHandler.getDBdata().then((value) {
      print("Users List - $value");
      userList = [];
      for (var element in value) {
        userList.add(UserModel.fromJson(element));
      }
      print("userList - $userList\nuserList Length - ${userList.length}");
      stopFetch();
    });
  } //---------------------------------------------------//

  ///For delete user...
  deleteUser(int id) async {
    await dbHandler.deleteRecordOfDB(id);
    getUserList();
    Get.back();
  } //---------------------------------------------------//
}
