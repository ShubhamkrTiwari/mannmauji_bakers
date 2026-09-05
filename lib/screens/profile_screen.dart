import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Zepto-style User Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.goldAccent.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 36, color: AppColors.goldAccent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bakery Connoisseur',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '+91 8401545654',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.goldAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '🔥 ${appState.orderStreak}-Week Streak Active',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.goldAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Zepto Cash / Bakery Wallet Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navyPrimary, AppColors.navySecondary],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: AppColors.goldAccent, size: 28),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Baker’s Cash Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        SizedBox(height: 2),
                        Text('₹150.00', style: TextStyle(color: AppColors.goldLight, fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: AppColors.navyPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Baker’s Cash can be applied on checkout! 🪙')),
                    );
                  },
                  child: const Text('Add Cash', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Zepto-style Menu Options List
          const Text(
            'Account & Settings',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileTile(
                  context,
                  icon: Icons.receipt_long,
                  title: 'Your Orders & History',
                  subtitle: '${appState.pastOrders.length} past orders placed',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.local_fire_department,
                  title: 'Milestone Badges & Streaks',
                  subtitle: '${appState.badges.where((b) => b.isUnlocked).length} badges unlocked',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Saved Delivery Addresses',
                  subtitle: 'Home, Office & Cafe Dine-in',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.card_giftcard,
                  title: 'Refer a Friend (Get ₹50 Off)',
                  subtitle: 'Code: MANN50',
                  onTap: () {
                    Share.share('Hey! Order delicious cheesecakes & waffles from Mannmauji Bakers using my invite code MANN50 and we both get ₹50 off! 🥐🍰');
                  },
                ),
                const Divider(height: 1, indent: 56),
                // Dark Mode Switch Tile
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.goldAccent),
                  title: const Text('Dark Appearance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text(isDark ? 'Dark Theme Active' : 'Light Theme Active', style: const TextStyle(fontSize: 12)),
                  value: isDark,
                  activeColor: AppColors.goldAccent,
                  onChanged: (val) {
                    appState.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildProfileTile(
                  context,
                  icon: Icons.phone_in_talk_outlined,
                  title: 'Bakery Support & Contact',
                  subtitle: 'Call 8401545654',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Calling Mannmauji Bakers support: 8401545654 📞')),
                    );
                  },
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
      leading: Icon(icon, color: AppColors.goldAccent),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }
}
