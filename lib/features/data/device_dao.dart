import 'package:projeto_704apps/features/models/device.dart';

abstract class DeviceDao {
  Future<Device?> registerDevice(Device device, {required String token});
  Future<List<Device>> getDevices({required String token});
  Future<bool> preRegisterDevice(Device device, {required String token});
  getdeviceById(int id, {required String token});
  Future<bool> updateDevice(Device device, String id, {required String token});
  Future<bool> registerDeviceConfig(Device device, {required String token});
  getConfigSerialNumber(String serialNumber, {required String token});
  Future<bool> updateSerialNumber(String serialNumber, {required String token});
  Future<bool> registerDeviceFilter(Device device, {required String token});
  getVersionSerialNumber(String serialNumber, {required String token});
}
