class Device {
  String deviceId;
  String command;
  String serialNumber;

  Device({
    required this.deviceId,
    required this.command,
    required this.serialNumber,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'devideId': deviceId,
      'command': command,
      'SerialNumber': serialNumber,
    };
  }

  factory Device.fromjson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId'],
      command: json['command'],
      serialNumber: json['serialNumber'],
    );
  }
}
