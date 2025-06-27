// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DeviceStore on _DeviceStore, Store {
  late final _$currentDeviceAtom =
      Atom(name: '_DeviceStore.currentDevice', context: context);

  @override
  Device? get currentDevice {
    _$currentDeviceAtom.reportRead();
    return super.currentDevice;
  }

  @override
  set currentDevice(Device? value) {
    _$currentDeviceAtom.reportWrite(value, super.currentDevice, () {
      super.currentDevice = value;
    });
  }

  late final _$devicesAtom =
      Atom(name: '_DeviceStore.devices', context: context);

  @override
  ObservableList<Device> get devices {
    _$devicesAtom.reportRead();
    return super.devices;
  }

  @override
  set devices(ObservableList<Device> value) {
    _$devicesAtom.reportWrite(value, super.devices, () {
      super.devices = value;
    });
  }

  late final _$fetchDevicesAsyncAction =
      AsyncAction('_DeviceStore.fetchDevices', context: context);

  @override
  Future<List<Device>?> fetchDevices() {
    return _$fetchDevicesAsyncAction.run(() => super.fetchDevices());
  }

  late final _$getDeviceByIdAsyncAction =
      AsyncAction('_DeviceStore.getDeviceById', context: context);

  @override
  Future<Device?> getDeviceById(int id) {
    return _$getDeviceByIdAsyncAction.run(() => super.getDeviceById(id));
  }

  late final _$getConfigBySerialNumberAsyncAction =
      AsyncAction('_DeviceStore.getConfigBySerialNumber', context: context);

  @override
  Future<Device?> getConfigBySerialNumber(String serialNumber) {
    return _$getConfigBySerialNumberAsyncAction
        .run(() => super.getConfigBySerialNumber(serialNumber));
  }

  late final _$getVersionBySerialNumberAsyncAction =
      AsyncAction('_DeviceStore.getVersionBySerialNumber', context: context);

  @override
  Future<Device?> getVersionBySerialNumber(String serialNumber) {
    return _$getVersionBySerialNumberAsyncAction
        .run(() => super.getVersionBySerialNumber(serialNumber));
  }

  late final _$preRegisterDeviceAsyncAction =
      AsyncAction('_DeviceStore.preRegisterDevice', context: context);

  @override
  Future<bool> preRegisterDevice(Device newDevice) {
    return _$preRegisterDeviceAsyncAction
        .run(() => super.preRegisterDevice(newDevice));
  }

  late final _$registerDeviceAsyncAction =
      AsyncAction('_DeviceStore.registerDevice', context: context);

  @override
  Future<bool> registerDevice(Device newDevice) {
    return _$registerDeviceAsyncAction
        .run(() => super.registerDevice(newDevice));
  }

  late final _$registerDeviceConfigAsyncAction =
      AsyncAction('_DeviceStore.registerDeviceConfig', context: context);

  @override
  Future<bool> registerDeviceConfig(Device deviceConfig) {
    return _$registerDeviceConfigAsyncAction
        .run(() => super.registerDeviceConfig(deviceConfig));
  }

  late final _$updateDeviceAsyncAction =
      AsyncAction('_DeviceStore.updateDevice', context: context);

  @override
  Future<bool> updateDevice(Device deviceToUpdate) {
    return _$updateDeviceAsyncAction
        .run(() => super.updateDevice(deviceToUpdate));
  }

  late final _$updateSerialNumberAsyncAction =
      AsyncAction('_DeviceStore.updateSerialNumber', context: context);

  @override
  Future<bool> updateSerialNumber(String serialNumber) {
    return _$updateSerialNumberAsyncAction
        .run(() => super.updateSerialNumber(serialNumber));
  }

  late final _$registerDeviceFilterAsyncAction =
      AsyncAction('_DeviceStore.registerDeviceFilter', context: context);

  @override
  Future<bool> registerDeviceFilter(Device filterCriteria) {
    return _$registerDeviceFilterAsyncAction
        .run(() => super.registerDeviceFilter(filterCriteria));
  }

  @override
  String toString() {
    return '''
currentDevice: ${currentDevice},
devices: ${devices}
    ''';
  }
}
