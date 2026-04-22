import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WardrobeProvider>(context);
    final counts = provider.categoryCounts;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Wardrobe Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _summaryRow(provider),
            const SizedBox(height: 24),
            const Text('Items by Category',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: counts.isEmpty
                  ? const Center(
                      child: Text('No items yet',
                          style: TextStyle(
                              color: Colors.grey)))
                  : ListView(
                      children: counts.entries
                          .map((e) => _categoryBar(
                              e.key,
                              e.value,
                              provider.totalItems))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(provider) {
    return Row(
      children: [
        _statCard('Total',
            '${provider.totalItems}',
            Icons.inventory_2, Colors.indigo),
        const SizedBox(width: 12),
        _statCard('Favorites',
            '${provider.favorites.length}',
            Icons.favorite, Colors.red),
        const SizedBox(width: 12),
        _statCard(
            'Categories',
            '${provider.categoryCounts.length}',
            Icons.category,
            Colors.orange),
      ],
    );
  }

  Widget _statCard(String label, String val,
      IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 14, horizontal: 8),
          child: Column(children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(val,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey),
                textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _categoryBar(
      String label, int count, int total) {
    final pct =
        total == 0 ? 0.0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13)),
                Text('$count items',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12)),
              ]),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor:
                  Colors.grey.shade200,
              valueColor:
                  const AlwaysStoppedAnimation(
                      Color(0xFF6C63FF)),
            ),
          ),
        ],
      ),
    );
  }
}