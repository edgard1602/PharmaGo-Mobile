import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../model/pharmacie.dart';

class PharmacieRepository {
  PharmacieRepository({
    required SharedPreferences prefs,
    Dio? dio,
  })  : _prefs = prefs,
        _dio = dio ?? ApiClient.instance.dio;

  final SharedPreferences _prefs;
  final Dio _dio;

  Future<List<Pharmacie>> getPharmaciesParGeoloc({
    required double latitude,
    required double longitude,
  }) async {
    return _fetchAndCache(
      queryParameters: {'latitude': latitude, 'longitude': longitude},
    );
  }

  Future<List<Pharmacie>> getPharmaciesParQuartier(String quartier) async {
    return _fetchAndCache(
      queryParameters: {'quartier': quartier},
    );
  }

  Future<List<Pharmacie>> getAllPharmaciesGarde() async {
    return _fetchAndCache();
  }

  Future<Pharmacie> getPharmacieById(int id) async {
    try {
      final response = await _dio.get('/pharmacies/$id');
      return Pharmacie.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    } catch (_) {
      throw const ParseException();
    }
  }

  Future<List<String>> getQuartiers() async {
    try {
      final response = await _dio.get('/pharmacies/quartiers');
      return (response.data as List).cast<String>();
    } on DioException catch (e) {
      throw ApiClient.handleError(e);
    }
  }

  Future<List<Pharmacie>> getPharmaciesFromCache() async {
    final raw = _prefs.getString(AppConstants.cachePharmaciesKey);
    if (raw == null) throw const CacheEmptyException();

    try {
      final list = jsonDecode(raw) as List;
      return list
          .map((e) => Pharmacie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      throw const ParseException();
    }
  }

  DateTime? get lastCacheUpdate {
    final ts = _prefs.getInt(AppConstants.cacheLastUpdateKey);
    if (ts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ts);
  }

  Future<List<Pharmacie>> _fetchAndCache({
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        '/pharmacies/garde',
        queryParameters: queryParameters,
      );

      final pharmacies = (response.data as List)
          .map((e) => Pharmacie.fromJson(e as Map<String, dynamic>))
          .toList();

      await _saveToCache(pharmacies);
      return pharmacies;
    } on DioException catch (e) {
      final cached = _prefs.getString(AppConstants.cachePharmaciesKey);
      if (cached != null) return getPharmaciesFromCache();
      throw ApiClient.handleError(e);
    } catch (_) {
      throw const ParseException();
    }
  }

  Future<void> _saveToCache(List<Pharmacie> pharmacies) async {
    final encoded = jsonEncode(pharmacies.map((p) => p.toJson()).toList());
    await _prefs.setString(AppConstants.cachePharmaciesKey, encoded);
    await _prefs.setInt(
      AppConstants.cacheLastUpdateKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}