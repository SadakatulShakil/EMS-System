class AttendanceDataModel {
  int? id; // Add an ID for database primary key
  String user_id;
  String latitude;
  String longitude;
  int timestamp;
  String date;
  String status;

  AttendanceDataModel({
    this.id,
    required this.user_id,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.date,
    required this.status,
  });

  // Named constructor for null initialization
  AttendanceDataModel.nullConstructor()
      : id = null,
        user_id = '',
        latitude = '',
        longitude = '',
        timestamp = 0,
        date = '',
        status = '';

  // Rest of your class code...

  // Convert a User Data Model to a Map
  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
      'date': date,
      'status': status,
    };
  }

  // Create a User Data Model from a Map
  factory AttendanceDataModel.fromMap(Map<String, dynamic> map) {
    return AttendanceDataModel(
      id: map['id'],
      user_id: map['user_id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: map['timestamp'],
      date: map['date'],
      status: map['status'],
    );
  }

  @override
  String toString() {
    return 'AttendanceDataModel{id: $id, user_id: $user_id, latitude: $latitude, longitude: $longitude, timestamp: $timestamp, date: $date, status: $status}';
  }
}
