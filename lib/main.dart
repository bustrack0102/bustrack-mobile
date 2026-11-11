import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_verification_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/home/presentation/screens/home_demo_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
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

/// Coordinador de estado de navegación para el flujo de las primeras pantallas.
class BusTrackNavigationCoordinator extends StatefulWidget {
  const BusTrackNavigationCoordinator({super.key});

  @override
  State<BusTrackNavigationCoordinator> createState() =>
      _BusTrackNavigationCoordinatorState();
}

enum AppScreenState {
  splash,
  register,
  otpVerification,
  login,
  homeDemo,
}

class _BusTrackNavigationCoordinatorState
    extends State<BusTrackNavigationCoordinator> {
  AppScreenState _currentScreen = AppScreenState.splash;
  String _pendingVerificationEmail = 'usuario@ejemplo.com';
  bool _isDemoMode = false;

  void _navigateTo(AppScreenState screen) {
    setState(() => _currentScreen = screen);
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentScreen) {
      case AppScreenState.splash:
        return SplashScreen(
          onStart: () => _navigateTo(AppScreenState.login),
        );

      case AppScreenState.register:
        return RegisterScreen(
          onLoginTap: () => _navigateTo(AppScreenState.login),
          onRegisterSuccess: (email) {
            _pendingVerificationEmail = email;
            _navigateTo(AppScreenState.otpVerification);
          },
          onDemoTap: () {
            _isDemoMode = true;
            _navigateTo(AppScreenState.homeDemo);
          },
        );

      case AppScreenState.otpVerification:
        return OtpVerificationScreen(
          email: _pendingVerificationEmail,
          onBack: () => _navigateTo(AppScreenState.register),
          onEditEmail: () => _navigateTo(AppScreenState.register),
          onVerificationSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Correo verificado con éxito! Inicia sesión para continuar.'),
              ),
            );
            _navigateTo(AppScreenState.login);
          },
        );

      case AppScreenState.login:
        return LoginScreen(
          onRegisterTap: () => _navigateTo(AppScreenState.register),
          onLoginSuccess: () {
            _isDemoMode = false;
            _navigateTo(AppScreenState.homeDemo);
          },
          onForgotPasswordTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Se ha enviado un enlace de recuperación a tu correo.'),
              ),
            );
          },
          onDemoTap: () {
            _isDemoMode = true;
            _navigateTo(AppScreenState.homeDemo);
          },
        );

      case AppScreenState.homeDemo:
        return HomeDemoScreen(
          isDemoMode: _isDemoMode,
          onLogout: () => _navigateTo(AppScreenState.login),
        );
    }
  }
}

