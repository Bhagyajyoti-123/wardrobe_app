class ClothingItem {
  final String id;
  final String name;
  final String category;
  final String subType;
  final String color;
  final String imageUrl;
  final bool isFavorite;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    this.subType = '',
    required this.color,
    this.imageUrl = '',
    this.isFavorite = false,
  });

  ClothingItem copyWith({
    String? id,
    String? name,
    String? category,
    String? subType,
    String? color,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return ClothingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subType: subType ?? this.subType,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'subType': subType,
        'color': color,
        'imageUrl': imageUrl,
        'isFavorite': isFavorite,
      };

  factory ClothingItem.fromMap(
          Map<String, dynamic> map) =>
      ClothingItem(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        category: map['category'] ?? '',
        subType: map['subType'] ?? '',
        color: map['color'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        isFavorite: map['isFavorite'] ?? false,
      );
}