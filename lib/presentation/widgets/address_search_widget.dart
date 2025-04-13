import 'package:demo_ride_book/presentation/widgets/places_search_dialog_widget.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/location_entity.dart';

class AddressSearchWidget extends StatelessWidget {
  final String label;
  final String? address;
  final Function(LocationEntity) onLocationSelected;
  final VoidCallback onTap;

  const AddressSearchWidget({
    super.key,
    required this.label,
    this.address,
    required this.onLocationSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              label.contains('Pickup') ? Icons.trip_origin : Icons.location_on,
              color: label.contains('Pickup') ? Colors.green : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    address ?? 'Select location',
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showAddressSearchDialog(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: const Text('Search'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddressSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PlacesSearchDialogWidget(
        onPlaceSelected: (place) {
          onLocationSelected(place);
          Navigator.pop(context);
        },
      ),
    );
  }
}
