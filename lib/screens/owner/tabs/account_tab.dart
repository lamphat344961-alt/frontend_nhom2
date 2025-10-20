// lib/screens/owner/tabs/account_tab.dart
import 'package:flutter/material.dart';
import 'package:frontend_nhom2/screens/auth/login_screen.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  String _fullName = 'Đang tải...';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fullName = await TokenManager.getFullName();
    final role = await TokenManager.getRole();
    if (mounted) {
      setState(() {
        _fullName = fullName ?? 'Không xác định';
        _role = role ?? 'Chưa có vai trò';
      });
    }
  }

  void _logout() async {
    await TokenManager.clearAll();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Tài Khoản Của Tôi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Profile Header ---
            Card(
              elevation: 4,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary.withAlpha(50),
                      child: Text(
                        _fullName.isNotEmpty ? _fullName[0].toUpperCase() : 'A',
                        style: TextStyle(fontSize: 40, color: theme.colorScheme.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _fullName,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Chip(
                      label: Text(_role),
                      backgroundColor: theme.colorScheme.primaryContainer.withAlpha(100),
                      labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                      side: BorderSide.none,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // --- Options Section ---
            _buildSectionTitle('Cài đặt'),
            _buildOptionCard(
              context,
              icon: Icons.edit_outlined,
              title: 'Chỉnh sửa thông tin',
              onTap: () { /* TODO: Navigate to Edit Profile screen */ },
            ),
            _buildOptionCard(
              context,
              icon: Icons.notifications_outlined,
              title: 'Thông báo',
              onTap: () { /* TODO: Navigate to Notifications screen */ },
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Thông tin'),
            _buildOptionCard(
              context,
              icon: Icons.help_outline,
              title: 'Trợ giúp & Phản hồi',
              onTap: () { /* TODO: Navigate to Help screen */ },
            ),
            _buildOptionCard(
              context,
              icon: Icons.info_outline,
              title: 'Về ứng dụng',
              onTap: () { /* TODO: Navigate to About screen */ },
            ),

            const SizedBox(height: 40),

            // --- Logout Button ---
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Đăng Xuất'),
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }
}

