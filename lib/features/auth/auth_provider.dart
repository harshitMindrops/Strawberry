import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'user_model.dart';
import 'auth_repository.dart';
import '../../core/storage/token_storage.dart';
import '../../core/network/dio_client.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());
final dioProvider = Provider<Dio>((ref) => createDio(ref.read(tokenStorageProvider)));
final authRepositoryProvider = Provider((ref) =>
    AuthRepository(ref.read(dioProvider), ref.read(tokenStorageProvider)));

class AuthState {
  final UserModel? user;
  final bool isLoading;
  AuthState({this.user, this.isLoading = true});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repo;
  AuthNotifier(this.repo) : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await repo.tokenStorage.getToken();
    if (token == null) {
      state = AuthState(isLoading: false);
      return;
    }
    final user = await repo.getCurrentUser();
    state = AuthState(user: user, isLoading: false);
  }

  Future<void> login(String email, String password) async {
    final user = await repo.login(email, password);
    state = AuthState(user: user, isLoading: false);
  }

  void logout() {
    repo.tokenStorage.deleteToken();
    state = AuthState(user: null, isLoading: false);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(authRepositoryProvider)),
);