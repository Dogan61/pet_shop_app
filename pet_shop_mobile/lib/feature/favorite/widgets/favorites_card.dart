import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/favorites_constants.dart';

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    required this.favoriteId,
    required this.petId,
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.age,
    required this.distance,
    this.onFavoriteRemoved,
    super.key,
  });
  final String favoriteId;
  final String petId;
  final String imageUrl;
  final String name;
  final String breed;
  final String age;
  final String distance;
  final VoidCallback? onFavoriteRemoved;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/pet-detail/$petId');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppDimensionsSpacing.medium(context)),
        decoration: BoxDecoration(
          color: FavoritesConstants.white,
          borderRadius: AppDimensionsRadius.circularMedium(context),
          boxShadow: const [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
              color: FavoritesConstants.shadowColor,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppDimensionsRadius.medium(context)),
                  ),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: AppDimensions.heightPercent(context, 20),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: AppDimensionsPadding.small(context),
                  right: AppDimensionsPadding.small(context),
                  child: GestureDetector(
                    onTap: () {
                      onFavoriteRemoved?.call();
                    },
                    child: Container(
                      width: AppDimensionsSize.iconSizeMedium(context),
                      height: AppDimensionsSize.iconSizeMedium(context),
                      decoration: const BoxDecoration(
                        color: FavoritesConstants.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: FavoritesConstants.white,
                        size: AppDimensionsSize.iconSizeSmall(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: AppDimensionsPadding.allMedium(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: AppDimensionsFontSize.medium(context),
                            fontWeight: FontWeight.bold,
                            color: FavoritesConstants.darkTextColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: AppDimensionsSpacing.small(context),
                      ),
                      Container(
                        width: AppDimensionsSize.iconSizeSmall(context),
                        height: AppDimensionsSize.iconSizeSmall(context),
                        decoration: const BoxDecoration(
                          color: FavoritesConstants.genderIconColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.male,
                          color: FavoritesConstants.white,
                          size: AppDimensionsSize.iconSizeSmall(context) * 0.7,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: AppDimensionsSpacing.small(context) * 0.3,
                  ),
                  Text(
                    breed,
                    style: TextStyle(
                      fontSize: AppDimensionsFontSize.small(context),
                      fontWeight: FontWeight.w600,
                      color: FavoritesConstants.breedTextColor,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: AppDimensionsSpacing.small(context) * 0.3,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: AppDimensionsSize.iconSizeSmall(context) * 0.8,
                        color: FavoritesConstants.grey,
                      ),
                      SizedBox(
                        width: AppDimensionsSpacing.small(context) * 0.3,
                      ),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.small(context) * 0.9,
                          color: FavoritesConstants.grey600,
                        ),
                      ),
                      SizedBox(
                        width: AppDimensionsSpacing.small(context),
                      ),
                      Text(
                        age,
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.small(context) * 0.9,
                          color: FavoritesConstants.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
