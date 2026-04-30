import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../error/app_exception.dart';
import 'package:flutter/foundation.dart';

/// Client HTTP centralisé.
/// POURQUOI Dio et pas http ?
/// → Interceptors natifs (on peut ajouter logs, auth, retry facilement)
/// → BaseOptions configurables une seule fois
/// → Gestion d'erreur plus précise
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor de logs en debug — retiré automatiquement en release
    assert(() {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => debugPrint('🌐 $obj'),
        ),
      );
      return true;
    }());
  }

  late final Dio _dio;

  /// Singleton — une seule instance dans toute l'app
  static final ApiClient instance = ApiClient._();

  Dio get dio => _dio;

  /// Convertit les DioException en AppException compréhensibles par l'UI
  static AppException handleError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError =>
        const NetworkException(),
      DioExceptionType.badResponse => ServerException(
          'Erreur ${e.response?.statusCode ?? 'inconnue'}',
        ),
      _ => const ServerException(),
    };
  }
}