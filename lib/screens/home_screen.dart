import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/bakery_image_placeholder.dart';
import '../widgets/shimmer_loading.dart';
import '../models/menu_item.dart';
import '../models/menu_data.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() => _isLoading = false);
  }

  void _showLocationBottomSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Delivery Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Text('✕', style: TextStyle(fontSize: 18)), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: AppColors.goldAccent,
                  foregroundColor: AppColors.navyPrimary,
                ),
                icon: appState.isFetchingLocation
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navyPrimary))
                    : const Text('📍', style: TextStyle(fontSize: 18)),
                label: Text(appState.isFetchingLocation ? 'Detecting via GPS...' : 'Detect Current Location (GPS)'),
                onPressed: () async {
                  await appState.fetchCurrentLocation();
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              ListTile(
                leading: const Text('🏠', style: TextStyle(fontSize: 22)),
                title: const Text('Home'),
                subtitle: const Text('42, Royal Bakery Avenue, City Center'),
                trailing: appState.currentAddress.contains('Royal Bakery') ? const Text('✅', style: TextStyle(fontSize: 16)) : null,
                onTap: () {
                  appState.setAddress('42, Royal Bakery Avenue, City Center', '15-17 mins');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Text('🏢', style: TextStyle(fontSize: 22)),
                title: const Text('Office'),
                subtitle: const Text('102, Sweet Avenue, Near Central Park'),
                trailing: appState.currentAddress.contains('Sweet Avenue') ? const Text('✅', style: TextStyle(fontSize: 16)) : null,
                onTap: () {
                  appState.setAddress('102, Sweet Avenue, Near Central Park', '14-16 mins');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = appState.cartItems.fold(0, (sum, item) => sum + item.quantity);

    // Filter items based on weather (hot day -> cold coffee/drinks first)
    final popularItems = List<MenuItem>.from(menuItems);
    if (appState.isHotDay) {
      popularItems.sort((a, b) {
        if (a.category == 'Cold Coffee') return -1;
        if (b.category == 'Cold Coffee') return 1;
        return 0;
      });
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: AppColors.goldAccent,
        child: _isLoading
            ? const ShimmerLoading()
            : CustomScrollView(
                slivers: [
                  // Zepto-style Top Sticky App Bar with Delivery ETA & Address at the Very Top
                  SliverAppBar(
                    expandedHeight: 200,
                    pinned: true,
                    title: GestureDetector(
                      onTap: () => _showLocationBottomSheet(context, appState),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.goldAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              appState.deliveryEta,
                              style: const TextStyle(color: AppColors.navyPrimary, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              appState.currentAddress,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const Text(' ⌄', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.push(
                                context,
                                CustomPageRoute(child: const CartScreen()),
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.navySecondary,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.goldAccent.withOpacity(0.5)),
                                  ),
                                  child: const Text('🛍️', style: TextStyle(fontSize: 16)),
                                ),
                                if (cartCount > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.softRed,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                      child: Text(
                                        '$cartCount',
                                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.navyPrimary,
                              AppColors.navySecondary,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.successGreen.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.successGreen),
                                    ),
                                    child: const Text('🌱 PURE VEG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('📞', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '8401545654',
                                    style: TextStyle(color: AppColors.goldLight, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'MANNMAUJI BAKERS',
                                style: GoogleFonts.fraunces(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.goldLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Choice Aapke Mann Ki, Quality Hamare Bakery Ki ✨',
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Body Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Promotional Special Offer Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.goldAccent, AppColors.goldLight],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.goldAccent.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SPECIAL BAKERY OFFERS 🔥',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.navyPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Buy Any 2 Cheesecakes Get ₹30 OFF\nBuy Any 2 Pastries @ ₹119',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColors.navyPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: AppColors.navyPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text('🎂', style: TextStyle(fontSize: 24)),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 20),

                          // Order Again One-Tap Reorder Banner (if past orders exist)
                          if (appState.pastOrders.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.goldAccent.withOpacity(0.4)),
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: AppColors.goldAccent,
                                    child: Text('⚡', style: TextStyle(fontSize: 20)),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Order Again in 1-Tap ⚡',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          appState.pastOrders.first.items.map((i) => i.menuItem.name).join(', '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      minimumSize: Size.zero,
                                    ),
                                    onPressed: () {
                                      for (var item in appState.pastOrders.first.items) {
                                        appState.addToCart(item.menuItem, quantity: item.quantity);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Re-ordered successfully! Added to cart 🛒')),
                                      );
                                    },
                                    child: const Text('Reorder', style: TextStyle(fontSize: 11)),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 20),
                          ],

                          // Section Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appState.isHotDay ? '🔥 Popular Right Now (Chilled Drinks)' : '✨ Popular Right Now (Warm & Fresh)',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('View All', style: TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Popular Items Grid with staggered entrance animations
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.82,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: popularItems.length > 6 ? 6 : popularItems.length,
                            itemBuilder: (context, index) {
                              final item = popularItems[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CustomPageRoute(child: ProductDetailScreen(item: item)),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkSurface : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                          child: BakeryImagePlaceholder(
                                            heroTag: 'item_${item.id}',
                                            title: item.name,
                                            imageUrl: item.imageUrl,
                                            emoji: item.category.contains('Coffee') ? '☕' : '🍰',
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '₹${item.price.toStringAsFixed(0)}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark ? AppColors.goldLight : AppColors.navyPrimary,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    appState.addToCart(item);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Added ${item.name} to cart! 🥐'),
                                                        duration: const Duration(milliseconds: 1000),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.navyPrimary,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: const Text('➕', style: TextStyle(fontSize: 12, color: AppColors.goldLight)),
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
                              ).animate().fadeIn(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.2, end: 0);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
