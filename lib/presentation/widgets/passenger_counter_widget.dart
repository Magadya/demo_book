import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class PassengerCounterWidget extends StatelessWidget {
  final int count;
  final Function(int) onChanged;

  const PassengerCounterWidget({
    super.key,
    required this.count,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Passengers:'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: count > 1 ? () => onChanged(count - 1) : null,
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: count < AppConstants.maxPassengersCount
              ? () => onChanged(count + 1)
              : null,
        ),
      ],
    );
  }
}