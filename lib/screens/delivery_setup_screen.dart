import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/config/app_config.dart';
import 'package:dadaroo/models/delivery_stop.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/theme/app_theme.dart';

class DeliverySetupScreen extends StatefulWidget {
  const DeliverySetupScreen({super.key});

  @override
  State<DeliverySetupScreen> createState() => _DeliverySetupScreenState();
}

class _DeliverySetupScreenState extends State<DeliverySetupScreen> {
  final List<_StopEntry> _stops = [_StopEntry()];

  void _addStop() {
    setState(() {
      _stops.add(_StopEntry());
    });
  }

  void _removeStop(int index) {
    if (_stops.length <= 1) return;
    setState(() {
      _stops.removeAt(index);
    });
  }

  void _reorderStops(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final stop = _stops.removeAt(oldIndex);
      _stops.insert(newIndex, stop);
    });
  }

  bool get _isValid {
    return _stops.every((s) => s.nameController.text.trim().isNotEmpty);
  }

  void _startDelivery() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Every stop needs a name')),
      );
      return;
    }

    final stops = _stops.asMap().entries.map((entry) {
      final i = entry.key;
      final s = entry.value;
      return DeliveryStop(
        id: '${DateTime.now().millisecondsSinceEpoch}_$i',
        name: s.nameController.text.trim(),
        address: s.addressController.text.trim(),
        items: s.itemsController.text
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty)
            .toList(),
        orderIndex: i,
        recipientName: s.recipientController.text.trim().isEmpty
            ? null
            : s.recipientController.text.trim(),
      );
    }).toList();

    final provider = context.read<AppProvider>();
    provider.startMultiDropDelivery(stops);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final s in _stops) {
      s.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Your Drops'),
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: AppTheme.lightOrange,
            child: Column(
              children: [
                Text(
                  '${appConfig.parentEmoji} Multi-Drop Delivery',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add each stop in order. Drag to reorder.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.warmBrown.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Stops list
          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _stops.length,
              onReorder: _reorderStops,
              itemBuilder: (context, index) {
                return _buildStopCard(index);
              },
            ),
          ),

          // Bottom actions
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  OutlinedButton.icon(
                    onPressed: _addStop,
                    icon: const Icon(Icons.add_location_alt),
                    label: const Text('Add Another Stop'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryOrange,
                      side: BorderSide(color: AppTheme.primaryOrange),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _startDelivery,
                    icon: const Icon(Icons.directions_car),
                    label: Text(
                      _stops.length == 1
                          ? "LET'S GO!"
                          : "START ${_stops.length}-STOP DELIVERY!",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryOrange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopCard(int index) {
    final stop = _stops[index];
    return Card(
      key: ValueKey(stop),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Stop ${index + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkBrown,
                  ),
                ),
                const Spacer(),
                if (_stops.length > 1)
                  IconButton(
                    icon: Icon(Icons.close, color: AppTheme.warmBrown, size: 20),
                    onPressed: () => _removeStop(index),
                    tooltip: 'Remove stop',
                  ),
                ReorderableDragStartListener(
                  index: index,
                  child: Icon(Icons.drag_handle, color: AppTheme.warmBrown),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stop.nameController,
              decoration: InputDecoration(
                labelText: 'Stop name *',
                hintText: 'e.g. Home, Nan\'s house',
                prefixIcon: const Icon(Icons.label_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryOrange),
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: stop.addressController,
              decoration: InputDecoration(
                labelText: 'Address (optional)',
                hintText: 'e.g. 42 Oak Lane',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: stop.recipientController,
              decoration: InputDecoration(
                labelText: 'Who\'s it for? (optional)',
                hintText: 'e.g. Grandma',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryOrange),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: stop.itemsController,
              decoration: InputDecoration(
                labelText: 'Items (optional, comma-separated)',
                hintText: 'e.g. Chicken chow mein, Spring rolls',
                prefixIcon: const Icon(Icons.restaurant_menu_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppTheme.primaryOrange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StopEntry {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final recipientController = TextEditingController();
  final itemsController = TextEditingController();

  void dispose() {
    nameController.dispose();
    addressController.dispose();
    recipientController.dispose();
    itemsController.dispose();
  }
}
