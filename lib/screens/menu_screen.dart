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

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Cheese Cake',
    'Brownie',
    'Bomboloni',
    'Pastries',
    'Waffle',
    'Mini Waffle',
    'Muffin',
    'Korean Bun',
    'Donuts',
    'Cold Coffee',
  ];

  final List<String> dietaryFilters = ['All', 'Veg', 'Contains nuts', 'Bestseller'];

  Future<void> _refreshMenu() async {
    HapticFeedback.lightImpact();
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter menu items
    List<MenuItem> filteredItems = menuItems.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesDietary = appState.selectedFilter == 'All' || item.tags.contains(appState.selectedFilter);
      return matchesSearch && matchesCategory && matchesDietary;
    }).toList();

    return Scaffold(
      appBar: AppTheme.buildGradientAppBar(
        context: context,
        title: const Text('Explore Bakery Menu'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMenu,
        color: AppColors.zeptoGreen,
        child: _isLoading
            ? const ShimmerLoading()
            : Column(
                children: [
                  // Search Bar & Filters
                  Container(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search cheesecakes, brownies, waffles...',
                            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                            prefixIcon: const Icon(Icons.search, color: AppColors.zeptoGreen),
                            filled: true,
                            fillColor: isDark ? AppColors.darkBackground : AppColors.zeptoBackground,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Dietary filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: dietaryFilters.map((filter) {
                              final isSelected = appState.selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(filter, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    appState.setFilter(selected ? filter : 'All');
                                  },
                                  selectedColor: AppColors.zeptoGreenLight,
                                  side: BorderSide(
                                    color: isSelected ? AppColors.zeptoGreen : AppColors.zeptoCardBorder,
                                  ),
                                  labelStyle: TextStyle(
                                    color: isSelected ? AppColors.zeptoGreen : Colors.grey[800],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Horizontal List
                  Container(
                    height: 48,
                    color: isDark ? AppColors.darkBackground : AppColors.zeptoBackground,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500)),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.zeptoPurple,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Items List
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, size: 60, color: Colors.grey),
                                const SizedBox(height: 12),
                                const Text(
                                  'No items found matching your filter.',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Try searching for something else.',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final cartIndex = appState.cartItems.indexWhere((ci) => ci.menuItem.id == item.id);
                              final itemQuantity = cartIndex >= 0 ? appState.cartItems[cartIndex].quantity : 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CustomPageRoute(child: ProductDetailScreen(item: item)),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.darkSurface : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                                    ),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: BakeryImagePlaceholder(
                                                  heroTag: 'item_${item.id}',
                                                  title: item.name,
                                                  imageUrl: item.imageUrl,
                                                  emoji: item.category.contains('Coffee') ? '☕' : '🍰',
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 4,
                                              left: 4,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: const Text(
                                                  '⚡ 10 MINS',
                                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              if (item.offerText != null)
                                                Container(
                                                  margin: const EdgeInsets.only(bottom: 4),
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.zeptoPink.withOpacity(0.12),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    item.offerText!,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.zeptoPink,
                                                    ),
                                                  ),
                                                ),
                                              Text(
                                                item.name,
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                item.description,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '₹${item.price.toStringAsFixed(0)}',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 15,
                                                    ),
                                                  ),

                                                  // Zepto ADD button / incrementer
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
                                      ],
                                    ),
                                  ),
                                ),
                              ).animate().fadeIn(duration: 400.ms, delay: (index * 40).ms).slideY(begin: 0.2, end: 0);
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
