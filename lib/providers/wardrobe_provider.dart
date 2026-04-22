import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/clothing_item.dart';

class WardrobeProvider with ChangeNotifier {
  List<ClothingItem> _items = [];
  String _selectedCategory = 'All';
  final _uuid = const Uuid();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  List<ClothingItem> get items =>
      _selectedCategory == 'All'
          ? _items
          : _items
              .where((i) =>
                  i.category == _selectedCategory)
              .toList();

  List<ClothingItem> get favorites =>
      _items.where((i) => i.isFavorite).toList();
  String get selectedCategory => _selectedCategory;
  int get totalItems => _items.length;
  bool get loading => _loading;

  Map<String, int> get categoryCounts {
    final map = <String, int>{};
    for (var item in _items) {
      map[item.category] =
          (map[item.category] ?? 0) + 1;
    }
    return map;
  }

  WardrobeProvider() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _loadItems();
      } else {
        _items = [];
        _selectedCategory = 'All';
        notifyListeners();
      }
    });
  }

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>?
      get _col {
    if (_uid == null) return null;
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('wardrobe');
  }

  Future<void> _loadItems() async {
    try {
      _loading = true;
      notifyListeners();
      if (_col == null) return;
      final snap = await _col!.get();
      _items = snap.docs
          .map((d) => ClothingItem.fromMap(d.data()))
          .toList();
      _items.sort(
          (a, b) => a.name.compareTo(b.name));
    } catch (e) {
      debugPrint('Load error: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ADD INSTANTLY to UI, save to Firestore in background
  void addItem(
      String name,
      String category,
      String subType,
      String color,
      String imageBase64) {
    if (_col == null) return;

    final item = ClothingItem(
      id: _uuid.v4(),
      name: name,
      category: category,
      subType: subType,
      color: color,
      imageUrl: imageBase64,
    );

    // Show instantly — no await
    _items.add(item);
    _items.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();

    // Save to Firestore in background
    _col!.doc(item.id).set(item.toMap()).catchError(
        (e) => debugPrint('Save error: $e'));
  }

  void deleteItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
    _col?.doc(id).delete().catchError(
        (e) => debugPrint('Delete error: $e'));
  }

  void toggleFavorite(String id) {
    final index =
        _items.indexWhere((i) => i.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
          isFavorite: !_items[index].isFavorite);
      notifyListeners();
      _col?.doc(id).update({
        'isFavorite': _items[index].isFavorite,
      }).catchError(
          (e) => debugPrint('Toggle error: $e'));
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}