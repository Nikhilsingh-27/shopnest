import 'package:get/get.dart';
import 'package:shopnest/data/repositories/auth_repository.dart';

import '../network/dio_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient());
    Get.put(AuthRepository(), permanent: true);
  }
}
