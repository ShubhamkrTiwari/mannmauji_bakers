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
      appBar: AppBar(
        title: const Text('Our Bakery Menu'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshMenu,
        color: AppColors.goldAccent,
        child: _isLoading
            ? const ShimmerLoading()
            : Column(
                children: [
                  // Search Bar & Filters
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          onChanged: (val) => setState(() => _searchQuery = val),
                          decoration: InputDecoration(
                            hintText: 'Search cheesecakes, brownies, waffles...',
                            prefixIcon: const Icon(Icons.search, color: AppColors.goldAccent),
                            filled: true,
                            fillColor: isDark ? AppColors.darkSurface : Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Dietary filter chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: dietaryFilters.map((filter) {
                              final isSelected = appState.selectedFilter == filter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    appState.setFilter(selected ? filter : 'All');
                                  },
                                  selectedColor: AppColors.goldAccent,
                                  labelStyle: TextStyle(
                                    color: isSelected && !isDark ? AppColors.navyPrimary : null,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() => _selectedCategory = cat);
                            },
                            selectedColor: AppColors.navyPrimary,
                            labelStyle: TextStyle(
                              color: isSelected ? AppColors.goldLight : null,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                                const Icon(Icons.bakery_dining, size: 64, color: Colors.grey),
                              const SizedBox(height: 12),
                              const Text(
                                'Oops! No sweet treats found matching your craving.',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try searching for something else or reset filters.',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CustomPageRoute(child: ProductDetailScreen(item: item)),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
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
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 95,
                                          height: 95,
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                            child: BakeryImagePlaceholder(
                                              heroTag: 'item_${item.id}',
                                              title: item.name,
                                              imageUrl: item.imageUrl,
                                              emoji: item.category.contains('Coffee') ? '☕' : '🍰',
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                if (item.offerText != null)
                                                  Text(
                                                    item.offerText!,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppColors.softRed,
                                                    ),
                                                  ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  item.description,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '₹${item.price.toStringAsFixed(0)}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
                                                        color: isDark ? AppColors.goldLight : AppColors.navyPrimary,
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        minimumSize: Size.zero,
                                                      ),
                                                      onPressed: () {
                                                        appState.addToCart(item);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: Text('Added ${item.name} to cart! 🥐'),
                                                            duration: const Duration(milliseconds: 1000),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text('Add', style: TextStyle(fontSize: 12)),
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
