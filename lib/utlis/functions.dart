import 'package:flutter_address_from_latlng/flutter_address_from_latlng.dart';

getAddress(double lat, double long) async {
  String formattedAddress =
      await FlutterAddressFromLatLng().getFormattedAddress(
    latitude: lat,
    longitude: long,
    googleApiKey: 'AIzaSyDdXaMN5htLGHo8BkCfefPpuTauwHGXItU',
  );

  return formattedAddress;
}
