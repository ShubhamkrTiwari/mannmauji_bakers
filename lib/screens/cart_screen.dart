import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bakery_image_placeholder.dart';
import '../models/menu_item.dart';
import '../models/menu_data.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTip = 20;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Smart recommendations rule-based logic
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

    final grandTotal = appState.cartTotal + _selectedTip;

    return Scaffold(
      appBar: AppTheme.buildGradientAppBar(
        context: context,
        title: const Text('Your Cart'),
      ),
      body: appState.cartItems.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.zeptoGreenLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.zeptoGreen),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore our freshly baked cheesecakes, brownies & warm beverages!',
                      style: TextStyle(color: Colors.grey[600], height: 1.4, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // Delivery ETA Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppColors.zeptoGreenLight,
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: AppColors.zeptoGreen, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Delivery in ${appState.deliveryEta}',
                        style: const TextStyle(
                          color: AppColors.zeptoGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Fastest Delivery ⚡',
                        style: TextStyle(fontSize: 11, color: AppColors.zeptoGreen, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

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
                            border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
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
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${cartItem.menuItem.price.toStringAsFixed(0)} each',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Incrementer
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.zeptoGreen,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        appState.updateQuantity(cartItem, -1);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        child: Icon(Icons.remove, size: 14, color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      '${cartItem.quantity}',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        appState.updateQuantity(cartItem, 1);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        child: Icon(Icons.add, size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 12),

                      // Smart Recommendations Row ("Frequently Bought Together")
                      if (recommendations.isNotEmpty) ...[
                        const Text(
                          'Frequently Bought Together',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 130,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendations.length,
                            itemBuilder: (context, index) {
                              final rec = recommendations[index];
                              return Container(
                                width: 125,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurface : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.zeptoCardBorder),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: BakeryImagePlaceholder(
                                          heroTag: '',
                                          title: '',
                                          imageUrl: rec.imageUrl,
                                          emoji: rec.category.contains('Coffee') ? '☕' : '🍰',
                                          width: double.infinity,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      rec.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '₹${rec.price.toStringAsFixed(0)}',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            appState.addToCart(rec);
                                          },
                                          child: const Text('+ ADD', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Zepto Delivery Partner Tip Option
                      Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.two_wheeler, color: AppColors.zeptoPurple, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Tip Your Delivery Partner',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '100% of the tip goes to your delivery executive.',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [20, 30, 50, 0].map((tipVal) {
                                final isSelected = _selectedTip == tipVal;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ChoiceChip(
                                      label: Center(
                                        child: Text(
                                          tipVal == 0 ? 'No Tip' : '₹$tipVal',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        HapticFeedback.lightImpact();
                                        setState(() => _selectedTip = selected ? tipVal : 0);
                                      },
                                      selectedColor: AppColors.zeptoGreenLight,
                                      side: BorderSide(
                                        color: isSelected ? AppColors.zeptoGreen : AppColors.zeptoCardBorder,
                                      ),
                                      labelStyle: TextStyle(
                                        color: isSelected ? AppColors.zeptoGreen : Colors.grey[800],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),

                      // Bill Summary Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Bill Details',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Item Total', style: TextStyle(fontSize: 13)),
                                Text('₹${appState.cartSubtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            if (appState.cartDiscount > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discount Savings', style: TextStyle(color: AppColors.zeptoGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                                  Text('-₹${appState.cartDiscount.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.zeptoGreen, fontWeight: FontWeight.bold, fontSize: 13)),
                                ],
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Fee', style: TextStyle(fontSize: 13)),
                                Text('₹${appState.deliveryFee.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            if (_selectedTip > 0) ...[
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Delivery Partner Tip', style: TextStyle(fontSize: 13)),
                                  Text('₹$_selectedTip', style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ],
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('To Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Text(
                                  '₹${grandTotal.toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.zeptoGreen),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Zepto Green Savings Banner
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.zeptoGreenLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.zeptoGreen.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: [
                            const Text('🎉', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              'You saved ₹${(appState.cartDiscount + 20).toStringAsFixed(0)} on this order!',
                              style: const TextStyle(
                                color: AppColors.zeptoGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Sticky Bottom Pay Bar
                Container(
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
                      Navigator.push(
                        context,
                        CustomPageRoute(child: const CheckoutScreen()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '₹${grandTotal.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                            const Text(
                              'TOTAL AMOUNT',
                              style: TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text('Proceed to Checkout', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
