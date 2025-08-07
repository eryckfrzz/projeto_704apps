import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/device.dart';
import 'package:projeto_704apps/services/remote/devices_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'device_store.g.dart';

class DeviceStore = _DeviceStore with _$DeviceStore;

abstract class _DeviceStore with Store {
  final DevicesDaoImpl service = DevicesDaoImpl();

  @observable
  Device? currentDevice;

  @observable
  ObservableList<Device> devices = ObservableList<Device>();

  @action
  Future<List<Device>?> fetchDevices() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final List<Device> fetchedDevices = await service.getDevices(
        token: token!,
      );

      devices.clear();
      devices.addAll(fetchedDevices);

      return fetchedDevices;
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao buscar dispositivos: $e');
      return null;
    }
  }

  @action
  Future<Device?> getDeviceById(int id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final Device? fetchedDevice = await service.getdeviceById(
        id,
        token: token!,
      );

      if (fetchedDevice != null) {
        currentDevice = fetchedDevice;
        return fetchedDevice;
      } else {
        print(
          'ERRO DEVICE_STORE: Dispositivo ID $id não encontrado ou erro na API.',
        );
        return null;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao buscar dispositivo ID $id: $e');
      return null;
    }
  }

  @action
  Future<Device?> getConfigBySerialNumber(String serialNumber) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final Device? fetchedConfigDevice = await service.getConfigSerialNumber(
        serialNumber,
        token: token!,
      );

      if (fetchedConfigDevice != null) {
        currentDevice = fetchedConfigDevice;

        return fetchedConfigDevice;
      } else {
        print(
          'ERRO DEVICE_STORE: Configuração para $serialNumber não encontrada ou erro na API.',
        );
        return null;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao buscar configuração: $e');
      return null;
    }
  }

  @action
  Future<Device?> getVersionBySerialNumber(String serialNumber) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      
      final Device? fetchedVersionDevice = await service.getVersionSerialNumber(
        serialNumber,
        token: token!,
      );

      if (fetchedVersionDevice != null) {
        currentDevice = fetchedVersionDevice;
        return fetchedVersionDevice;
      } else {
        print(
          'ERRO DEVICE_STORE: Versão para $serialNumber não encontrada ou erro na API.',
        );
        return null;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao buscar versão: $e');
      return null;
    }
  }

  @action
  Future<bool> preRegisterDevice(Device newDevice) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final bool success = await service.preRegisterDevice(
        newDevice,
        token: token!,
      );

      if (success) {
        return true;
      } else {
        print('ERRO DEVICE_STORE: service.preRegisterDevice retornou false.');
        return false;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção durante o pré-registro: $e');
      return false;
    }
  }

  @action
  Future<bool> registerDevice(Device newDevice) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final Device? registeredDeviceFromApi = await service.registerDevice(
        newDevice,
        token: token!,
      );

      if (registeredDeviceFromApi != null) {
        devices.add(registeredDeviceFromApi);

        return true;
      } else {
        print('ERRO DEVICE_STORE: service.registerDevice retornou null.');
        return false;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção durante o registro: $e');
      return false;
    }
  }

  @action
  Future<bool> registerDeviceConfig(Device deviceConfig) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      print('DEBUG DEVICE_STORE: Registrando configuração do dispositivo...');
      final bool success = await service.registerDeviceConfig(
        deviceConfig,
        token: token!,
      );

      if (success) {
        return true;
      } else {
        print(
          'ERRO DEVICE_STORE: service.registerDeviceConfig retornou false.',
        );
        return false;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao registrar configuração: $e');
      return false;
    }
  }

  @action
  Future<bool> updateDevice(Device deviceToUpdate) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final bool success = await service.updateDevice(
        deviceToUpdate,
        deviceToUpdate.deviceId!,
        token: token!,
      );

      if (success) {
        if (currentDevice?.deviceId == deviceToUpdate.deviceId) {
          currentDevice = deviceToUpdate;
        }
        final int index = devices.indexWhere(
          (d) => d.deviceId == deviceToUpdate.deviceId,
        );
        if (index != -1) {
          devices[index] = deviceToUpdate;
        }

        return true;
      } else {
        print('ERRO DEVICE_STORE: service.updateDevice retornou false.');
        return false;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao atualizar dispositivo: $e');
      return false;
    }
  }

  @action
  Future<bool> updateSerialNumber(String serialNumber) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      print('DEBUG DEVICE_STORE: Atualizando número de série: $serialNumber');
      final bool success = await service.updateSerialNumber(
        serialNumber,
        token: token!,
      );

      if (success) {
        return true;
      } else {
        print('ERRO DEVICE_STORE: service.updateSerialNumber retornou false.');
        return false;
      }
    } catch (e) {
      print('ERRO DEVICE_STORE: Exceção ao atualizar número de série: $e');
      return false;
    }
  }

  @action
  Future<bool> registerDeviceFilter(Device filterCriteria) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      final bool success = await service.registerDeviceFilter(
        filterCriteria,
        token: token!,
      );

      if (success) {
        return true;
      } else {
        print(
          'ERRO DEVICE_STORE: service.registerDeviceFilter retornou false.',
        );
        return false;
      }
    } catch (e) {
      print(
        'ERRO DEVICE_STORE: Exceção ao registrar filtro do dispositivo: $e',
      );
      return false;
    }
  }
}
