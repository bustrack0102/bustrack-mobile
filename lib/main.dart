import 'package:flutter/material.dart';
import 'core/network/session_events.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
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

/// Coordinador de estado de navegación para el flujo de la aplicación.
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
  mainShell,
}

class _BusTrackNavigationCoordinatorState
    extends State<BusTrackNavigationCoordinator> {
  AppScreenState _currentScreen = AppScreenState.splash;
  bool _isDemoMode = false;
  final _authRepository = AuthRepositoryImpl();

  @override
  void initState() {
    super.initState();
    // Si el interceptor detecta que el refresh token fue rechazado,
    // devolver al usuario al login con un aviso explícito.
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
      // En plataformas/tests sin el plugin de secure storage, fallar como "sin sesión".
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
          // El registro en la API ya devuelve tokens y el repositorio los
          // guarda: el usuario queda autenticado; no hay paso OTP en el backend.
          onRegisterSuccess: (_) {
            _isDemoMode = false;
            _navigateTo(AppScreenState.mainShell);
          },
          onDemoTap: () {
            _isDemoMode = true;
            _navigateTo(AppScreenState.mainShell);
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
            showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Recuperar contraseña'),
                content: const Text(
                  'La recuperación de contraseña aún no está disponible '
                  'en el servidor. Si perdiste el acceso a tu cuenta, '
                  'contacta al administrador del sistema.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Entendido'),
                  ),
                ],
              ),
            );
          },
          onDemoTap: () {
            _isDemoMode = true;
            _navigateTo(AppScreenState.mainShell);
          },
        );

      case AppScreenState.mainShell:
        return MainShellScreen(
          isDemoMode: _isDemoMode,
          onLogout: () => _navigateTo(AppScreenState.login),
        );
    }
  }
}
