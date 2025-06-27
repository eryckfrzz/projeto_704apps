import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:projeto_704apps/features/data/device_dao.dart';
import 'package:projeto_704apps/features/models/device.dart';
import 'package:projeto_704apps/helpers/http_interceptor.dart';
import 'package:projeto_704apps/helpers/url.dart';

class DevicesDaoImpl implements DeviceDao {
  http.Client client = InterceptedClient.build(
    interceptors: [LoggerInterceptor()],
  );

  Url apiUrl = Url();

  @override
  getConfigSerialNumber(String serialNumber, {required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/device/config/$serialNumber'),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonDevice = json.decode(response.body);

        print('Configuração encontrada com sucesso!');

        return Device.fromjson(jsonDevice);
      } else {
        print(response.statusCode);
        print('Erro ao buscar configuração!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }
  }

  @override
  Future<List<Device>> getDevices({required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/device'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        List<Device> devices = [];
        List<dynamic> deviceList = json.decode(response.body);

        for (var jsonMap in deviceList) {
          devices.add(Device.fromjson(jsonMap));
        }

        return devices;
      } else {
        print(response.statusCode);
        print('Erro ao buscar dispositivos!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return [];
  }

  @override
  getVersionSerialNumber(String serialNumber, {required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/device/version/$serialNumber'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonDevice = json.decode(response.body);

        print('Versão encontrada com sucesso!');

        return Device.fromjson(jsonDevice);
      } else {
        print(response.statusCode);
        print('Erro ao buscar versão!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }
  }

  @override
  getdeviceById(int id, {required String token}) async {
    try {
      http.Response response = await client.get(
        Uri.parse('${apiUrl.url}/device/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> deviceJson = json.decode(response.body);

        print('Aparelho encontrado com sucesso!');

        return Device.fromjson(deviceJson);
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }
  }

  @override
  Future<bool> preRegisterDevice(Device device, {required String token}) async {
    try {
      String jsonDevice = jsonEncode(device.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/device/preregister'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
        body: jsonDevice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Dispositivo pré-registrado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao pré-registrar dispositivo!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<Device?> registerDevice(Device device, {required String token}) async {
    try {
      String jsonDevice = jsonEncode(device.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/device'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
        body: jsonDevice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Dispositivo registrado com sucesso!');
      } else {
        print(response.statusCode);
        print('Erro ao registrar dispositivo!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return null;
  }

  @override
  Future<bool> registerDeviceConfig(
    Device device, {
    required String token,
  }) async {
    try {
      String jsonDevice = jsonEncode(device.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/device/config'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
        body: jsonDevice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Configuração do dispositivo registrada com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao registrar configuração do dispositivo!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> updateDevice(
    Device device,
    String id, {
    required String token,
  }) async {
    try {
      String jsonDevice = jsonEncode(device.toJson());

      http.Response response = await client.patch(
        Uri.parse('${apiUrl.url}/device/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application/json',
        },
        body: jsonDevice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Dispositivo atualizado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao atualizar dispositivo!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> updateSerialNumber(
    String serialNumber, {
    required String token,
  }) async {
    try {
      http.Response response = await client.patch(
        Uri.parse('${apiUrl.url}/device/serial/$serialNumber'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Número de série atualizado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao atualizar número de série!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }

  @override
  Future<bool> registerDeviceFilter(
    Device device, {
    required String token,
  }) async {
    try {
      String jsonDevice = jsonEncode(device.toJson());

      http.Response response = await client.post(
        Uri.parse('${apiUrl.url}/device/filter/search'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-type': 'application-json',
        },
        body: jsonDevice,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Filto do dispositivo registrado com sucesso!');
        return true;
      } else {
        print(response.statusCode);
        print('Erro ao registrar filtro do dispositivo!');
      }
    } catch (e) {
      print(e);
      print('Erro!');
    }

    return false;
  }
}
