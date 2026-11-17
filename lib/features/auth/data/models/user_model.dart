/// Modelo de Usuario devuelto por la API REST de BusTrack.
class UserModel {
  final String id;
  final String nombreCompleto;
  final String correo;
  final String rol;
  final String? fechaCreacion;
  final bool consentimientoSensoresActivo;
  final int totalViajesGuardados;
  final int totalCalificaciones;

  UserModel({
    required this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.rol,
    this.fechaCreacion,
    this.consentimientoSensoresActivo = false,
    this.totalViajesGuardados = 0,
    this.totalCalificaciones = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      nombreCompleto: json['nombreCompleto']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      rol: json['rol']?.toString() ?? 'Usuario',
      fechaCreacion: json['fechaCreacion']?.toString(),
      consentimientoSensoresActivo:
          json['consentimientoSensoresActivo'] == true,
      totalViajesGuardados:
          (json['totalViajesGuardados'] as num?)?.toInt() ?? 0,
      totalCalificaciones: (json['totalCalificaciones'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreCompleto': nombreCompleto,
      'correo': correo,
      'rol': rol,
      'fechaCreacion': fechaCreacion,
      'consentimientoSensoresActivo': consentimientoSensoresActivo,
      'totalViajesGuardados': totalViajesGuardados,
      'totalCalificaciones': totalCalificaciones,
    };
  }
}

/// Respuesta de autenticación recibida tras login o registro.
class AuthResponseModel {
  final UserModel? usuario;
  final String accessToken;
  final String refreshToken;
  final int? expiraEnSegundos;

  AuthResponseModel({
    this.usuario,
    required this.accessToken,
    required this.refreshToken,
    this.expiraEnSegundos,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      usuario:
          json['usuario'] != null && json['usuario'] is Map<String, dynamic>
              ? UserModel.fromJson(json['usuario'])
              : null,
      accessToken: json['accessToken']?.toString() ?? '',
      refreshToken: json['refreshToken']?.toString() ?? '',
      expiraEnSegundos: (json['expiraEnSegundos'] as num?)?.toInt(),
    );
  }
}
