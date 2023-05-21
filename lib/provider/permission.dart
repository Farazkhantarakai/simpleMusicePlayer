import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHander extends GetxController {
  late PermissionStatus _permissionStatus;
  RxBool _isAllowed = false.obs;

  get getPermission => _isAllowed.value;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _getPermission();
  // }

  void setPermision() async {
    _permissionStatus = await Permission.storage.request();
    if (_permissionStatus.isDenied) {
      _isAllowed.value = false;
    }
    if (_permissionStatus.isGranted) {
      _isAllowed.value = true;
    }
  }
}
