import 'package:projeto_704apps/features/models/incident.dart';

abstract class IncidentDao {
  Future<bool> registerIncident(Incident incident, {required String token});
}
