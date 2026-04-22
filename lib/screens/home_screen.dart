import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wardrobe_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/clothing_card.dart';
import 'add_item_screen.dart';
import 'outfit_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const categories = [
    'All', 'Tops', 'Bottoms', 'Footwear',
    'Accessories', 'Formal', 'Casual', 'Ethnic',
    'Sportswear', 'Winterwear',
  ];

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<WardrobeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe 👗',
            style:
                TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const StatsScreen())),
          ),
          IconButton(
            icon:
                const Icon(Icons.checkroom_rounded),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const OutfitScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Provider.of<AuthProvider>(context,
                        listen: false)
                    .logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildBanner(provider, auth.username),
          _buildCategoryFilter(context, provider),
          Expanded(
            child: provider.loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF6C63FF)))
                : provider.items.isEmpty
                    ? _buildEmpty()
                    : GridView.builder(
                        padding:
                            const EdgeInsets.all(10),
                        itemCount:
                            provider.items.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) =>
                            ClothingCard(
                              item: provider
                                  .items[index],
                              allItems: provider.items,
                            ),
                      ),
          ),
        ],
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    const AddItemScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _buildBanner(
      WardrobeProvider provider, String username) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF6C63FF),
      padding:
          const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        children: [
          Text('Hi, $username 👋',
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _stat('Total',
                  '${provider.totalItems}',
                  Icons.inventory_2_outlined),
              _stat('Favorites',
                  '${provider.favorites.length}',
                  Icons.favorite_outline),
              _stat(
                  'Categories',
                  '${provider.categoryCounts.length}',
                  Icons.category_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(
          String label, String value, IconData icon) =>
      Column(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11)),
        ],
      );

  Widget _buildCategoryFilter(
      BuildContext context,
      WardrobeProvider provider) {
    return Container(
      height: 44,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 7),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected =
              provider.selectedCategory == cat;
          return GestureDetector(
            onTap: () => provider.setCategory(cat),
            child: AnimatedContainer(
              duration:
                  const Duration(milliseconds: 200),
              margin:
                  const EdgeInsets.only(right: 7),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : Colors.grey.shade100,
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6C63FF)
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(cat,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 11,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.checkroom_outlined,
                size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Your wardrobe is empty!',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey)),
            SizedBox(height: 8),
            Text('Tap + Add Item to get started',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey)),
          ],
        ),
      );
}