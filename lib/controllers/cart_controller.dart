// lib/controllers/cart_controller.dart
import 'package:get/get.dart';

class CartController extends GetxController {
  // لیست آیتم‌های سبد خرید
  var cartItems = <Map<String, dynamic>>[].obs;

  // محاسبه تعداد کل آیتم‌ها (با در نظر گرفتن تعداد از هر کالا)
  int get totalItemsCount {
    return cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int));
  }

  // محاسبه جمع کل مبلغ سبد خرید
  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) {
      // تبدیل قیمت به عدد اعشاری (double) برای جلوگیری از خطاهای تایپ
      double price = double.tryParse(item['selling_price'].toString()) ?? 0.0;
      int quantity = item['quantity'] as int;
      return sum + (price * quantity);
    });
  }

  // افزودن به سبد خرید
  void addToCart(Map<String, dynamic> product) {
    int index = cartItems.indexWhere((item) => item['id'] == product['id']);
    
    if (index != -1) {
      // اگر محصول قبلاً در سبد بود، تعداد آن را یکی اضافه کن
      cartItems[index]['quantity'] += 1;
      cartItems.refresh(); // برای بروزرسانی UI
    } else {
      // اگر محصول جدید است، با تعداد ۱ به لیست اضافه کن
      Map<String, dynamic> newProduct = Map.from(product);
      newProduct['quantity'] = 1;
      cartItems.add(newProduct);
    }
    // نمایش پیام را برای زمانی که دستی تعداد را اضافه می‌کنیم غیرفعال کردم تا مزاحم نباشد
    // اما در صفحه لیست محصولات می‌توانید پیام را در خود صفحه هندل کنید.
  }

  // حذف یا کم کردن از سبد خرید
  void removeFromCart(Map<String, dynamic> product) {
    int index = cartItems.indexWhere((item) => item['id'] == product['id']);
    
    if (index != -1) {
      if (cartItems[index]['quantity'] > 1) {
        // اگر بیشتر از یکی بود، فقط یکی کم کن
        cartItems[index]['quantity'] -= 1;
      } else {
        // اگر فقط یکی بود، کلاً از سبد حذف کن
        cartItems.removeAt(index);
      }
      cartItems.refresh(); // برای بروزرسانی UI
    }
  }

  // تنظیم دستی تعداد یک محصول (جدید)
  void updateQuantity(Map<String, dynamic> product, int quantity) {
    if (quantity <= 0) {
      // اگر تعداد صفر یا کمتر بود، کالا را کلا حذف کن
      cartItems.removeWhere((item) => item['id'] == product['id']);
    } else {
      int index = cartItems.indexWhere((item) => item['id'] == product['id']);
      if (index != -1) {
        cartItems[index]['quantity'] = quantity;
      }
    }
    cartItems.refresh(); // بروزرسانی UI
  }

  // خالی کردن کامل سبد خرید (مثلا بعد از ثبت سفارش)
  void clearCart() {
    cartItems.clear();
  }
}
