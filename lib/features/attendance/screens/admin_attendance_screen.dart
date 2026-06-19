import 'package:apip/features/attendance/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminAttendanceScreen extends ConsumerStatefulWidget {
  const AdminAttendanceScreen({super.key});
  @override
  ConsumerState<AdminAttendanceScreen> createState() => _AdminAttendanceScreenState();
}

class _AdminAttendanceScreenState extends ConsumerState<AdminAttendanceScreen> {
  DateTime? selectedDate;
  String? selectedType;
  Map<int, String> statusMap = {};
  List<Map<String, dynamic>> students = [];
  bool isLoading = false;
  bool hasLoaded = false;

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> loadStudents() async {
    if (selectedDate == null || selectedType == null) return;
    setState(() { isLoading = true; hasLoaded = false; });
    final result = await ref.read(attendanceRepositoryProvider)
        .getStudentsByDate(_formatDate(selectedDate!), selectedType!);
    setState(() {
      students = result;
      statusMap = {for (var s in result) s['id']: s['status'] ?? 'present'};
      isLoading = false;
      hasLoaded = true;
    });
  }

  Future<void> submitAttendance() async {
    final records = statusMap.entries.map((e) => {'student_id': e.key, 'status': e.value}).toList();
    await ref.read(attendanceRepositoryProvider).markAttendance(_formatDate(selectedDate!), records);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance marked')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Column(
        children: [
          ListTile(
            title: Text(selectedDate == null ? 'Date select karo' : 'Date: ${_formatDate(selectedDate!)}'),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context, initialDate: DateTime.now(),
                firstDate: DateTime(2024, 1, 1), lastDate: DateTime(2030, 12, 31),
              );
              if (picked != null) setState(() { selectedDate = picked; hasLoaded = false; });
            },
          ),
          DropdownButton<String>(
            value: selectedType,
            hint: const Text('Type select karo'),
            items: const [
              DropdownMenuItem(value: 'preschool', child: Text('Preschool')),
              DropdownMenuItem(value: 'daycare', child: Text('Daycare')),
            ],
            onChanged: (val) => setState(() { selectedType = val; hasLoaded = false; }),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: (selectedDate != null && selectedType != null) ? loadStudents : null,
              child: const Text('Students Dikhao'),
            ),
          ),
          if (isLoading) const CircularProgressIndicator(),
          if (hasLoaded)
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  final isPresent = statusMap[student['id']] == 'present';
                  return SwitchListTile(
                    title: Text(student['name']),
                    value: isPresent,
                    onChanged: (val) => setState(() => statusMap[student['id']] = val ? 'present' : 'absent'),
                  );
                },
              ),
            ),
          if (hasLoaded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(onPressed: submitAttendance, child: const Text('Submit')),
            ),
        ],
      ),
    );
  }
}