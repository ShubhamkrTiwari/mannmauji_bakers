class MenuItem {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final List<String> tags; // e.g. ['Veg', 'Bestseller', 'Contains nuts', 'Gluten-free', 'Egg-free', 'Hot', 'Cold']
  final String? offerText; // e.g. 'BUY ANY 2 AND GET ₹30 OFF'
  final String imageUrl;

  const MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.tags,
    this.offerText,
    required this.imageUrl,
  });
}

class CartItem {
  final MenuItem menuItem;
  int quantity;
  final String? customNote;
  final Map<String, dynamic>? customizations; // For custom cake builder later

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.customNote,
    this.customizations,
  });

  double get totalPrice => menuItem.price * quantity;
}
