import 'dart:convert' show json;

import 'package:demo_ride_book/domain/entities/location_entity.dart';
import 'package:demo_ride_book/presentation/widgets/app_snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http show get;

import '../../core/constants/app_constants.dart' show AppConstants;

class PlacesSearchDialogWidget extends StatefulWidget {
  final Function(LocationEntity) onPlaceSelected;

  const PlacesSearchDialogWidget({
    super.key,
    required this.onPlaceSelected,
  });

  @override
  PlacesSearchDialogWidgetState createState() => PlacesSearchDialogWidgetState();
}

class PlacesSearchDialogWidgetState extends State<PlacesSearchDialogWidget> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _predictions = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Search Location'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Search for a location',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchTextChanged,
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    final prediction = _predictions[index];
                    return ListTile(
                      title: Text(prediction['description']),
                      onTap: () => _getPlaceDetails(prediction['place_id']),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _onSearchTextChanged(String value) async {
    if (value.length < 3) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _getPredictions(value);
      if (!mounted) return;
      setState(() {
        _predictions = response['predictions'];
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        AppSnackBarWidget.showError(context, e);
      }
    }
  }

  Future<Map<String, dynamic>> _getPredictions(String input) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=$input&key=${AppConstants.googleMapsApiKey}&language=en';

    final response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  Future<void> _getPlaceDetails(String placeId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = 'https://maps.googleapis.com/maps/api/place/details/json?'
          'place_id=$placeId&fields=geometry,formatted_address&key=${AppConstants.googleMapsApiKey}';

      final response = await http.get(Uri.parse(url));
      final result = json.decode(response.body);

      if (!mounted) return;

      if (result['status'] == 'OK') {
        final location = result['result']['geometry']['location'];
        final formattedAddress = result['result']['formatted_address'];

        widget.onPlaceSelected(
          LocationEntity(
            latitude: location['lat'],
            longitude: location['lng'],
            address: formattedAddress,
          ),
        );
      } else {
        if (mounted) {
          AppSnackBarWidget.showError(context, 'Could not fetch location details');
        }
      }
    } catch (e) {
      if (mounted) {
        AppSnackBarWidget.showError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
