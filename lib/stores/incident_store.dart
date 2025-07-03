import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/incident.dart';
import 'package:projeto_704apps/services/remote/incident_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'incident_store.g.dart';

class IncidentStore = _IncidentStore with _$IncidentStore;

abstract class _IncidentStore with Store {
  @observable
  Incident? incident;

  @observable
  ObservableList<String> incidents = ObservableList<String>();

  final IncidentDaoImpl service = IncidentDaoImpl();

  @action
  Future<void> fetchIncidents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    final fetchedIncidents = await service.getIncidents(token: token!);

    ObservableList<Incident> incidents = fetchedIncidents.asObservable();
    print('Incidentes encontrados! ${incidents.length}');
  }

  @action
  Future<bool> registerIncident(Incident newIncident) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('access_token');

    final bool isRegistred = await service.registerIncident(
      newIncident,
      token: token!,
    );

    if (isRegistred) {
      incidents.add(newIncident.toString());
      return true;
    }

    return false;
  }
}
