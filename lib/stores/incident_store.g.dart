// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$IncidentStore on _IncidentStore, Store {
  late final _$incidentAtom =
      Atom(name: '_IncidentStore.incident', context: context);

  @override
  Incident? get incident {
    _$incidentAtom.reportRead();
    return super.incident;
  }

  @override
  set incident(Incident? value) {
    _$incidentAtom.reportWrite(value, super.incident, () {
      super.incident = value;
    });
  }

  late final _$incidentsAtom =
      Atom(name: '_IncidentStore.incidents', context: context);

  @override
  ObservableList<Incident> get incidents {
    _$incidentsAtom.reportRead();
    return super.incidents;
  }

  @override
  set incidents(ObservableList<Incident> value) {
    _$incidentsAtom.reportWrite(value, super.incidents, () {
      super.incidents = value;
    });
  }

  late final _$fetchIncidentsAsyncAction =
      AsyncAction('_IncidentStore.fetchIncidents', context: context);

  @override
  Future<void> fetchIncidents() {
    return _$fetchIncidentsAsyncAction.run(() => super.fetchIncidents());
  }

  late final _$registerIncidentAsyncAction =
      AsyncAction('_IncidentStore.registerIncident', context: context);

  @override
  Future<bool> registerIncident(Incident newIncident) {
    return _$registerIncidentAsyncAction
        .run(() => super.registerIncident(newIncident));
  }

  @override
  String toString() {
    return '''
incident: ${incident},
incidents: ${incidents}
    ''';
  }
}
