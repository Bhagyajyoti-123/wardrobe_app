import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';
import '../screens/image_viewer_screen.dart';

class ClothingCard extends StatelessWidget {
  final ClothingItem item;
  final List<ClothingItem> allItems;

  const ClothingCard({
    super.key,
    required this.item,
    required this.allItems,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WardrobeProvider>(context,
            listen: false);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image takes most space
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: () {
                    final index = allItems
                        .indexWhere(
                            (i) => i.id == item.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ImageViewerScreen(
                          items: allItems,
                          initialIndex:
                              index < 0 ? 0 : index,
                        ),
                      ),
                    );
                  },
                  child: _buildImage(),
                ),
                Positioned(
                  top: 3,
                  right: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _iconBtn(
                        item.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        item.isFavorite
                            ? Colors.red
                            : Colors.white,
                        () => provider
                            .toggleFavorite(item.id),
                      ),
                      const SizedBox(width: 2),
                      _iconBtn(
                          Icons.delete_outline,
                          Colors.white, () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(
                                'Delete Item'),
                            content: Text(
                                'Remove "${item.name}"?'),
                            actions: [
                              TextButton(
                                  onPressed: () =>
                                      Navigator.pop(
                                          context),
                                  child: const Text(
                                      'Cancel')),
                              ElevatedButton(
                                style: ElevatedButton
                                    .styleFrom(
                                        backgroundColor:
                                            Colors.red),
                                onPressed: () {
                                  provider.deleteItem(
                                      item.id);
                                  Navigator.pop(
                                      context);
                                },
                                child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                        color: Colors
                                            .white)),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info — fixed height, no overflow ever
          SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 9),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets
                              .symmetric(
                                  horizontal: 4,
                                  vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(
                                    0xFF6C63FF)
                                .withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(
                                    4),
                          ),
                          child: Text(
                            item.subType.isNotEmpty
                                ? item.subType
                                : item.category,
                            style: const TextStyle(
                                fontSize: 7,
                                color: Color(
                                    0xFF6C63FF)),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _parseColor(item.color),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color:
                                  Colors.grey.shade300,
                              width: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (item.imageUrl.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Center(
            child: Icon(Icons.checkroom,
                size: 32, color: Colors.grey)),
      );
    }
    if (item.imageUrl.startsWith('http')) {
      return Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => Container(
            color: Colors.grey.shade100,
            child: const Icon(Icons.broken_image,
                color: Colors.grey)),
      );
    }
    try {
      return Image.memory(
        base64Decode(item.imageUrl),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        gaplessPlayback: true,
      );
    } catch (_) {
      return Container(
          color: Colors.grey.shade100,
          child: const Icon(Icons.broken_image,
              color: Colors.grey));
    }
  }

  Widget _iconBtn(
      IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 12),
      ),
    );
  }

  Color _parseColor(String colorName) {
    const map = {
      'Black': Colors.black,
      'White': Colors.white,
      'Grey': Colors.grey,
      'Charcoal': Color(0xFF36454F),
      'Red': Colors.red,
      'Maroon': Color(0xFF800000),
      'Crimson': Color(0xFFDC143C),
      'Coral': Color(0xFFFF7F7F),
      'Orange': Colors.orange,
      'Peach': Color(0xFFFFDAB9),
      'Yellow': Colors.yellow,
      'Mustard': Color(0xFFFFDB58),
      'Gold': Color(0xFFFFD700),
      'Green': Colors.green,
      'Olive': Color(0xFF808000),
      'Mint': Color(0xFF98FF98),
      'Teal': Colors.teal,
      'Blue': Colors.blue,
      'Navy': Color(0xFF001F5B),
      'Sky Blue': Color(0xFF87CEEB),
      'Cobalt': Color(0xFF0047AB),
      'Purple': Colors.purple,
      'Lavender': Color(0xFFE6E6FA),
      'Violet': Color(0xFFEE82EE),
      'Pink': Colors.pink,
      'Hot Pink': Color(0xFFFF69B4),
      'Rose': Color(0xFFFF007F),
      'Brown': Colors.brown,
      'Tan': Color(0xFFD2B48C),
      'Beige': Color(0xFFF5F5DC),
      'Cream': Color(0xFFFFFDD0),
      'Multi-color': Colors.transparent,
    };
    return map[colorName] ?? Colors.grey;
  }
}