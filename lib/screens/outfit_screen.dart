import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../models/clothing_item.dart';

class OutfitScreen extends StatefulWidget {
  const OutfitScreen({super.key});

  @override
  State<OutfitScreen> createState() =>
      _OutfitScreenState();
}

class _OutfitScreenState
    extends State<OutfitScreen> {
  ClothingItem? _top, _bottom, _shoes;

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WardrobeProvider>(context);
    final tops = provider.items
        .where((i) => i.category == 'Tops')
        .toList();
    final bottoms = provider.items
        .where((i) => i.category == 'Bottoms')
        .toList();
    final shoes = provider.items
        .where((i) => i.category == 'Footwear')
        .toList();

    return Scaffold(
      appBar: AppBar(
          title: const Text('Outfit Builder')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
                'Mix & match your wardrobe!',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey)),
            const SizedBox(height: 16),
            _buildSlot('Top', tops, _top,
                (item) =>
                    setState(() => _top = item)),
            const SizedBox(height: 12),
            _buildSlot('Bottom', bottoms, _bottom,
                (item) => setState(
                    () => _bottom = item)),
            const SizedBox(height: 12),
            _buildSlot('Footwear', shoes, _shoes,
                (item) => setState(
                    () => _shoes = item)),
            const SizedBox(height: 20),
            if (_top != null ||
                _bottom != null ||
                _shoes != null)
              _buildPreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildSlot(
      String label,
      List<ClothingItem> items,
      ClothingItem? selected,
      Function(ClothingItem) onSelect) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 8),
            items.isEmpty
                ? Text('No $label items yet',
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12))
                : SizedBox(
                    height: 75,
                    child: ListView.builder(
                      scrollDirection:
                          Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final isSel =
                            selected?.id == item.id;
                        return GestureDetector(
                          onTap: () =>
                              onSelect(item),
                          child: AnimatedContainer(
                            duration: const Duration(
                                milliseconds: 200),
                            margin:
                                const EdgeInsets.only(
                                    right: 8),
                            width: 65,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                      10),
                              border: Border.all(
                                color: isSel
                                    ? const Color(
                                        0xFF6C63FF)
                                    : Colors.grey
                                        .shade200,
                                width:
                                    isSel ? 2 : 1,
                              ),
                            ),
                            clipBehavior:
                                Clip.antiAlias,
                            child: item.imageUrl
                                    .isNotEmpty
                                ? _thumbImage(
                                    item.imageUrl)
                                : Container(
                                    color: Colors
                                        .grey.shade100,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                      children: [
                                        const Icon(
                                            Icons
                                                .checkroom,
                                            size: 22,
                                            color: Colors
                                                .grey),
                                        Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize:
                                                    8),
                                            maxLines: 2,
                                            textAlign:
                                                TextAlign
                                                    .center),
                                      ],
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _thumbImage(String imageUrl) {
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl,
          fit: BoxFit.cover,
          width: 65,
          height: 75,
          filterQuality: FilterQuality.high);
    }
    try {
      return Image.memory(base64Decode(imageUrl),
          fit: BoxFit.cover,
          width: 65,
          height: 75,
          filterQuality: FilterQuality.high);
    } catch (_) {
      return const Icon(Icons.broken_image,
          color: Colors.grey);
    }
  }

  Widget _buildPreview() {
    return Card(
      color:
          const Color(0xFF6C63FF).withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(
            color: Color(0xFF6C63FF), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text('Your Outfit',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF6C63FF))),
            const SizedBox(height: 12),
            if (_top != null)
              _outfitRow('👕', 'Top', _top!.name,
                  _top!.subType),
            if (_bottom != null)
              _outfitRow('👖', 'Bottom',
                  _bottom!.name, _bottom!.subType),
            if (_shoes != null)
              _outfitRow('👟', 'Footwear',
                  _shoes!.name, _shoes!.subType),
          ],
        ),
      ),
    );
  }

  Widget _outfitRow(String emoji, String label,
      String name, String subType) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Text(emoji,
            style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Text('$label: ',
            style: const TextStyle(
                color: Colors.grey, fontSize: 12)),
        Flexible(
          child: Text(
            subType.isNotEmpty
                ? '$name ($subType)'
                : name,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ]),
    );
  }
}