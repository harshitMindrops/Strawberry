import 'package:apip/features/attendance/attendance_repository.dart';
import 'package:apip/features/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentHomeScreen extends ConsumerStatefulWidget {
  const StudentHomeScreen({super.key});
  @override
  ConsumerState<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends ConsumerState<StudentHomeScreen> {
  Map<DateTime, String> attendanceMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    final user = ref.read(authStateProvider).user!;
    final records = await ref.read(attendanceRepositoryProvider).getHistory(user.id);
    setState(() {
      attendanceMap = {for (var r in records) DateTime.parse(r['date']): r['status']};
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TableCalendar(
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) => _dayCell(day),
              todayBuilder: (context, day, focusedDay) => _dayCell(day),
            ),
          )
    );
  }

  Widget _dayCell(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    final status = attendanceMap[key];
    Color? color;
    if (status == 'present') color = Colors.green.shade300;
    if (status == 'absent') color = Colors.red.shade300;
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text('${day.day}'),
    );
  }
}