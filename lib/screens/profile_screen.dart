import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditProfileSheet(BuildContext context, AppState appState) {
    final nameController = TextEditingController(text: appState.userName);
    final phoneController = TextEditingController(text: appState.userPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit Profile Details', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Full Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Phone Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.zeptoGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty && phoneController.text.trim().isNotEmpty) {
                    appState.updateUserProfile(nameController.text.trim(), phoneController.text.trim());
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully! ✨')),
                    );
                  }
                },
                child: const Text('Save Profile Changes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrdersHistorySheet(BuildContext context, AppState appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Order History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: appState.pastOrders.isEmpty
                    ? const Center(child: Text('No past orders yet!'))
                    : ListView.builder(
                        itemCount: appState.pastOrders.length,
                        itemBuilder: (context, index) {
                          final order = appState.pastOrders[index];
                          final formattedDate = DateFormat('dd MMM, yyyy • hh:mm a').format(order.orderTime);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 14),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBackground : AppColors.zeptoBackground,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Order #${order.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.zeptoGreenLight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text('DELIVERED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(formattedDate, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                const Divider(height: 16),
                                ...order.items.map((ci) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${ci.quantity}x ${ci.menuItem.name}', style: const TextStyle(fontSize: 12)),
                                          Text('₹${ci.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    )),
                                const Divider(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total: ₹${order.totalAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.zeptoGreen,
                                        side: const BorderSide(color: AppColors.zeptoGreen),
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.refresh, size: 14),
                                      label: const Text('Reorder', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        for (var item in order.items) {
                                          appState.addToCart(item.menuItem, quantity: item.quantity);
                                        }
                                        HapticFeedback.lightImpact();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Items re-ordered into your cart! 🛒')),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBadgesSheet(BuildContext context, AppState appState) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Milestone Badges & Rewards', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.zeptoGreenLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${appState.orderStreak}-Week Order Streak!', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.zeptoGreen)),
                        const Text('Keep ordering weekly to unlock exclusive discounts', style: TextStyle(fontSize: 11, color: AppColors.zeptoGreen)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...appState.badges.map((badge) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: badge.isUnlocked ? AppColors.zeptoGreen : AppColors.zeptoCardBorder),
                  ),
                  child: Row(
                    children: [
                      Text(badge.icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(badge.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text(badge.description, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: badge.isUnlocked ? AppColors.zeptoGreenLight : Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge.isUnlocked ? 'UNLOCKED ✅' : 'LOCKED 🔒',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badge.isUnlocked ? AppColors.zeptoGreen : Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bakery Support & Help', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.zeptoGreen),
                title: const Text('Call Support Hotline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('+91 8401545654 • Toll Free', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Mannmauji Bakers helpline: 8401545654 📞')),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline, color: AppColors.zeptoGreen),
                title: const Text('WhatsApp Chat Support', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                subtitle: const Text('Live order updates & order modifications', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening WhatsApp Support chat... 💬')),
                  );
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

    return Scaffold(
      appBar: AppTheme.buildGradientAppBar(
        context: context,
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.zeptoGreenLight,
                  child: const Icon(Icons.person, size: 32, color: AppColors.zeptoGreen),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.userName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appState.userPhone,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.zeptoGreenLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '🔥 ${appState.orderStreak}-Week Streak Active',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.zeptoGreen),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: AppColors.zeptoPurple, size: 20),
                  onPressed: () => _showEditProfileSheet(context, appState),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Stats Cards Row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showOrdersHistorySheet(context, appState),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                    ),
                    child: Column(
                      children: [
                        const Text('📦', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text('${appState.pastOrders.length} Orders', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Order History', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showBadgesSheet(context, appState),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                    ),
                    child: Column(
                      children: [
                        const Text('🏆', style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text('${appState.badges.where((b) => b.isUnlocked).length} Badges', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Streaks & Rewards', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
                  ),
                  child: Column(
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      const Text('10 MINS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text('Avg Speed', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Account & Settings Options List
          const Text(
            'Account & Preferences',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : AppColors.zeptoCardBorder),
            ),
            child: Column(
              children: [
                _buildProfileTile(
                  context,
                  icon: Icons.receipt_long_outlined,
                  title: 'Your Orders & History',
                  subtitle: 'View detailed receipts & reorder in 1-tap',
                  onTap: () => _showOrdersHistorySheet(context, appState),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.local_fire_department_outlined,
                  title: 'Milestone Badges & Streaks',
                  subtitle: '${appState.badges.where((b) => b.isUnlocked).length} badges unlocked • ${appState.orderStreak}-week streak',
                  onTap: () => _showBadgesSheet(context, appState),
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Saved Delivery Addresses',
                  subtitle: appState.currentAddress,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Current Active Address: ${appState.currentAddress}')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.card_giftcard_outlined,
                  title: 'Refer a Friend (Get ₹50 Off)',
                  subtitle: 'Invite Code: MANN50 (Tap to copy)',
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: 'MANN50'));
                    HapticFeedback.lightImpact();
                    Share.share('Order delicious cheesecakes & pastries from Mannmauji Bakers using invite code MANN50 and get ₹50 off! 🥐🍰');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invite code MANN50 copied to clipboard! 📋')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.zeptoPurple),
                  title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text(isDark ? 'Dark Appearance Active' : 'Light Appearance Active', style: const TextStyle(fontSize: 11)),
                  value: isDark,
                  activeColor: AppColors.zeptoGreen,
                  onChanged: (val) {
                    HapticFeedback.lightImpact();
                    appState.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.phone_in_talk_outlined,
                  title: 'Bakery Support & Contact',
                  subtitle: 'Call hotline 8401545654 or chat',
                  onTap: () => _showSupportSheet(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.zeptoPurple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}
