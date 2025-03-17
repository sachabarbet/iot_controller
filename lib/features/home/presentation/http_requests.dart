import 'dart:convert';
import 'package:http/http.dart' as http;
import 'componant_response.dart';

Future<List<Device>> fetchDevices() async {
  final url = Uri.parse('https://example.com/api/devices'); // Replace with your API URL

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return Device.fromJsonList(jsonData);
    } else {
      print('Failed to load data. Status Code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error: $e');
    return [];
  }
}

void main() async {
  List<Device> devices = await fetchDevices();
  for (var device in devices) {
    print('ID: ${device.id}, Type: ${device.type}, Name: ${device.name}, State: ${device.state}');
  }
}
