import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../model/signalement.dart';

class SignalementRepository {
  SignalementRepository({Dio? dio})
      : _dio = dio ?? ApiClient.instance.dio;

  final Dio _dio;

  Future<void> envoyer(Signalement signalement) async {
    try {
      await _dio.post(
        '/signalements',
        data: signalement.toJson(),
      );
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }
}