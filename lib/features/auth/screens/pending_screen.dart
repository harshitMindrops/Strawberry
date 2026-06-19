import 'package:apip/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pendingStudentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(authRepositoryProvider).getPendingStudents();
});

class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.hourglass_empty, size: 64),
            const SizedBox(height: 16),
            const Text('Tumhari request admin approval ka wait kar rahi hai'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(authStateProvider.notifier).logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}