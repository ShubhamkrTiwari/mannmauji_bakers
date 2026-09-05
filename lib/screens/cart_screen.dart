import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bakery_image_placeholder.dart';
import '../models/menu_item.dart';
import '../models/menu_data.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Smart recommendations rule-based logic (Part 2 feature 3):
    // If bakery item in cart suggests a cafe drink, and vice versa.
    bool hasBakery = appState.cartItems.any((ci) => !ci.menuItem.category.contains('Coffee'));
    bool hasDrink = appState.cartItems.any((ci) => ci.menuItem.category.contains('Coffee'));
    
    List<MenuItem> recommendations = [];
    if (hasBakery && !hasDrink) {
      recommendations = menuItems.where((i) => i.category.contains('Coffee')).take(3).toList();
    } else if (hasDrink && !hasBakery) {
      recommendations = menuItems.where((i) => !i.category.contains('Coffee')).take(3).toList();
    } else {
      recommendations = menuItems.take(3).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Sweet Cart'),
      ),
      body: appState.cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.goldAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is feeling a bit lonely!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Let’s bake up some happiness. Explore our freshly baked cheesecakes, brownies & warm waffles!',
                      style: TextStyle(color: Colors.grey[600], height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Cart Items List
                      ...appState.cartItems.map((cartItem) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: BakeryImagePlaceholder(
                                    heroTag: '',
                                    title: '',
                                    imageUrl: cartItem.menuItem.imageUrl,
                                    emoji: cartItem.menuItem.category.contains('Coffee') ? '☕' : '🍰',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.menuItem.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${cartItem.menuItem.price.toStringAsFixed(0)} each',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                                    onPressed: () => appState.updateQuantity(cartItem, -1),
                                  ),
                                  Text(
                                    '${cartItem.quantity}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline, size: 20),
                                    onPressed: () => appState.updateQuantity(cartItem, 1),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      // Smart Recommendations Row ("Pairs well with this")
                      if (recommendations.isNotEmpty) ...[
                        const Text(
                          '💡 Pairs Well With This',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final rec = recommendations[index];
                              return Container(
                                width: 120,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.goldAccent.withOpacity(0.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                        child: BakeryImagePlaceholder(
                                          heroTag: '',
                                          title: '',
                                          imageUrl: rec.imageUrl,
                                          emoji: rec.category.contains('Coffee') ? '☕' : '🍰',
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rec.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${rec.price.toStringAsFixed(0)}',
                                                style: const TextStyle(fontSize: 11),
                                              ),
                                              GestureDetector(
                                                onTap: () => appState.addToCart(rec),
                                                child: const Icon(Icons.add_circle, size: 18, color: AppColors.goldAccent),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Bill Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bill Summary',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal'),
                                Text('₹${appState.cartSubtotal.toStringAsFixed(0)}'),
                              ],
                            ),
                            if (appState.cartDiscount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Offer Discount', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                                  Text('-₹${appState.cartDiscount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery & Packaging'),
                                Text('₹${appState.deliveryFee.toStringAsFixed(0)}'),
                              ],
                            ),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text('₹${appState.cartTotal.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? AppColors.goldLight : AppColors.navyPrimary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkout Button
                Container(
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
                      Navigator.push(
                        context,
                        CustomPageRoute(child: const CheckoutScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Proceed to Checkout • ₹${appState.cartTotal.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
