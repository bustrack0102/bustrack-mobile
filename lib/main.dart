import 'package:flutter/material.dart';

import 'core/network/session_events.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/screens/email_verification_screen.dart';
import 'features/auth/presentation/screens/email_verified_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/demo/presentation/screens/demo_shell_screen.dart';
import 'features/home/presentation/screens/main_shell_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BusTrackApp());
}

/// Aplicación principal BusTrack Mobile.
class BusTrackApp extends StatelessWidget {
  const BusTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BusTrack Mobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const BusTrackNavigationCoordinator(),
    );
  }
}

/// Coordinador central de navegación y estado de flujo de BusTrack.
class BusTrackNavigationCoordinator extends StatefulWidget {
  const BusTrackNavigationCoordinator({super.key});

  @override
  State<BusTrackNavigationCoordinator> createState() =>
      _BusTrackNavigationCoordinatorState();
}

enum AppScreenState {
  splash,
  register,
  login,
  emailVerification,
  emailVerified,
  forgotPassword,
  resetPassword,
  mainShell,
  demoShell,
}

class _BusTrackNavigationCoordinatorState
    extends State<BusTrackNavigationCoordinator> {
  AppScreenState _currentScreen = AppScreenState.splash;
  bool _isDemoMode = false;
  String _pendingVerificationEmail = '';
  String _passwordRecoveryEmail = '';
  final _authRepository = AuthRepositoryImpl();

  @override
  void initState() {
    super.initState();
    SessionEvents.sessionExpired.addListener(_onSessionExpired);
  }

  @override
  void dispose() {
    SessionEvents.sessionExpired.removeListener(_onSessionExpired);
    super.dispose();
  }

  void _onSessionExpired() {
    if (!mounted) return;
    if (_currentScreen == AppScreenState.login) return;
    _isDemoMode = false;
    _navigateTo(AppScreenState.login);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tu sesión expiró. Inicia sesión nuevamente.'),
      ),
    );
  }

  void _navigateTo(AppScreenState screen) {
    setState(() => _currentScreen = screen);
  }

  Future<void> _checkSessionAndNavigate() async {
    bool hasSession = false;
    try {
      hasSession = await _authRepository.hasActiveSession();
    } catch (_) {
      hasSession = false;
    }
    if (hasSession) {
      _isDemoMode = false;
      _navigateTo(AppScreenState.mainShell);
    } else {
      _navigateTo(AppScreenState.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreenState.splash:
        return SplashScreen(
          onStart: _checkSessionAndNavigate,
        );

      case AppScreenState.register:
        return RegisterScreen(
          onLoginTap: () => _navigateTo(AppScreenState.login),
          onRegisterSuccess: (email) {
            _pendingVerificationEmail = email;
            _navigateTo(AppScreenState.emailVerification);
          },
          onDemoTap: () {
            _navigateTo(AppScreenState.demoShell);
          },
        );

      case AppScreenState.emailVerification:
        return EmailVerificationScreen(
          email: _pendingVerificationEmail,
          onVerificationSuccess: () {
            _navigateTo(AppScreenState.emailVerified);
          },
          onBackToRegister: () => _navigateTo(AppScreenState.register),
          onEmailChanged: (newEmail) {
            _pendingVerificationEmail = newEmail;
          },
        );

      case AppScreenState.emailVerified:
        return EmailVerifiedScreen(
          onContinue: () {
            _navigateTo(AppScreenState.login);
          },
        );

      case AppScreenState.login:
        return LoginScreen(
          onRegisterTap: () => _navigateTo(AppScreenState.register),
          onLoginSuccess: () {
            _isDemoMode = false;
            _navigateTo(AppScreenState.mainShell);
          },
          onForgotPasswordTap: () {
            _navigateTo(AppScreenState.forgotPassword);
          },
          onDemoTap: () {
            _navigateTo(AppScreenState.demoShell);
          },
        );

      case AppScreenState.forgotPassword:
        return ForgotPasswordScreen(
          onBackToLogin: () => _navigateTo(AppScreenState.login),
          onCodeSent: (email) {
            _passwordRecoveryEmail = email;
            _navigateTo(AppScreenState.resetPassword);
          },
        );

      case AppScreenState.resetPassword:
        return ResetPasswordScreen(
          email: _passwordRecoveryEmail,
          onBack: () => _navigateTo(AppScreenState.forgotPassword),
          onResetSuccess: () => _navigateTo(AppScreenState.login),
        );

      case AppScreenState.mainShell:
        return MainShellScreen(
          isDemoMode: _isDemoMode,
          onLogout: () => _navigateTo(AppScreenState.login),
        );

      case AppScreenState.demoShell:
        return DemoShellScreen(
          onExitDemo: () {
            _navigateTo(AppScreenState.register);
          },
        );
    }
  }
}
