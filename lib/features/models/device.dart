class Device {
  String? deviceId;
  String? serialNumber;
  String? command;

  Device({
    this.deviceId,
    this.serialNumber,
    this.command
  });

  Map<String, dynamic> toJson() {
    return {
      'serialNumber': serialNumber,
      'command': command,
      'deviceId': deviceId
    };
  }

  factory Device.fromjson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['deviceId']?.toString(),
      serialNumber: json['serialNumber'],
     command: json['command']?.toString()
    );
  }
}
