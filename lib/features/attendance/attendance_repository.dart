import 'package:apip/features/auth/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceRepository {
  final Dio dio;
  AttendanceRepository(this.dio);

  Future<List<Map<String, dynamic>>> getStudents(String type) async {
    final res = await dio.get('/attendance/students', queryParameters: {'type': type});
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<void> markAttendance(String date, List<Map<String, dynamic>> records) async {
    await dio.post('/attendance/mark', data: {'date': date, 'records': records});
  }

  Future<List<Map<String, dynamic>>> getHistory(int studentId) async {
    final res = await dio.get('/attendance/$studentId');
    return List<Map<String, dynamic>>.from(res.data);
  }
  Future<List<Map<String, dynamic>>> getStudentsByDate(String date, String type) async {
    final res = await dio.get('/attendance/by-date', queryParameters: {'date': date, 'type': type});
    return List<Map<String, dynamic>>.from(res.data);
  }
}

final attendanceRepositoryProvider = Provider((ref) => AttendanceRepository(ref.read(dioProvider)));