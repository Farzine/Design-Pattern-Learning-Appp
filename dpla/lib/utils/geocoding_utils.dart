// lib/utils/geocoding_utils.dart
import 'package:geocoding/geocoding.dart';

class GeocodingUtils {
  /// Converts latitude and longitude to a human-readable address.
  static Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        // Construct the address string
        String address = '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        return address;
      } else {
        return 'Unknown Location';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }
}
