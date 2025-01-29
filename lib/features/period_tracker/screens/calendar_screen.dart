import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart'; // Ensure package is added
import '../providers/cycle_provider.dart';
import '../models/cycle_model.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<CycleProvider>(context);
    final predictedDate = cycleProvider.predictedNextPeriod;

    return Scaffold(
      appBar: AppBar(title: const Text('Cycle Tracker')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) => _getEventsForDay(day, cycleProvider.cycles),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.pinkAccent,
                      shape: BoxShape.circle,
                    ),
                    width: 8,
                    height: 8,
                  );
                }
                return null;
              },
            ),
          ),
          if (predictedDate != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Next predicted period: ${predictedDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          const _SustainabilityTipCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCycleDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<dynamic> _getEventsForDay(DateTime day, List<Cycle> cycles) {
    return cycles.where((cycle) {
      return day.isAfter(cycle.startDate.subtract(const Duration(days: 1))) &&
          day.isBefore(cycle.endDate.add(const Duration(days: 1)));
    }).toList();
  }

  void _showAddCycleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log New Cycle'),
        content: const Text('Select start and end dates'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SustainabilityTipCard extends StatelessWidget {
  const _SustainabilityTipCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌱 Sustainable Tip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Consider using a menstrual cup this cycle!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}