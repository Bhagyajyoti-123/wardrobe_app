import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() =>
      _AddItemScreenState();
}

class _AddItemScreenState
    extends State<AddItemScreen> {
  final _nameCtrl = TextEditingController();
  String _category = 'Tops';
  String _subType = '';
  String _color = 'Black';
  String _imageBase64 = '';

  static const categories = [
    'Tops', 'Bottoms', 'Footwear', 'Accessories',
    'Formal', 'Casual', 'Ethnic', 'Sportswear',
    'Winterwear',
  ];

  static const Map<String, List<String>> subTypes = {
    'Tops': [
      'T-Shirt', 'Casual Shirt', 'Formal Shirt',
      'Polo', 'Sleeveless', 'Crop Top',
      'Off-Shoulder', 'Tank Top', 'Hoodie',
      'Sweatshirt', 'Blouse', 'Tunic',
    ],
    'Bottoms': [
      'Jeans', 'Cargo', 'Skinny Jeans', 'Chinos',
      'Formal Trousers', 'Shorts', 'Joggers',
      'Leggings', 'Skirt', 'Mini Skirt',
      'Culottes', 'Track Pants',
    ],
    'Footwear': [
      'Sneakers', 'Formal Shoes', 'Loafers',
      'Sandals', 'Heels', 'Boots', 'Flip Flops',
      'Sports Shoes', 'Wedges', 'Mules',
      'Ankle Boots', 'Slip-Ons',
    ],
    'Accessories': [
      'Watch', 'Belt', 'Sunglasses', 'Cap / Hat',
      'Scarf', 'Bag', 'Wallet', 'Jewellery',
      'Tie', 'Socks', 'Gloves', 'Hairband',
    ],
    'Formal': [
      'Blazer', 'Suit', 'Formal Shirt',
      'Formal Trousers', 'Saree', 'Kurta',
      'Sherwani', 'Gown',
    ],
    'Casual': [
      'T-Shirt', 'Jeans', 'Shorts',
      'Casual Shirt', 'Dress', 'Jumpsuit',
      'Co-ord Set', 'Dungaree',
    ],
    'Ethnic': [
      'Saree', 'Lehenga', 'Kurta',
      'Salwar Kameez', 'Sherwani', 'Dhoti',
      'Anarkali', 'Palazzo Set',
    ],
    'Sportswear': [
      'Track Pants', 'Sports T-Shirt', 'Shorts',
      'Compression Wear', 'Sports Bra', 'Jacket',
      'Sweatshirt', 'Hoodie',
    ],
    'Winterwear': [
      'Jacket', 'Coat', 'Sweater', 'Hoodie',
      'Thermal Wear', 'Muffler', 'Beanie', 'Gloves',
    ],
  };

  static const colors = [
    'Black', 'White', 'Grey', 'Charcoal',
    'Red', 'Maroon', 'Crimson', 'Coral',
    'Orange', 'Peach', 'Yellow', 'Mustard', 'Gold',
    'Green', 'Olive', 'Mint', 'Teal',
    'Blue', 'Navy', 'Sky Blue', 'Cobalt',
    'Purple', 'Lavender', 'Violet',
    'Pink', 'Hot Pink', 'Rose',
    'Brown', 'Tan', 'Beige', 'Cream',
    'Multi-color',
  ];

  static const Map<String, Color> colorMap = {
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

  @override
  void initState() {
    super.initState();
    _subType = subTypes[_category]!.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Add New Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildImagePicker(),
            const SizedBox(height: 20),
            _label('Item Name'),
            TextField(
              controller: _nameCtrl,
              decoration: _inputDec(
                  'e.g. Blue Denim Jacket'),
            ),
            const SizedBox(height: 16),
            _label('Category'),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _inputDec(''),
              items: categories
                  .map((c) => DropdownMenuItem(
                      value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() {
                _category = v!;
                _subType =
                    subTypes[_category]!.first;
              }),
            ),
            const SizedBox(height: 16),
            _label('Type / Style'),
            DropdownButtonFormField<String>(
              value: _subType,
              decoration: _inputDec(''),
              items: (subTypes[_category] ?? [])
                  .map((s) => DropdownMenuItem(
                      value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _subType = v!),
            ),
            const SizedBox(height: 16),
            _label('Color'),
            DropdownButtonFormField<String>(
              value: _color,
              decoration: _inputDec(''),
              isExpanded: true,
              items: colors
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: colorMap[c] ??
                                  Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors
                                      .grey.shade400),
                            ),
                            child: c == 'Multi-color'
                                ? const Icon(
                                    Icons.palette,
                                    size: 12,
                                    color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(c),
                        ]),
                      ))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _color = v!),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6C63FF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save to Wardrobe',
                    style: TextStyle(fontSize: 16)),
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5),
        ),
        child: _imageBase64.isEmpty
            ? Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [
                  Icon(
                      Icons
                          .add_photo_alternate_outlined,
                      size: 18,
                      color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Tap to add photo',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12)),
                ],
              )
            : Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.memory(
                      base64Decode(_imageBase64),
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                      filterQuality:
                          FilterQuality.high,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('Photo added ✓',
                      style: TextStyle(
                          color: Color(0xFF6C63FF),
                          fontWeight: FontWeight.w500,
                          fontSize: 13)),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 12),
                    child: GestureDetector(
                      onTap: () => setState(
                          () => _imageBase64 = ''),
                      child: const Icon(Icons.close,
                          size: 18,
                          color: Colors.grey),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  InputDecoration _inputDec(String hint) =>
      InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey.shade300)),
      );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 100,
    );
    if (xfile != null) {
      final bytes = await xfile.readAsBytes();
      setState(
          () => _imageBase64 = base64Encode(bytes));
    }
  }

  void _save() {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Please enter an item name'),
              backgroundColor: Colors.red));
      return;
    }

    // Instant — no await, no loading state
    Provider.of<WardrobeProvider>(context,
            listen: false)
        .addItem(
      _nameCtrl.text.trim(),
      _category,
      _subType,
      _color,
      _imageBase64,
    );

    // Go back immediately
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Item added! 🎉'),
            backgroundColor: Color(0xFF6C63FF)));
  }
}