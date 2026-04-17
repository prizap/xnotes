import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/agenda_provider.dart';
import '../widgets/agenda_card.dart';
import 'agenda_form_page.dart';

class AgendaListPage extends StatelessWidget {
  const AgendaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendas')),
      body: Consumer<AgendaProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.agendas.isEmpty) {
            return const Center(child: Text('No agendas yet. Add one!'));
          }

          return ListView.builder(
            itemCount: provider.agendas.length,
            itemBuilder: (context, index) {
              final agenda = provider.agendas[index];
              return AgendaCard(agenda: agenda, index: index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgendaFormPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Agenda'),
      ),
    );
  }
}
