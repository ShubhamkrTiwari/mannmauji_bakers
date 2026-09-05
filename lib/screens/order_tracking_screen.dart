import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final order = appState.activeOrder ?? appState.pastOrders.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    int currentStep = 0;
    if (order.status == OrderStatus.baking) currentStep = 1;
    if (order.status == OrderStatus.packing) currentStep = 2;
    if (order.status == OrderStatus.ready || order.status == OrderStatus.delivered) currentStep = 3;

    final stages = [
      {'title': 'Order Received', 'icon': Icons.receipt_long, 'desc': 'Kitchen has accepted your sweet order!'},
      {'title': 'Freshly Baking', 'icon': Icons.bakery_dining, 'desc': 'Cheesecakes & pastries baking in oven.'},
      {'title': 'Careful Packing', 'icon': Icons.card_giftcard, 'desc': 'Boxed up securely with love.'},
      {'title': 'Ready / Out', 'icon': Icons.delivery_dining, 'desc': 'Ready for pickup or on the way to you!'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Order #${order.id}'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Story-style horizontal progress bar indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(stages.length, (index) {
                      final isPassed = index <= currentStep;
                      return Container(
                        height: 6,
                        width: 60,
                        decoration: BoxDecoration(
                          color: isPassed ? AppColors.goldAccent : Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Icon(
                    stages[currentStep]['icon'] as IconData,
                    size: 56,
                    color: AppColors.goldAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stages[currentStep]['title'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stages[currentStep]['desc'] as String,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Order Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...order.items.map((ci) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${ci.quantity}x ${ci.menuItem.name}'),
                            Text('₹${ci.totalPrice.toStringAsFixed(0)}'),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Paid', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.goldAccent)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              CustomPageRoute(child: const MainNavigation()),
              (route) => false,
            );
          },
          child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
