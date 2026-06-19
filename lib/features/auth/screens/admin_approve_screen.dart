import 'package:apip/features/auth/auth_provider.dart';
import 'package:apip/features/auth/screens/admin_pending_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminApproveScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> student;
  const AdminApproveScreen({super.key, required this.student});

  @override
  ConsumerState<AdminApproveScreen> createState() => _AdminApproveScreenState();
}

class _AdminApproveScreenState extends ConsumerState<AdminApproveScreen> {
  final feesCtrl = TextEditingController();
  String selectedType = 'preschool';
  bool isLoading = false;

  Future<void> handleApprove() async {
    setState(() => isLoading = true);
    try {
      await ref.read(authRepositoryProvider).approveStudent(
        widget.student['id'], double.parse(feesCtrl.text), selectedType,
      );
      ref.invalidate(pendingStudentsProvider);
      if (mounted) context.pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Approve fail ho gaya')));
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.student['name'])),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: feesCtrl, keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monthly Fees')),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedType,
              items: const [
                DropdownMenuItem(value: 'preschool', child: Text('Preschool')),
                DropdownMenuItem(value: 'daycare', child: Text('Daycare')),
                DropdownMenuItem(value: 'both', child: Text('Both')),
              ],
              onChanged: (val) => setState(() => selectedType = val!),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: handleApprove, child: const Text('Approve')),
          ],
        ),
      ),
    );
  }
}