import 'package:kd_latin_food/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientHelpController extends GetxController {
  User user = User.fromJson(GetStorage().read('user'));
}
