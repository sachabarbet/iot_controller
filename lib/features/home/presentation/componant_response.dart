class Device {
  final String id;
  final String type;
  final String name;
  final String state;

  Device({
    required this.id,
    required this.type,
    required this.name,
    required this.state,
  });

  // Factory method to create a Device object from JSON
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      state: json['state'],
    );
  }

  // Convert a list of JSON objects into a list of Device objects
  static List<Device> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Device.fromJson(json)).toList();
  }
}
