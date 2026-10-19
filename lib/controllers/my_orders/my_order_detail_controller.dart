import 'package:get/get.dart';

import '../auth_controller.dart';
import '../../models/my_orders/my_order_detail.dart';
import '../../services/my_orders/my_orders_api.dart';

class MyOrderDetailController extends GetxController {
  MyOrderDetailController({required this.orderId});

  final String orderId;
  final Rxn<MyOrderDetail> order = Rxn<MyOrderDetail>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  AuthController get _auth => Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      order.value = await MyOrdersApi.fetchMyOrderDetail(
        _auth.token.value,
        orderId,
      );
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      order.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
