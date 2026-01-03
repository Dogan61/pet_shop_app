import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/favorites_constants.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/controller/favorites_controller.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/favorites/widgets/favorites_card.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  int _currentIndex = 1; // Favorites index

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

    final favoritesData = FavoritesController.getFavoritesData();
    final isEmpty = FavoritesController.isEmpty(favoritesData);

    return Scaffold(
      appBar: BackAppBar(
        title: l10n.favorites,
      ),
      body: isEmpty
          ? _EmptyFavoritesState()
          : _FavoritesList(
              favoritesData: favoritesData,
              onFavoriteRemoved: () {
                setState(() {});
              },
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
}

class _EmptyFavoritesState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: AppDimensionsSize.extraLarge(context),
            color: FavoritesConstants.grey,
          ),
          SizedBox(height: AppDimensionsSpacing.medium(context)),
          Text(
            l10n?.emptyFavorites ??
                FavoritesConstants.localizationsNotAvailable,
            style: TextStyle(
              fontSize: AppDimensionsFontSize.medium(context),
              color: FavoritesConstants.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesList extends StatelessWidget {
  const _FavoritesList({
    required this.favoritesData,
    required this.onFavoriteRemoved,
  });

  final List<Map<String, String>> favoritesData;
  final VoidCallback onFavoriteRemoved;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: AppDimensionsPadding.allMedium(context),
      itemCount: favoritesData.length,
      itemBuilder: (context, index) {
        final data = favoritesData[index];
        final imageUrl = data['imageUrl'];
        final name = data['name'];
        final breed = data['breed'];
        final age = data['age'];
        final distance = data['distance'];
        final petIndex = int.tryParse(data['index'] ?? '0') ?? 0;

        if (imageUrl == null ||
            name == null ||
            breed == null ||
            age == null ||
            distance == null) {
          return const SizedBox.shrink();
        }

        return FavoritesCard(
          index: petIndex,
          imageUrl: imageUrl,
          name: name,
          breed: breed,
          age: age,
          distance: distance,
          onFavoriteRemoved: onFavoriteRemoved,
        );
      },
    );
  }
}
