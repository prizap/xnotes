import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/agenda_provider.dart';
import '../widgets/agenda_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, dd MMMM yyyy').format(now);

    return Scaffold(
      body: SafeArea(
        child: Consumer<AgendaProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final todaysAgendas = provider.agendas.where((agenda) {
              return agenda.dateTime.year == now.year &&
                  agenda.dateTime.month == now.month &&
                  agenda.dateTime.day == now.day;
            }).toList();
            
            // sort by time
            todaysAgendas.sort((a, b) => a.dateTime.compareTo(b.dateTime));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ).animate().fade().slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 8),
                      Text(
                        dateStr,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ).animate().fade(delay: 100.ms).slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded,
                                color: Colors.white, size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                todaysAgendas.isEmpty
                                    ? 'No agendas scheduled for today.'
                                    : 'You have ${todaysAgendas.length} agenda(s) today!',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fade(delay: 200.ms)
                          .scale(begin: const Offset(0.9, 0.9)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Text(
                    "Today's Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ).animate().fade(delay: 300.ms),
                ),
                Expanded(
                  child: todaysAgendas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.coffee_rounded,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.2),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your day is clear!',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.5),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fade()
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24, top: 8),
                          itemCount: todaysAgendas.length,
                          itemBuilder: (context, index) {
                            return AgendaCard(
                                agenda: todaysAgendas[index], index: index);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
