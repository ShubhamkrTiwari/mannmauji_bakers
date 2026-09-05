import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order_model.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

class OrderTrackingScreen extends StatelessWidget {
  final bool isEmbeddedInTab;

  const OrderTrackingScreen({super.key, this.isEmbeddedInTab = false});

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
      {'title': 'Arriving Soon', 'icon': Icons.delivery_dining, 'desc': 'On the way to your delivery location!'},
    ];

    return Scaffold(
      appBar: AppTheme.buildGradientAppBar(
        context: context,
        title: Text('Track Order #${order.id}'),
        automaticallyImplyLeading: !isEmbeddedInTab,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stage Progress & ETA Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(stages.length, (index) {
                      final isPassed = index <= currentStep;
                      return Container(
                        height: 5,
                        width: 65,
                        decoration: BoxDecoration(
                          color: isPassed ? AppColors.zeptoGreen : Colors.grey.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.zeptoGreenLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      stages[currentStep]['icon'] as IconData,
                      size: 40,
                      color: AppColors.zeptoGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    stages[currentStep]['title'] as String,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

            const SizedBox(height: 16),

            // Live Delivery Partner Info Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.zeptoGreenLight,
                    child: const Icon(Icons.two_wheeler, color: AppColors.zeptoGreen, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rider: Ramesh Kumar 🛵', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 2),
                        Text('Express Delivery • Hero Splendor (UP-16)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_in_talk, color: AppColors.zeptoGreen),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling delivery partner Ramesh: 8401545654 📞')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Order Items Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
              ),
              child: Column(
                children: [
                  ...order.items.map((ci) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${ci.quantity}x ${ci.menuItem.name}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                            Text('₹${ci.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount Paid', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.zeptoGreen)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isEmbeddedInTab
          ? null
          : Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zeptoGreen,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CustomPageRoute(child: const MainNavigation()),
                    (route) => false,
                  );
                },
                child: const Text('Back to Home', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
    );
  }
}
