import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/widgets/bottom_navigation_items.dart';
import 'package:pet_shop_app/feature/login/login_view.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

enum PetCategory { all, dogs, cats, birds, rabbits, fish }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

const customImage =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuB30H33gD7vSvt6pma1r5uTR75MptUjQK9ueduSTPZ_WNAZiZjSSRFj8KtLSX2Snhm0FKPtNb5ESWESPPPwp82a-cmx1Yvp3N-J0TUJsDP_5fSKOjChnl_8l7eyk4Iritk9wZe4hAHkf4RmUHh3h9IeAcbECyCbYrxaCqNbvVZw3ROsSn8PaF8BxIrR2wE94759nxlgAsd2veY3AaGc1jXjaqO_8qod-P6dA7Cwt0mszH66qNH4eQh9Qmie7Ff17XwPlfwCNfv7a2JR';

class _HomeViewState extends State<HomeView> {
  PetCategory _selectedCategory = PetCategory.all;
  int _currentIndex = 0;

  late final void Function(int) _onBottomNavTap = BottomNavigationItems.createOnTapHandler(
    setState,
    (index) => _currentIndex = index,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color.fromARGB(255, 94, 172, 96),
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(customImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(l10n.helloAgain),
                subtitle: Text(l10n.findYourBestFriend),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.notifications),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: SearchBar(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  hintText: l10n.searchByBreedOrName,
                  leading: const Icon(Icons.search),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  trailing: const [Icon(Icons.outlined_flag)],
                ),
              ),
              // Filter buttons with horizontal scroll
              CustomFilterSection(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomWelcomeText(
                    welcomeText: l10n.nearbyFriends,
                    theme: Theme.of(context),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(l10n.seeAll),
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'Item $index',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        selectedItemColor: const Color(0xFF7BAF7B),
        unselectedItemColor: Colors.grey,
        items: BottomNavigationItems.items,
      ),
    );
  }

  Widget CustomFilterSection() {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(),
        children: [
          _CategoryFilterButton(
            label: l10n.all,
            category: PetCategory.all,
            isSelected: _selectedCategory == PetCategory.all,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.all;
              });
            },
          ),
          const SizedBox(width: 12),
          _CategoryFilterButton(
            label: l10n.dogs,
            category: PetCategory.dogs,
            isSelected: _selectedCategory == PetCategory.dogs,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.dogs;
              });
            },
          ),
          const SizedBox(width: 12),
          _CategoryFilterButton(
            label: l10n.cats,
            category: PetCategory.cats,
            isSelected: _selectedCategory == PetCategory.cats,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.cats;
              });
            },
          ),
          const SizedBox(width: 12),
          _CategoryFilterButton(
            label: l10n.birds,
            category: PetCategory.birds,
            isSelected: _selectedCategory == PetCategory.birds,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.birds;
              });
            },
          ),
          const SizedBox(width: 12),
          _CategoryFilterButton(
            label: l10n.rabbits,
            category: PetCategory.rabbits,
            isSelected: _selectedCategory == PetCategory.rabbits,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.rabbits;
              });
            },
          ),
          const SizedBox(width: 12),
          _CategoryFilterButton(
            label: l10n.fish,
            category: PetCategory.fish,
            isSelected: _selectedCategory == PetCategory.fish,
            onTap: () {
              setState(() {
                _selectedCategory = PetCategory.fish;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _CategoryFilterButton extends StatelessWidget {
  const _CategoryFilterButton({
    required this.label,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final PetCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7BAF7B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF7BAF7B) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
