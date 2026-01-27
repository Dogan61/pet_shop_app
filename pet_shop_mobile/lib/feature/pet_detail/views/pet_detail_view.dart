import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/pet_detail_constants.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_cubit.dart';
import 'package:pet_shop_app/feature/favorite/bloc/favorite_state.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_state.dart';
import 'package:pet_shop_app/feature/pet_detail/mixins/pet_detail_mixin.dart';
import 'package:pet_shop_app/feature/pet_detail/models/pet_model.dart';
import 'package:pet_shop_app/feature/pet_detail/views/widgets/custom_content_panel.dart';

class PetDetailView extends StatefulWidget {
  const PetDetailView({required this.petId, super.key});

  final String petId;

  @override
  State<PetDetailView> createState() => _PetDetailViewState();
}

class _PetDetailViewState extends State<PetDetailView> with PetDetailMixin {
  bool _hasLoadedData = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<PetCubit>()),
        BlocProvider(create: (context) => di.sl<FavoriteCubit>()),
      ],
      child: Builder(
        builder: (context) {
          loadPetDetailAndFavoritesOnce(
            context: context,
            petId: widget.petId,
            hasLoadedData: _hasLoadedData,
            markLoaded: () {
              if (!mounted) return;
              setState(() {
                _hasLoadedData = true;
              });
            },
          );

          return _PetDetailContent(petId: widget.petId);
        },
      ),
    );
  }
}

class _PetDetailContent extends StatelessWidget {
  const _PetDetailContent({required this.petId});

  final String petId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final token = authState is AuthAuthenticated ? authState.token : null;

        return BlocBuilder<PetCubit, PetState>(
          builder: (context, petState) {
            if (petState is PetLoading) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                body: const Center(child: CircularProgressIndicator()),
              );
            }
            if (petState is PetError) {
              return PetErrorView(
                petId: petId,
                message: petState.message,
              );
            }
            if (petState is PetDetailLoaded) {
              final pet = petState.pet;
              final favoriteCubit = context.read<FavoriteCubit>();
              return PetLoaded(
                token: token,
                favoriteCubit: favoriteCubit,
                pet: pet,
              );
            }
            return const PetNoData();
          },
        );
      },
    );
  }
}

class PetNoData extends StatelessWidget {
  const PetNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('No data')),
    );
  }
}

class PetLoaded extends StatelessWidget {
  const PetLoaded({
    required this.token,
    required this.favoriteCubit,
    required this.pet,
    super.key,
  });

  final String? token;
  final FavoriteCubit favoriteCubit;
  final PetModel pet;

  @override
  Widget build(BuildContext context) {
    // Create a local copy so that null-check promotion works correctly.
    final currentToken = token;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverAppBar(
            expandedHeight: AppDimensions.heightPercent(context, 50),
            stretch: true,
            iconTheme: const IconThemeData(color: PetDetailConstants.white),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: PetDetailConstants.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: currentToken != null
                ? [
                    BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, favoriteState) {
                        final isFav = favoriteCubit.isFavorite(pet.id);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: PetDetailConstants.white,
                          ),
                          onPressed: () {
                            favoriteCubit.toggleFavoriteByPetId(
                              pet.id,
                              currentToken,
                            );
                          },
                        );
                      },
                    ),
                  ]
                : [],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    pet.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: PetDetailConstants.grey300,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: PetDetailConstants.white,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          PetDetailConstants.transparent,
                          PetDetailConstants.gradientOverlayColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content Panel
          CustomContentPanel(
            petName: pet.name,
            petLocation: pet.location,
            petDistance: pet.distance,
            petBreed: pet.breed,
            petAge: pet.age,
            petGender: pet.gender,
            petWeight: pet.weight,
            petColor: pet.color,
            petOwnerImage: pet.owner?.imageUrl ?? '',
            petOwnerName: pet.owner?.name ?? 'Unknown',
            petDescription: pet.description,
          ),
        ],
      ),
      bottomSheet: _BottomActionSheet(
        price: '₺${pet.price.toStringAsFixed(2)}',
        context: context,
      ),
    );
  }
}

class PetErrorView extends StatelessWidget {
  const PetErrorView({
    required this.petId,
    required this.message,
    super.key,
  });

  final String petId;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<PetCubit>().getPetById(petId);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Bottom Action Sheet
class _BottomActionSheet extends StatelessWidget {
  const _BottomActionSheet({required this.price, required this.context});
  final String price;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimensionsPadding.large(context),
        AppDimensionsPadding.medium(context),
        AppDimensionsPadding.large(context),
        AppDimensionsPadding.large(context) * 1.5,
      ),
      decoration: BoxDecoration(
        color: PetDetailConstants.bottomSheetBackground,
        border: const Border(
          top: BorderSide(color: PetDetailConstants.borderColor),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PetDetailConstants.adoptionFeeLabel,
                    style: TextStyle(
                      fontSize: AppDimensionsFontSize.extraSmall(context) * 0.8,
                      fontWeight: FontWeight.w800,
                      color: PetDetailConstants.grey,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: AppDimensionsFontSize.extraLarge(context) * 1.2,
                      fontWeight: FontWeight.bold,
                      color: PetDetailConstants.darkTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppDimensionsSpacing.medium(context)),
              Container(
                padding: EdgeInsets.all(AppDimensionsPadding.medium(context)),
                decoration: BoxDecoration(
                  border: Border.all(color: PetDetailConstants.grey200),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.forum_outlined,
                  color: PetDetailConstants.grey,
                  size: AppDimensionsSize.iconSizeSmall(context),
                ),
              ),
              SizedBox(width: AppDimensionsSpacing.small(context)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PetDetailConstants.successColor,
                    foregroundColor: PetDetailConstants.black,
                    elevation: 10,
                    shadowColor: PetDetailConstants.successShadowColor,
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensionsPadding.medium(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimensionsRadius.circularLarge(context),
                    ),
                  ),
                  child: Text(
                    PetDetailConstants.adoptNowButton,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimensionsFontSize.medium(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
