import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/favorites_constants.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/ui_constants.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';
import 'package:pet_shop_app/feature/favorite/mixins/favorites_mixin.dart';
import 'package:pet_shop_app/feature/favorite/models/favorite_model.dart';
import 'package:pet_shop_app/feature/favorite/widgets/favorites_card.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> with FavoritesMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: Text(UIConstants.localizationsNotAvailable)),
      );
    }

    return BlocProvider(
      create: (context) => di.sl<FavoriteCubit>(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isAuthenticated = isUserAuthenticated(authState);
          final token = extractToken(authState);

          if (isAuthenticated && token != null) {
            loadFavoritesOnce(context: context, token: token);
          }

          if (!isAuthenticated || token == null) {
            return Scaffold(
              appBar: BackAppBar(title: l10n.favorites),
              body: const Center(child: Text('Please login to view favorites')),
            );
          }

          return Scaffold(
            appBar: BackAppBar(title: l10n.favorites),
            body: BlocConsumer<FavoriteCubit, FavoriteState>(
              listener: (context, state) {
                if (state is FavoriteError) {
                  handleFavoriteError(context, state);
                }
              },
              builder: (context, state) {
                if (state is FavoriteLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FavoriteLoaded) {
                  if (state.favorites.isEmpty) {
                    return _EmptyFavoritesState();
                  }

                  return _FavoritesList(
                    favorites: state.favorites,
                    token: token,
                  );
                }

                if (state is FavoriteError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<FavoriteCubit>().getFavorites(token);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return _EmptyFavoritesState();
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: createBottomNavTapHandler(context),
              selectedItemColor: HomeConstants.primaryColor,
              unselectedItemColor: HomeConstants.grey,
              items: BottomNavigationItems.getItems(),
            ),
          );
        },
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
  const _FavoritesList({required this.favorites, required this.token});

  final List<FavoriteModel> favorites;
  final String token;

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoriteCubit>();

    return ListView.builder(
      padding: AppDimensionsPadding.allMedium(context),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final favorite = favorites[index];
        final pet = favorite.pet;

        if (pet == null) {
          return const SizedBox.shrink();
        }

        return FavoritesCard(
          favoriteId: favorite.id,
          petId: pet.id,
          imageUrl: pet.imageUrl,
          name: pet.name,
          breed: pet.breed,
          age: pet.age,
          distance: pet.distance,
          onFavoriteRemoved: () {
            favoriteCubit.removeFavorite(favorite.id, token);
          },
        );
      },
    );
  }
}
