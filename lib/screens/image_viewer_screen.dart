import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../providers/wardrobe_provider.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<ClothingItem> items;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() =>
      _ImageViewerScreenState();
}

class _ImageViewerScreenState
    extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController =
        PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WardrobeProvider>(context);
    final item = widget.items[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          '${_currentIndex + 1} / ${widget.items.length}',
          style: const TextStyle(
              color: Colors.white70, fontSize: 14),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              item.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: item.isFavorite
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: () {
              provider.toggleFavorite(item.id);
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.white),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Delete Item'),
                content:
                    Text('Remove "${item.name}"?'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text('Cancel')),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    onPressed: () {
                      provider.deleteItem(item.id);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete',
                        style: TextStyle(
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) =>
                setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 6.0,
                child: Center(
                  child: _buildFullImage(
                      widget.items[index].imageUrl),
                ),
              );
            },
          ),

          // Left arrow
          if (_currentIndex > 0)
            Positioned(
              left: 8,
              top: 0,
              bottom: 100,
              child: Center(
                child: GestureDetector(
                  onTap: () =>
                      _pageController.previousPage(
                    duration: const Duration(
                        milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20),
                  ),
                ),
              ),
            ),

          // Right arrow
          if (_currentIndex < widget.items.length - 1)
            Positioned(
              right: 8,
              top: 0,
              bottom: 100,
              child: Center(
                child: GestureDetector(
                  onTap: () =>
                      _pageController.nextPage(
                    duration: const Duration(
                        milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 20),
                  ),
                ),
              ),
            ),

          // Bottom info
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.92),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(
                  20, 40, 20, 28),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _chip(item.category),
                      if (item.subType.isNotEmpty)
                        _chip(item.subType),
                      _colorDot(item.color),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Dot indicators
          if (widget.items.length > 1)
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: List.generate(
                  widget.items.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(
                        milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 3),
                    width: i == _currentIndex
                        ? 16.0
                        : 6.0,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _currentIndex
                          ? Colors.white
                          : Colors.white38,
                      borderRadius:
                          BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFullImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.checkroom,
          size: 80, color: Colors.grey);
    }
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.broken_image,
                color: Colors.grey, size: 60),
      );
    }
    try {
      final Uint8List bytes =
          base64Decode(imageUrl);
      return Image.memory(
        bytes,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        isAntiAlias: true,
        gaplessPlayback: true,
        scale: 1.0,
      );
    } catch (_) {
      return const Icon(Icons.broken_image,
          color: Colors.grey, size: 60);
    }
  }

  Widget _chip(String label) => Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF6C63FF)
              .withOpacity(0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontSize: 11)),
      );

  Widget _colorDot(String colorName) {
    const colorMap = {
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: colorMap[colorName] ?? Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.white54, width: 1),
          ),
        ),
        const SizedBox(width: 5),
        Text(colorName,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 11)),
      ],
    );
  }
}