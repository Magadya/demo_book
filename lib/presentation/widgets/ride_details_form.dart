import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'passenger_counter_widget.dart';

class RideDetailsForm extends StatelessWidget {
  final int passengersCount;
  final DateTime rideTime;
  final Function(int) onPassengersCountChanged;
  final Function(DateTime) onRideTimeChanged;

  const RideDetailsForm({
    super.key,
    required this.passengersCount,
    required this.rideTime,
    required this.onPassengersCountChanged,
    required this.onRideTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: PassengerCounterWidget(
              count: passengersCount,
              onChanged: onPassengersCountChanged,
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pickup Time', style: TextStyle(fontWeight: FontWeight.bold)),
                ListTile(
                  title: Text(
                    DateFormat('EEEE, MMMM d, yyyy').format(rideTime),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(DateFormat('HH:mm').format(rideTime)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDateTime(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: rideTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (pickedDate == null) return;
    if (!context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(rideTime),
    );

    if (pickedTime == null) return;
    if (!context.mounted) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onRideTimeChanged(newDateTime);
  }
}
