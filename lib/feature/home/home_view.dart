import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/favorites_constants.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/image_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/pet_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/controller/favorites_controller.dart';
import 'package:pet_shop_app/core/models/pet_category.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/login/login_view.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PetCategory _selectedCategory = PetCategory.all;
  int _currentIndex = 0;

  void Function(int) _onBottomNavTap(BuildContext context) {
    return BottomNavigationItems.createRouteHandler(
      context,
      setState,
      (index) => _currentIndex = index,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
          body: Center(child: Text(UIConstants.localizationsNotAvailable)));
    }
    return Scaffold(
      appBar: const EmptyAppBar(),
      body: SafeArea(
        child: Padding(
          padding: AppDimensionsPadding.allMedium(context),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  width: AppDimensionsSize.avatarSize(context),
                  height: AppDimensionsSize.avatarSize(context),
                  decoration: BoxDecoration(
                    borderRadius: AppDimensionsRadius.circularMedium(context),
                    border: Border.all(
                      color: HomeConstants.avatarBorderColor,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(LoginConstants.loginImageHeader),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(l10n.helloAgain),
                subtitle: Text(
                  l10n.findYourBestFriend,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: AppDimensionsFontSize.large(context),
                      ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: HomeConstants.grey200,
                    borderRadius: AppDimensionsRadius.circularSmall(context),
                  ),
                  child: const Icon(Icons.notifications),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: AppDimensionsSpacing.medium(context),
                  bottom: AppDimensionsSpacing.medium(context),
                ),
                child: SearchBar(
                  backgroundColor: WidgetStateProperty.all(HomeConstants.white),
                  hintText: l10n.searchByBreedOrName,
                  leading: const Icon(Icons.search),
                  padding: WidgetStateProperty.all(
                    AppDimensionsPadding.symmetricHorizontalMedium(context),
                  ),
                  trailing: const [Icon(Icons.outlined_flag)],
                ),
              ),
              // Filter buttons with horizontal scroll
              customFilterSection(),
              AppDimensionsSpacing.verticalMedium(context),
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
                child: HomeCustomGrid(
                  selectedCategory: _selectedCategory,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap(context),
        selectedItemColor: HomeConstants.primaryColor,
        unselectedItemColor: HomeConstants.grey,
        items: BottomNavigationItems.getItems(),
      ),
    );
  }

  Widget customFilterSection() {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: AppDimensionsSize.filterSectionHeight(context),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
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
          AppDimensionsSpacing.horizontalSmall(context),
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
          AppDimensionsSpacing.horizontalSmall(context),
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
          AppDimensionsSpacing.horizontalSmall(context),
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
          AppDimensionsSpacing.horizontalSmall(context),
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
          AppDimensionsSpacing.horizontalSmall(context),
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

class HomeCustomGrid extends StatelessWidget {
  const HomeCustomGrid({
    required this.selectedCategory,
    super.key,
  });

  final PetCategory selectedCategory;

  @override
  Widget build(BuildContext context) {
    const petImages = ImageConstants.petImages;
    final filteredIndices = _filterPetsByCategory();

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: AppDimensionsPadding.allMedium(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppDimensionsGrid.crossAxisCount(context),
        crossAxisSpacing: AppDimensionsGrid.spacing(context),
        mainAxisSpacing: AppDimensionsGrid.spacing(context),
        childAspectRatio: 0.67,
      ),
      itemCount: filteredIndices.length,
      itemBuilder: (context, index) {
        final petIndex = filteredIndices[index];
        final imageUrl = petImages[petIndex % petImages.length];
        return _PetCard(
          imageUrl: imageUrl,
          index: petIndex,
        );
      },
    );
  }

  /// Filter pets by selected category and return their indices
  List<int> _filterPetsByCategory() {
    if (selectedCategory == PetCategory.all) {
      // Show all pets (using a reasonable number for display)
      return List.generate(10, (index) => index);
    }

    final filtered = <int>[];
    // Check each pet breed to determine category
    for (var i = 0; i < PetConstants.petBreeds.length; i++) {
      final breed = PetConstants.petBreeds[i];
      final petCategory = _getCategoryFromBreed(breed);

      if (petCategory == selectedCategory) {
        filtered.add(i);
      }
    }

    return filtered;
  }

  /// Get category from breed name
  PetCategory _getCategoryFromBreed(String breed) {
    final breedUpper = breed.toUpperCase();
    if (breedUpper.contains('RETRIEVER') ||
        breedUpper.contains('LABRADOR') ||
        breedUpper.contains('SHEPHERD') ||
        breedUpper.contains('BULLDOG') ||
        breedUpper.contains('BEAGLE')) {
      return PetCategory.dogs;
    } else if (breedUpper.contains('PERSIAN') ||
        breedUpper.contains('SIAMESE') ||
        breedUpper.contains('MAINE COON') ||
        breedUpper.contains('RAGDOLL') ||
        breedUpper.contains('BRITISH SHORTHAIR')) {
      return PetCategory.cats;
    } else if (breedUpper.contains('BIRD') ||
        breedUpper.contains('PARROT') ||
        breedUpper.contains('CANARY')) {
      return PetCategory.birds;
    } else if (breedUpper.contains('RABBIT') || breedUpper.contains('BUNNY')) {
      return PetCategory.rabbits;
    } else if (breedUpper.contains('FISH') || breedUpper.contains('GOLDFISH')) {
      return PetCategory.fish;
    }
    return PetCategory.all;
  }
}

class _PetCard extends StatefulWidget {
  const _PetCard({
    required this.imageUrl,
    required this.index,
  });

  final String imageUrl;
  final int index;

  @override
  State<_PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<_PetCard> {
  @override
  Widget build(BuildContext context) {
    final isFavorite = FavoritesController.isFavorite(widget.index);

    return GestureDetector(
      onTap: () {
        context.push('/pet-detail/${widget.index}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: HomeConstants.white,
          borderRadius: AppDimensionsRadius.circularMedium(context),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main pet image - circular
                      Container(
                        width: AppDimensions.widthPercent(context, 35),
                        height: AppDimensions.widthPercent(context, 35),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: HomeConstants.white,
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(widget.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Distance badge (bottom left)
                      Positioned(
                        bottom: AppDimensionsPadding.small(context),
                        left: AppDimensionsPadding.small(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensionsPadding.small(context),
                            vertical: AppDimensionsPadding.extraSmall(context),
                          ),
                          decoration: BoxDecoration(
                            color: HomeConstants.white,
                            borderRadius:
                                AppDimensionsRadius.circularSmall(context),
                            border: Border.all(
                                color: HomeConstants.locationIconColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: HomeConstants.locationIconColor,
                                size: AppDimensionsSize.iconSizeSmall(context),
                              ),
                              SizedBox(
                                width:
                                    AppDimensionsSpacing.extraSmall(context) /
                                        2,
                              ),
                              Text(
                                PetConstants.distances[
                                    widget.index % PetConstants.distances.length],
                                style: TextStyle(
                                  color: HomeConstants.distanceTextColor,
                                  fontSize:
                                      AppDimensionsFontSize.extraSmall(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Pet info section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensionsPadding.small(context),
                    vertical: AppDimensionsPadding.extraSmall(context) * 0.5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and gender icon row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              PetConstants.petNames[
                                  widget.index % PetConstants.petNames.length],
                              style: TextStyle(
                                fontSize: AppDimensionsFontSize.medium(context),
                                fontWeight: FontWeight.bold,
                                color: HomeConstants.darkTextColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            width: AppDimensionsSpacing.extraSmall(context),
                          ),
                          Container(
                            width: AppDimensionsSize.iconSizeSmall(context),
                            height: AppDimensionsSize.iconSizeSmall(context),
                            decoration: const BoxDecoration(
                              color: HomeConstants.genderIconColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.male,
                              color: HomeConstants.white,
                              size: AppDimensionsSize.iconSizeSmall(context) *
                                  0.7,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              AppDimensionsSpacing.extraSmall(context) * 0.3),
                      // Breed
                      Text(
                        PetConstants
                            .petBreeds[widget.index % PetConstants.petBreeds.length],
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.extraSmall(context),
                          fontWeight: FontWeight.w600,
                          color: HomeConstants.breedTextColor,
                          letterSpacing: 0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                          height:
                              AppDimensionsSpacing.extraSmall(context) * 0.3),
                      // Age
                      Text(
                        PetConstants
                            .petAges[widget.index % PetConstants.petAges.length],
                        style: TextStyle(
                          fontSize:
                              AppDimensionsFontSize.extraSmall(context) * 0.9,
                          color: HomeConstants.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Favorite button (top right) - on outer container
            Positioned(
              top: AppDimensionsPadding.small(context),
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    FavoritesController.toggleFavorite(widget.index);
                  });
                },
                child: Container(
                  width: AppDimensionsSize.iconSizeMedium(context),
                  height: AppDimensionsSize.iconSizeMedium(context),
                  decoration: BoxDecoration(
                    color: isFavorite
                        ? FavoritesConstants.red
                        : HomeConstants.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: HomeConstants.white,
                    size: AppDimensionsSize.iconSizeSmall(context),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensionsPadding.extraSmall(context),
          vertical: AppDimensionsPadding.extraSmall(context),
        ),
        height: AppDimensionsSize.filterButtonHeight(context),
        decoration: BoxDecoration(
          color: isSelected ? HomeConstants.primaryColor : HomeConstants.white,
          borderRadius: AppDimensionsRadius.circularMedium(context),
          border: Border.all(
            color:
                isSelected ? HomeConstants.primaryColor : HomeConstants.grey300,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: AppDimensionsSize.iconSizeSmall(context),
              color: isSelected ? HomeConstants.white : HomeConstants.grey600,
            ),
            AppDimensionsSpacing.horizontalSmall(context),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? HomeConstants.white : HomeConstants.grey700,
                fontWeight: FontWeight.w600,
                fontSize: AppDimensionsFontSize.medium(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
