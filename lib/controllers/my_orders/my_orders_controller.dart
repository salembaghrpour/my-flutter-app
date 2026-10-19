import 'package:get/get.dart';

import '../../models/my_orders/my_order_detail.dart';
import '../../models/my_orders/my_order_summary.dart';
import '../../services/my_orders/my_orders_api.dart';

class MyOrdersController extends GetxController {
  MyOrdersController({MyOrdersApi? api}) : _api = api ?? MyOrdersApi();

  final MyOrdersApi _api;

  // State
  final RxList<MyOrderSummary> orders = <MyOrderSummary>[].obs;
  final Rxn<MyOrderDetail> selectedOrder = Rxn<MyOrderDetail>();
  final RxBool isLoading = false.obs;
  final RxBool isDetailLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final List<MyOrderSummary> result = await _api.fetchOrders();
      orders.assignAll(result);
    } catch (e) {
      errorMessage.value = _cleanError(e);
      orders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOrderDetail(String orderId) async {
    final String id = orderId.trim();
    if (id.isEmpty) {
      errorMessage.value = 'شناسه سفارش نامعتبر است.';
      return;
    }
    isDetailLoading.value = true;
    errorMessage.value = '';
    try {
      final MyOrderDetail detail = await _api.fetchOrderDetail(id);
      selectedOrder.value = detail;
    } catch (e) {
      errorMessage.value = _cleanError(e);
      selectedOrder.value = null;
    } finally {
      isDetailLoading.value = false;
    }
  }

  String _cleanError(Object error) {
    String text = error.toString().replaceAll('Exception: ', '').trim();
    if (text.isEmpty) text = 'خطای نامشخص در دریافت اطلاعات.';
    return text;
  }
}
