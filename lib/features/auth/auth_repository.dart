import 'package:dio/dio.dart';
import 'user_model.dart';
import '../../core/storage/token_storage.dart';

class AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;
  AuthRepository(this.dio, this.tokenStorage);

  Future<void> signup(String name, String email, String password) async {
    await dio.post('/auth/signup', data: {'name': name, 'email': email, 'password': password});
  }

  Future<UserModel> login(String email, String password) async {
    final res = await dio.post('/auth/login', data: {'email': email, 'password': password});
    await tokenStorage.saveToken(res.data['token']);
    return UserModel.fromJson(res.data['user']);
  }

  Future<List<Map<String, dynamic>>> getPendingStudents() async {
    final res = await dio.get('/admin/pending-students');
    return List<Map<String, dynamic>>.from(res.data);
  } 

  Future<void> approveStudent(int id, double fees, String type) async {
    await dio.post('/admin/approve-student/$id', data: {'fees': fees, 'type': type});
  }
  Future<UserModel?> getCurrentUser() async {
    try {
      final res = await dio.get('/auth/me');
      return UserModel.fromJson(res.data['user']);
    } catch (e) {
      return null;
    }
  }
}