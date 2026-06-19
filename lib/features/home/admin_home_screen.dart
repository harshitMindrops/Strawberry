import 'package:apip/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.pending_actions),
            title: const Text('Pending Requests'),
            onTap: () => context.push('/admin-pending'),
          ),
          ListTile(
            leading: const Icon(Icons.checklist),
            title: const Text('Mark Attendance'),
            onTap: () => context.push('/admin-attendance'),
          ),
        ],
      ),
    );
  }
}