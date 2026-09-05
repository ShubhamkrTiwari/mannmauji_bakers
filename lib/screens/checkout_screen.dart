import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _orderType = 'Delivery'; // Delivery, Pickup, Dine-in
  bool _isScheduled = false;
  String _selectedTimeSlot = 'Today, 5:00 PM - 5:30 PM';
  
  final List<String> timeSlots = [
    'Today, 5:00 PM - 5:30 PM',
    'Today, 7:00 PM - 7:30 PM',
    'Tomorrow, 11:00 AM - 11:30 AM',
    'Tomorrow, 4:00 PM - 4:30 PM',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout & Scheduling'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Order Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: ['Delivery', 'Pickup', 'Dine-in'].map((type) {
                final isSelected = _orderType == type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Center(child: Text(type)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _orderType = type);
                      },
                      selectedColor: AppColors.navyPrimary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.goldLight : null,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Dine-in group ordering helper (Part 2 feature 6)
            if (_orderType == 'Dine-in') ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.goldAccent),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.group, color: AppColors.goldAccent),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Table Group Order', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Share code #MM-TABLE-7 with friends to join this cart!', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Table sharing code copied to clipboard! 📋')),
                        );
                      },
                      child: const Text('Share', style: TextStyle(color: AppColors.goldAccent)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scheduled / Pre-order',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Switch(
                  value: _isScheduled,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) => setState(() => _isScheduled = val),
                ),
              ],
            ),
            if (_isScheduled) ...[
              const SizedBox(height: 8),
              const Text(
                'Pick a future date & time slot for birthday cakes, bulk or festival orders:',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: timeSlots.map((slot) {
                  final isSelected = _selectedTimeSlot == slot;
                  return ChoiceChip(
                    label: Text(slot),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedTimeSlot = slot);
                    },
                    selectedColor: AppColors.goldAccent,
                    labelStyle: TextStyle(
                      color: isSelected && !isDark ? AppColors.navyPrimary : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.payment, color: AppColors.goldAccent),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Online Payment / UPI / Cards', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Google Pay, PhonePe, Paytm, Credit/Debit cards', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle, color: AppColors.successGreen),
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
            appState.placeOrder(
              orderType: _orderType,
              scheduledTime: _isScheduled ? DateTime.now().add(const Duration(hours: 3)) : null,
            );
            Navigator.pushReplacement(
              context,
              CustomPageRoute(child: const OrderTrackingScreen()),
            );
          },
          child: Text(
            'Place Order • ₹${appState.cartTotal.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
