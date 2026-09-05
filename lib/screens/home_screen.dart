import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    final TextEditingController addressController = TextEditingController(text: appState.currentAddress);

    final List<Map<String, String>> popularAreas = [
      {'title': 'Gaur City 1', 'address': 'Gaur City 1, Noida Extension, Greater Noida West', 'eta': '10-12 MINS'},
      {'title': 'Gaur City 2', 'address': 'Gaur City 2, Noida Extension, Greater Noida West', 'eta': '10-12 MINS'},
      {'title': 'Gaur City Mall', 'address': 'Gaur City Mall, Char Murti, Greater Noida West', 'eta': '8-10 MINS'},
      {'title': 'Galaxy Plaza', 'address': 'Galaxy Plaza, Gaur City 1, Noida Extension', 'eta': '10-12 MINS'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Select / Edit Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        backgroundColor: AppColors.zeptoGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: appState.isFetchingLocation
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.my_location, size: 18),
                      label: Text(
                        appState.isFetchingLocation ? 'Detecting via GPS...' : 'Detect Current Location (GPS)',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      onPressed: () async {
                        setModalState(() {});
                        await appState.fetchCurrentLocation();
                        if (context.mounted) {
                          addressController.text = appState.currentAddress;
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Enter Exact House No. / Landmark', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              hintText: 'Flat No., House/Building, Area, City...',
                              hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.zeptoPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            if (addressController.text.trim().isNotEmpty) {
                              appState.setAddress(addressController.text.trim(), '10-15 MINS');
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Update', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Popular Areas & Hubs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: popularAreas.map((area) {
                        return InkWell(
                          onTap: () {
                            appState.setAddress(area['address']!, area['eta']!);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.zeptoGreenLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.zeptoGreen.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, size: 14, color: AppColors.zeptoGreen),
                                const SizedBox(width: 4),
                                Text(area['title']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.home, color: AppColors.zeptoPurple),
                      title: const Text('Home', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Gaur City 1, Greater Noida West, Noida Extension', style: TextStyle(fontSize: 11)),
                      trailing: appState.currentAddress.contains('Gaur City') ? const Icon(Icons.check_circle, color: AppColors.zeptoGreen, size: 20) : null,
                      onTap: () {
                        appState.setAddress('Gaur City 1, Greater Noida West, Noida Extension', '10-12 MINS');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.work, color: AppColors.zeptoPurple),
                      title: const Text('Office', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Gaur City Mall, Char Murti, Greater Noida West', style: TextStyle(fontSize: 11)),
                      trailing: appState.currentAddress.contains('Gaur City Mall') ? const Icon(Icons.check_circle, color: AppColors.zeptoGreen, size: 20) : null,
                      onTap: () {
                        appState.setAddress('Gaur City Mall, Char Murti, Greater Noida West', '8-10 MINS');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
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
        color: AppColors.zeptoGreen,
        child: _isLoading
            ? const ShimmerLoading()
            : CustomScrollView(
                slivers: [
                  // Zepto-style Header with ETA & Address Bar
                  SliverAppBar(
                    expandedHeight: 180,
                    pinned: true,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.zeptoPurple,
                    title: GestureDetector(
                      onTap: () => _showLocationBottomSheet(context, appState),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.zeptoGreen,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '⚡ ${appState.deliveryEta}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            appState.currentAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
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
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                                ),
                                if (cartCount > 0)
                                  Positioned(
                                    right: -2,
                                    top: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.zeptoPink,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                                      child: Text(
                                        '$cartCount',
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                          gradient: isDark
                              ? const LinearGradient(colors: [AppColors.darkSurface, AppColors.darkBackground])
                              : AppColors.primaryGradient,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 75, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.zeptoGreen.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.zeptoGreen),
                                    ),
                                    child: const Text('🌱 100% PURE VEG BAKERY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                  const Spacer(),
                                  const SizedBox(width: 4),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Mannmauji Bakers',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
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
                          // Zepto Promotional Offer Banner Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: isDark
                                  ? const LinearGradient(colors: [AppColors.darkSurface, AppColors.darkCard])
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.zeptoPurple.withValues(alpha: 0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.zeptoPink,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'CRAZY OFFERS 🔥',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 10,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Cheesecakes Flat ₹30 OFF\nBuy 2 Pastries @ ₹119 ONLY',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white,
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text('🍰', style: TextStyle(fontSize: 28)),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 20),

                          // One-Tap Reorder Banner (if past orders exist)
                          if (appState.pastOrders.isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.zeptoCardBorder),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.zeptoGreenLight,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Text('⚡', style: TextStyle(fontSize: 18)),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Reorder in 1-Tap',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          appState.pastOrders.first.items.map((i) => i.menuItem.name).join(', '),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.zeptoGreen,
                                      side: const BorderSide(color: AppColors.zeptoGreen, width: 1.5),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      for (var item in appState.pastOrders.first.items) {
                                        appState.addToCart(item.menuItem, quantity: item.quantity);
                                      }
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Re-ordered successfully! Added to cart 🛒')),
                                      );
                                    },
                                    child: const Text('REORDER', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
                            const SizedBox(height: 20),
                          ],

                          // Section Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appState.isHotDay ? '🔥 Popular Chilled Beverages' : '✨ Bestselling Bakery Delights',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: -0.2),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('SEE ALL', style: TextStyle(color: AppColors.zeptoGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Popular Items Grid with Zepto Standard Product Cards
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: popularItems.length > 6 ? 6 : popularItems.length,
                            itemBuilder: (context, index) {
                              final item = popularItems[index];
                              final cartIndex = appState.cartItems.indexWhere((ci) => ci.menuItem.id == item.id);
                              final itemQuantity = cartIndex >= 0 ? appState.cartItems[cartIndex].quantity : 0;

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
                                    border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Image Container with ETA Chip
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 120,
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                              child: BakeryImagePlaceholder(
                                                heroTag: 'item_${item.id}',
                                                title: item.name,
                                                imageUrl: item.imageUrl,
                                                emoji: item.category.contains('Coffee') ? '☕' : '🍰',
                                                width: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.95),
                                                borderRadius: BorderRadius.circular(6),
                                                boxShadow: [
                                                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
                                                ],
                                              ),
                                              child: const Text(
                                                '⚡ 10 MINS',
                                                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.zeptoGreen),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Item Content
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item.name,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, height: 1.2),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '1 Pc Freshly Baked',
                                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '₹${item.price.toStringAsFixed(0)}',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w800,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        '₹${(item.price * 1.2).toStringAsFixed(0)}',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey[500],
                                                          decoration: TextDecoration.lineThrough,
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  // Zepto Standard ADD Button / Incrementer
                                                  itemQuantity == 0
                                                      ? InkWell(
                                                          onTap: () {
                                                            HapticFeedback.lightImpact();
                                                            appState.addToCart(item);
                                                          },
                                                          child: Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                                            decoration: BoxDecoration(
                                                              color: AppColors.zeptoGreenLight,
                                                              borderRadius: BorderRadius.circular(8),
                                                              border: Border.all(color: AppColors.zeptoGreen, width: 1.5),
                                                            ),
                                                            child: const Text(
                                                              'ADD',
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w800,
                                                                color: AppColors.zeptoGreen,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(
                                                          decoration: BoxDecoration(
                                                            color: AppColors.zeptoGreen,
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  HapticFeedback.lightImpact();
                                                                  final cartItem = appState.cartItems.firstWhere((ci) => ci.menuItem.id == item.id);
                                                                  appState.updateQuantity(cartItem, -1);
                                                                },
                                                                child: const Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                  child: Icon(Icons.remove, size: 14, color: Colors.white),
                                                                ),
                                                              ),
                                                              Text(
                                                                '$itemQuantity',
                                                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  HapticFeedback.lightImpact();
                                                                  final cartItem = appState.cartItems.firstWhere((ci) => ci.menuItem.id == item.id);
                                                                  appState.updateQuantity(cartItem, 1);
                                                                },
                                                                child: const Padding(
                                                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                                  child: Icon(Icons.add, size: 14, color: Colors.white),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
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
