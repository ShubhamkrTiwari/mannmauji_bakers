import 'menu_item.dart';

enum OrderStatus { received, baking, packing, ready, delivered }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime orderTime;
  final OrderStatus status;
  final String orderType; // 'Delivery', 'Pickup', 'Dine-in'
  final DateTime? scheduledTime;

  OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderTime,
    required this.status,
    required this.orderType,
    this.scheduledTime,
  });
}

class BadgeItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;

  BadgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}
