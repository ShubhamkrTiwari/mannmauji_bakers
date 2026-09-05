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
      appBar: AppBar(
        title: Text(widget.item.category),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image banner
            SizedBox(
              height: 280,
              width: double.infinity,
              child: BakeryImagePlaceholder(
                heroTag: 'item_${widget.item.id}',
                title: widget.item.name,
                imageUrl: widget.item.imageUrl,
                emoji: widget.item.category.contains('Coffee') ? '☕' : '🍰',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.offerText != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.goldAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.goldAccent),
                      ),
                      child: Text(
                        widget.item.offerText!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.goldLight : AppColors.navyPrimary,
                        ),
                      ),
                    ),
                  Text(
                    widget.item.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.goldLight : AppColors.navyPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: widget.item.tags.map((tag) {
                      return Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        backgroundColor: isDark ? AppColors.darkSurface : AppColors.goldLight.withOpacity(0.3),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'About this creation',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.item.description,
                    style: TextStyle(fontSize: 15, color: isDark ? Colors.grey[300] : Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quantity',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                HapticFeedback.lightImpact();
                                if (quantity > 1) setState(() => quantity--);
                              },
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
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
            appState.addToCart(widget.item, quantity: quantity);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added $quantity x ${widget.item.name} to cart! 🥐'),
                duration: const Duration(seconds: 2),
                backgroundColor: AppColors.navyPrimary,
              ),
            );
            Navigator.pop(context);
          },
          child: Text(
            'Add to Cart • ₹${(widget.item.price * quantity).toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
