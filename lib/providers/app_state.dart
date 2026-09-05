import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/menu_item.dart';
import '../models/menu_data.dart';
import '../models/order_model.dart';

class AppState with ChangeNotifier {
  AppState() {
    fetchCurrentLocation();
  }

  // Theme Mode
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  // User Profile Info
  String _userName = 'Bakery Connoisseur';
  String get userName => _userName;
  String _userPhone = '+91 8401545654';
  String get userPhone => _userPhone;

  void updateUserProfile(String name, String phone) {
    _userName = name;
    _userPhone = phone;
    notifyListeners();
  }

  // Location & 10-12 min Delivery
  String _currentAddress = 'Gaur City 1, Greater Noida West, Noida Extension';
  String get currentAddress => _currentAddress;
  String _deliveryEta = '10-12 MINS';
  String get deliveryEta => _deliveryEta;
  bool _isFetchingLocation = false;
  bool get isFetchingLocation => _isFetchingLocation;

  Future<void> fetchCurrentLocation() async {
    HapticFeedback.lightImpact();
    _isFetchingLocation = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _currentAddress = 'Gaur City 1, Greater Noida West, Noida Extension';
        _deliveryEta = '10-12 MINS';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _currentAddress = 'Gaur City 1, Greater Noida West, Noida Extension';
          _deliveryEta = '10-12 MINS';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _currentAddress = 'Gaur City 1, Greater Noida West, Noida Extension';
        _deliveryEta = '10-12 MINS';
        return;
      }

      // Fetch High Precision GPS Position (Best Accuracy)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
        ),
      );

      // Reverse Geocode GPS Lat/Long to exact Placemark
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        List<String> addressParts = [];

        if (place.name != null && place.name!.isNotEmpty && place.name != place.locality) {
          addressParts.add(place.name!);
        }
        if (place.street != null && place.street!.isNotEmpty && !addressParts.contains(place.street)) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          addressParts.add(place.postalCode!);
        }

        if (addressParts.isNotEmpty) {
          _currentAddress = addressParts.join(', ');
          _deliveryEta = '10-12 MINS';
        }
      }
    } catch (e) {
      // Fallback network lookup or Gaur City default
      _currentAddress = 'Gaur City 1, Greater Noida West, Noida Extension';
      _deliveryEta = '10-12 MINS';
    } finally {
      _isFetchingLocation = false;
      notifyListeners();
    }
  }

  void setAddress(String address, String eta) {
    _currentAddress = address;
    _deliveryEta = eta;
    notifyListeners();
  }

  // Cart
  final List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  double get cartSubtotal {
    return _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get cartDiscount {
    // Basic automatic discount rule based on menu offers
    double discount = 0;
    for (var item in _cartItems) {
      if (item.menuItem.offerText != null && item.quantity >= 2) {
        discount += 30.0 * (item.quantity ~/ 2);
      }
    }
    return discount;
  }

  double get deliveryFee => _cartItems.isEmpty ? 0.0 : 40.0;
  double get cartTotal => (cartSubtotal - cartDiscount + (cartSubtotal > 0 ? deliveryFee : 0)).clamp(0, double.infinity);

  void addToCart(MenuItem item, {int quantity = 1, String? customNote}) {
    HapticFeedback.lightImpact();
    final index = _cartItems.indexWhere((ci) => ci.menuItem.id == item.id && ci.customNote == customNote);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItem(menuItem: item, quantity: quantity, customNote: customNote));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem cartItem, int delta) {
    HapticFeedback.lightImpact();
    cartItem.quantity += delta;
    if (cartItem.quantity <= 0) {
      _cartItems.remove(cartItem);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Orders & Tracking
  final List<OrderModel> _pastOrders = [
    OrderModel(
      id: 'MB-1048',
      items: [
        CartItem(menuItem: menuItems[0], quantity: 1),
        CartItem(menuItem: menuItems[10], quantity: 2),
      ],
      totalAmount: 249.0,
      orderTime: DateTime.now().subtract(const Duration(days: 3)),
      status: OrderStatus.delivered,
      orderType: 'Delivery',
    ),
  ];
  List<OrderModel> get pastOrders => List.unmodifiable(_pastOrders);

  OrderModel? _activeOrder;
  OrderModel? get activeOrder => _activeOrder;

  void placeOrder({required String orderType, DateTime? scheduledTime}) {
    HapticFeedback.lightImpact();
    if (_cartItems.isEmpty) return;

    final newOrder = OrderModel(
      id: 'MB-${1050 + _pastOrders.length}',
      items: List.from(_cartItems),
      totalAmount: cartTotal,
      orderTime: DateTime.now(),
      status: OrderStatus.received,
      orderType: orderType,
      scheduledTime: scheduledTime,
    );

    _activeOrder = newOrder;
    _pastOrders.insert(0, newOrder);
    _cartItems.clear();
    notifyListeners();

    // Simulate order progress stages for story view / tracking
    _simulateOrderProgress();
  }

  void _simulateOrderProgress() async {
    await Future.delayed(const Duration(seconds: 4));
    if (_activeOrder != null) {
      _activeOrder = OrderModel(
        id: _activeOrder!.id,
        items: _activeOrder!.items,
        totalAmount: _activeOrder!.totalAmount,
        orderTime: _activeOrder!.orderTime,
        status: OrderStatus.baking,
        orderType: _activeOrder!.orderType,
        scheduledTime: _activeOrder!.scheduledTime,
      );
      notifyListeners();
    }

    await Future.delayed(const Duration(seconds: 5));
    if (_activeOrder != null) {
      _activeOrder = OrderModel(
        id: _activeOrder!.id,
        items: _activeOrder!.items,
        totalAmount: _activeOrder!.totalAmount,
        orderTime: _activeOrder!.orderTime,
        status: OrderStatus.packing,
        orderType: _activeOrder!.orderType,
        scheduledTime: _activeOrder!.scheduledTime,
      );
      notifyListeners();
    }

    await Future.delayed(const Duration(seconds: 5));
    if (_activeOrder != null) {
      _activeOrder = OrderModel(
        id: _activeOrder!.id,
        items: _activeOrder!.items,
        totalAmount: _activeOrder!.totalAmount,
        orderTime: _activeOrder!.orderTime,
        status: OrderStatus.ready,
        orderType: _activeOrder!.orderType,
        scheduledTime: _activeOrder!.scheduledTime,
      );
      notifyListeners();
    }
  }

  // Gamified Loyalty Streaks & Badges
  int get orderStreak => 3; // e.g. 3-week streak
  final List<BadgeItem> badges = [
    BadgeItem(id: '1', title: 'First Bite', description: 'Placed your first order at Mannmauji', icon: '🎉', isUnlocked: true),
    BadgeItem(id: '2', title: 'Sweet Tooth', description: 'Tried all Cheesecake varieties', icon: '🍰', isUnlocked: true),
    BadgeItem(id: '3', title: 'Cafe Regular', description: 'Ordered 10+ times', icon: '⭐', isUnlocked: false),
    BadgeItem(id: '4', title: 'Waffle Wizard', description: 'Ordered 5 different waffles', icon: '🧇', isUnlocked: false),
  ];

  // Weather Awareness (Hot vs Cool/Rainy)
  bool isHotDay = true; // Toggleable or mock weather
  void toggleWeather() {
    isHotDay = !isHotDay;
    notifyListeners();
  }

  // Dietary filter
  String selectedFilter = 'All'; // All, Veg, Contains nuts, Gluten-free, Egg-free
  void setFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
