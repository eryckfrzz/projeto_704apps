import 'package:flutter/material.dart';
import 'package:projeto_704apps/features/models/incident.dart';
import 'package:projeto_704apps/services/remote/incident_dao_impl.dart'; // Pode ser removido se não for usado diretamente
import 'package:projeto_704apps/stores/incident_store.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart'; // Para Observer
import 'package:projeto_704apps/screens/widgets/incident_card.dart'; // Importe o IncidentCard

class IncidentsListScreen extends StatefulWidget {
  const IncidentsListScreen({super.key});

  @override
  State<IncidentsListScreen> createState() => _IncidentsListScreenState();
}

class _IncidentsListScreenState extends State<IncidentsListScreen> {
  // A instância do service pode não ser necessária aqui se o store a gerencia
  // final IncidentDaoImpl service = IncidentDaoImpl(); // Removido, pois o store deve gerenciar o DAO

  late IncidentStore _incidentStore;
  String _selectedNotificationLevel =
      'Maior que 0'; // Valor inicial para o filtro

  // Opções para o dropdown de notificação
  final List<String> _notificationLevelOptions = [
    'Maior que 0', // Todos os incidentes
    'Maior que 1',
    'Maior que 2',
    'Maior que 3',
    'Maior que 4',
    'Maior que 5',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _incidentStore = Provider.of<IncidentStore>(context);
    // Carregue os incidentes ao entrar na tela.
    // É crucial que o fetchIncidents no seu store lide com a obtenção do token.
    _incidentStore.fetchIncidents();
  }

  // Função para filtrar os incidentes com base no nível selecionado
  List<Incident> _getFilteredIncidents(List<Incident> allIncidents) {
    if (_selectedNotificationLevel == 'Maior que 0') {
      return allIncidents; // Retorna todos se "Maior que 0" estiver selecionado
    }

    // Extrai o número do nível da string "Maior que X"
    // Ex: "Maior que 3" -> 3
    final int minLevel = int.parse(_selectedNotificationLevel.split(' ')[2]);

    // Filtra os incidentes cujo nível é estritamente maior que o nível mínimo selecionado
    return allIncidents.where((incident) => (incident.level ?? 0) > minLevel).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Incidentes',
            style: TextStyle(
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0), // Altura da linha inferior
          child: Container(
            height: 1,
            color: Colors.deepPurple[400],
            width: double.infinity, // Preenche a largura total
          ),
        ),
      ),
      body: Column(
        children: [
          // Seção "Notificar para os níveis" (Dropdown)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filtrar por Nível:', // Texto mais claro para o filtro
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedNotificationLevel,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.deepPurple[400]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: _notificationLevelOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedNotificationLevel = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Espaçamento entre o dropdown e a lista
          // Lista de Incidentes
          Expanded(
            child: Observer(
              builder: (_) {
                

                // Aplica o filtro
                // O cast é seguro aqui porque _incidentStore.incidents é ObservableList<Incident>
                final filteredIncidents = _getFilteredIncidents(
                  _incidentStore.incidents.toList(), // Converte para List<Incident> para o filtro
                );

                if (filteredIncidents.isEmpty) {
                  return const Center(
                    child: Text('Nenhum incidente encontrado para o filtro selecionado.'),
                  );
                }

                // Inverte a ordem para que os mais novos apareçam primeiro
                final displayIncidents = filteredIncidents.reversed.toList();

                return ListView.builder(
                  itemCount: displayIncidents.length,
                  itemBuilder: (context, index) {
                    final incident = displayIncidents[index];
                    // Passa o índice + 1 para ter o número da ocorrência (1, 2, 3...)
                    return IncidentCard(
                      incident: incident,
                      occurrenceNumber: displayIncidents.length - index, // Número da ocorrência decrescente
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}