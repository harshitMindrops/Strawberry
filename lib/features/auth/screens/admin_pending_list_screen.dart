import 'package:apip/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final pendingStudentsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.read(authRepositoryProvider).getPendingStudents();
});

class AdminPendingListScreen extends ConsumerWidget {
  const AdminPendingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingStudentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(pendingStudentsProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(pendingStudentsProvider),
        child: pendingAsync.when(
          data: (students) {
            if (students.isEmpty) return const Center(child: Text('Koi pending request nahi hai'));
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text(student['email']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin-approve', extra: student),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}