import 'package:flutter/foundation.dart';

/// Evento de aplicación para notificar que la sesión del usuario ya no es
/// válida en el servidor (refresh token rechazado).
///
/// `AuthInterceptor` incrementa [sessionExpired] cuando el backend rechaza
/// tanto el access token como el refresh token. La capa de navegación
/// (BusTrackNavigationCoordinator) escucha este notifier y regresa al login.
class SessionEvents {
  SessionEvents._();

  static final ValueNotifier<int> sessionExpired = ValueNotifier<int>(0);

  static void notifySessionExpired() {
    sessionExpired.value = sessionExpired.value + 1;
  }
}
