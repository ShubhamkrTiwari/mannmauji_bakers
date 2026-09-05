import 'package:flutter_test/flutter_test.dart';
import 'package:mannmauji_bakers/providers/app_state.dart';
import 'package:mannmauji_bakers/models/menu_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AppState cart and discount logic test', () {
    final appState = AppState();
    expect(appState.cartItems.isEmpty, true);

    // Add 2 items of cheesecake (qualifies for offer)
    appState.addToCart(menuItems[0], quantity: 2);
    expect(appState.cartItems.length, 1);
    expect(appState.cartItems[0].quantity, 2);
    expect(appState.cartDiscount, 30.0);
  });
}
