import 'package:apip/core/splash_screen/splash_screen.dart';
import 'package:apip/features/attendance/screens/admin_attendance_screen.dart';
import 'package:apip/features/auth/auth_provider.dart';
import 'package:apip/features/auth/screens/admin_approve_screen.dart';
import 'package:apip/features/auth/screens/admin_pending_list_screen.dart';
import 'package:apip/features/auth/screens/login_screen.dart';
import 'package:apip/features/auth/screens/pending_screen.dart';
import 'package:apip/features/auth/screens/signup_screen.dart';
import 'package:apip/features/home/admin_home_screen.dart';
import 'package:apip/features/home/student_home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {

      if (authState.isLoading) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final user = authState.user;
      final loggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/signup';

      if (user == null) return loggingIn ? null : '/login';
      if (user.status == 'pending') return '/pending';
      if (user.role == 'admin') {
        return state.matchedLocation.startsWith('/admin') ? null : '/admin-home';
      }
      return state.matchedLocation == '/student-home' ? null : '/student-home';
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/pending', builder: (context, state) => const PendingScreen()),
      GoRoute(path: '/student-home', builder: (context, state) => const StudentHomeScreen()),
      GoRoute(path: '/admin-home', builder: (context, state) => const AdminHomeScreen()),
      GoRoute(path: '/admin-pending', builder: (context, state) => const AdminPendingListScreen()),
      GoRoute(path: '/admin-attendance', builder: (context, state) => const AdminAttendanceScreen()),
      GoRoute(
        path: '/admin-approve',
        builder: (context, state) => AdminApproveScreen(student: state.extra as Map<String, dynamic>),
      ),
    ],
  );
});