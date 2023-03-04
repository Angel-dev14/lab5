import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab5/.env.dart';

import '../model/directions.dart';

class GoogleDirections {
  static const String _apiUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  late final Dio _dio;

  GoogleDirections({Dio? dio}) {
    _dio = dio ?? Dio();
  }

  Future<Directions?> getDirections(
      {required LatLng start, required LatLng end}) async {
    final response = await _dio.get(_apiUrl, queryParameters: {
      'origin': '${start.latitude},${start.longitude}',
      'destination': '${end.latitude}, ${end.longitude}',
      'key': googleAPIKey
    });

    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
