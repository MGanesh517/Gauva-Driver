import 'package:dio/dio.dart';

class GooglePlacesService {
  final Dio _dio = Dio();
  // Using the API key provided in the user's HTML tool
  final String _apiKey = 'AIzaSyA4l8wJ5bYRj_iPcaWF1TTuPt5KVDGMFpo';
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<Map<String, dynamic>>> getPlacePredictions(String input) async {
    if (input.isEmpty) return [];

    try {
      final response = await _dio.get(
        '$_baseUrl/autocomplete/json',
        queryParameters: {
          'input': input,
          'key': _apiKey,
          'components': 'country:in', // Restrict to India as per app context
        },
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final predictions = response.data['predictions'] as List;
        return predictions
            .map(
              (e) => {
                'description': e['description'],
                'place_id': e['place_id'],
                'main_text': e['structured_formatting']['main_text'],
                'secondary_text': e['structured_formatting']['secondary_text'],
              },
            )
            .toList();
      }
      return [];
    } catch (e) {
      print('Google Places Error: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/details/json',
        queryParameters: {'place_id': placeId, 'key': _apiKey, 'fields': 'geometry,formatted_address,name'},
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final result = response.data['result'];
        final location = result['geometry']['location'];
        return {
          'lat': location['lat'],
          'lng': location['lng'],
          'address': result['formatted_address'],
          'name': result['name'],
        };
      }
      return null;
    } catch (e) {
      print('Google Place Details Error: $e');
      return null;
    }
  }
}
