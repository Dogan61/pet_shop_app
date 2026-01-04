import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/favorites_constants.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/core/models/pet_category.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';
import 'package:pet_shop_app/feature/login/login_view.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';
import 'package:pet_shop_app/feature/pet/models/pet_model.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PetCategory _selectedCategory = PetCategory.all;
  int _currentIndex = 0;
  bool _hasLoadedFavorites = false;

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
        body: Center(child: Text(UIConstants.localizationsNotAvailable)),
      );
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<PetCubit>()..getAllPets()),
        BlocProvider(create: (context) => di.sl<FavoriteCubit>()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          // Load favorites once when authenticated
          if (authState is AuthAuthenticated && !_hasLoadedFavorites) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.read<FavoriteCubit>().getFavorites(authState.token);
                setState(() {
                  _hasLoadedFavorites = true;
                });
              }
            });
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
                          borderRadius: AppDimensionsRadius.circularMedium(
                            context,
                          ),
                          border: Border.all(
                            color: HomeConstants.avatarBorderColor,
                          ),
                          image: const DecorationImage(
                            image: NetworkImage(
                              LoginConstants.loginImageHeader,
                            ),
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
                          borderRadius: AppDimensionsRadius.circularSmall(
                            context,
                          ),
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
                        backgroundColor: WidgetStateProperty.all(
                          HomeConstants.white,
                        ),
                        hintText: l10n.searchByBreedOrName,
                        leading: const Icon(Icons.search),
                        padding: WidgetStateProperty.all(
                          AppDimensionsPadding.symmetricHorizontalMedium(
                            context,
                          ),
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
                        TextButton(onPressed: () {}, child: Text(l10n.seeAll)),
                      ],
                    ),
                    Expanded(
                      child: HomeCustomGrid(
                        selectedCategory: _selectedCategory,
                        token: authState is AuthAuthenticated
                            ? authState.token
                            : null,
                      ),
                    ),
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
        },
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
  const HomeCustomGrid({required this.selectedCategory, this.token, super.key});

  final PetCategory selectedCategory;
  final String? token;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetCubit, PetState>(
      builder: (context, state) {
        if (state is PetLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PetError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PetCubit>().getAllPets();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is PetLoaded) {
          final pets = state.pets;

          // Filter pets by category
          final filteredPets = selectedCategory == PetCategory.all
              ? pets
              : pets
                    .where((pet) => pet.category == selectedCategory.name)
                    .toList();

          if (filteredPets.isEmpty) {
            return Center(
              child: Text(
                'No pets found in ${selectedCategory.name} category',
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.medium(context),
                  color: HomeConstants.grey,
                ),
              ),
            );
          }

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
            itemCount: filteredPets.length,
            itemBuilder: (context, index) {
              final pet = filteredPets[index];
              return _PetCard(pet: pet, token: token);
            },
          );
        }

        return const Center(child: Text('No data'));
      },
    );
  }
}

class _PetCard extends StatefulWidget {
  const _PetCard({required this.pet, this.token});

  final PetModel pet;
  final String? token;

  @override
  State<_PetCard> createState() => _PetCardState();
}

class _PetCardState extends State<_PetCard> {
  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoriteCubit>();

    return GestureDetector(
      onTap: () {
        context.push('/pet-detail/${widget.pet.id}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: HomeConstants.white,
          borderRadius: AppDimensionsRadius.circularMedium(context),
          boxShadow: const [BoxShadow(blurRadius: 1, offset: Offset(0, 2))],
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
                            image: NetworkImage(widget.pet.imageUrl),
                            fit: BoxFit.cover,
                            onError: (_, _) {},
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
                            borderRadius: AppDimensionsRadius.circularSmall(
                              context,
                            ),
                            border: Border.all(
                              color: HomeConstants.locationIconColor,
                            ),
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
                                widget.pet.distance,
                                style: TextStyle(
                                  color: HomeConstants.distanceTextColor,
                                  fontSize: AppDimensionsFontSize.extraSmall(
                                    context,
                                  ),
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
                              widget.pet.name,
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
                              size:
                                  AppDimensionsSize.iconSizeSmall(context) *
                                  0.7,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: AppDimensionsSpacing.extraSmall(context) * 0.3,
                      ),
                      // Breed
                      Text(
                        widget.pet.breed,
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
                        height: AppDimensionsSpacing.extraSmall(context) * 0.3,
                      ),
                      // Age
                      Text(
                        widget.pet.age,
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
            if (widget.token != null)
              Positioned(
                top: AppDimensionsPadding.small(context),
                right: 0,
                child: BlocBuilder<FavoriteCubit, FavoriteState>(
                  builder: (context, favoriteState) {
                    final isFav = favoriteCubit.isFavorite(widget.pet.id);
                    return GestureDetector(
                      onTap: () {
                        favoriteCubit.toggleFavoriteByPetId(
                          widget.pet.id,
                          widget.token!,
                        );
                      },
                      child: Container(
                        width: AppDimensionsSize.iconSizeMedium(context),
                        height: AppDimensionsSize.iconSizeMedium(context),
                        decoration: BoxDecoration(
                          color: isFav
                              ? FavoritesConstants.red
                              : HomeConstants.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: HomeConstants.white,
                          size: AppDimensionsSize.iconSizeSmall(context),
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
            color: isSelected
                ? HomeConstants.primaryColor
                : HomeConstants.grey300,
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
