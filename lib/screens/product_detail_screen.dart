import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/menu_item.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bakery_image_placeholder.dart';

class ProductDetailScreen extends StatefulWidget {
  final MenuItem item;

  const ProductDetailScreen({super.key, required this.item});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppTheme.buildGradientAppBar(
        context: context,
        title: Text(widget.item.category),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image banner with ETA Chip
            Stack(
              children: [
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: BakeryImagePlaceholder(
                    heroTag: 'item_${widget.item.id}',
                    title: widget.item.name,
                    imageUrl: widget.item.imageUrl,
                    emoji: widget.item.category.contains('Coffee') ? '☕' : '🍰',
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.bolt, color: AppColors.zeptoGreen, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '10-15 MINS DELIVERY',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.zeptoGreen),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.offerText != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.zeptoPink.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        widget.item.offerText!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.zeptoPink,
                        ),
                      ),
                    ),
                  Text(
                    widget.item.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '₹${widget.item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.zeptoTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '₹${(widget.item.price * 1.2).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.zeptoGreenLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('15% OFF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: widget.item.tags.map((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 11)),
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.zeptoBackground,
                        side: BorderSide(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Product Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.item.description,
                    style: TextStyle(fontSize: 14, color: isDark ? Colors.grey[300] : Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Quantity',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.zeptoGreenLight,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.zeptoGreen, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18, color: AppColors.zeptoGreen),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                if (quantity > 1) setState(() => quantity--);
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18, color: AppColors.zeptoGreen),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                setState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
            appState.addToCart(widget.item, quantity: quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added $quantity x ${widget.item.name} to cart! 🥐'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.zeptoPurple,
              ),
            );
            Navigator.pop(context);
          },
          child: Text(
            'Add to Cart • ₹${(widget.item.price * quantity).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
