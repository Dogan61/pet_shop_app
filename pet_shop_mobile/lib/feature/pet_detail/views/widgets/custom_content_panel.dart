import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/pet_detail_constants.dart';

class CustomContentPanel extends StatelessWidget {
  const CustomContentPanel({
    required this.petName,
    required this.petLocation,
    required this.petDistance,
    required this.petBreed,
    required this.petAge,
    required this.petGender,
    required this.petWeight,
    required this.petColor,
    required this.petOwnerImage,
    required this.petOwnerName,
    required this.petDescription,
    super.key,
  });

  final String petName;
  final String petLocation;
  final String petDistance;
  final String petBreed;
  final String petAge;
  final String petGender;
  final String petWeight;
  final String petColor;
  final String petOwnerImage;
  final String petOwnerName;
  final String petDescription;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        transform: Matrix4.translationValues(0, -40, 0),
        decoration: BoxDecoration(
          color: PetDetailConstants.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensionsRadius.extraLarge(context)),
          ),
          boxShadow: const [
            BoxShadow(
              color: PetDetailConstants.shadowColor,
              blurRadius: 20,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: Padding(
          padding: AppDimensionsPadding.allLarge(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: AppDimensions.widthPercent(context, 12),
                  height: AppDimensions.heightPercent(context, 0.6),
                  decoration: BoxDecoration(
                    color: PetDetailConstants.grey300,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              SizedBox(height: AppDimensionsSpacing.medium(context)),

              // Title and Breed
              PetTitle(
                petName: petName,
                petLocation: petLocation,
                petDistance: petDistance,
                petBreed: petBreed,
              ),
              SizedBox(height: AppDimensionsSpacing.large(context)),

              // Horizontal Info Cards
              InfoCard(
                petAge: petAge,
                petGender: petGender,
                petWeight: petWeight,
                petColor: petColor,
              ),
              SizedBox(height: AppDimensionsSpacing.large(context)),

              // Owner Card
              OwnerCard(
                petOwnerImage: petOwnerImage,
                petOwnerName: petOwnerName,
              ),
              SizedBox(height: AppDimensionsSpacing.large(context)),

              // Description
              Text(
                '$petName ${PetDetailConstants.aboutLabel}',
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.large(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensionsSpacing.small(context)),
              Text(
                petDescription,
                style: TextStyle(
                  color: PetDetailConstants.grey700,
                  fontSize: AppDimensionsFontSize.medium(context),
                  height: 1.6,
                ),
              ),
              SizedBox(height: AppDimensionsSpacing.large(context)),

              // Health Status
              Text(
                PetDetailConstants.healthStatusLabel,
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.large(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensionsSpacing.medium(context)),
              _HealthStatusItem(
                icon: Icons.vaccines,
                label: PetDetailConstants.allVaccinesComplete,
                color: PetDetailConstants.vaccinesColor,
                context: context,
              ),
              _HealthStatusItem(
                icon: Icons.medical_services,
                label: PetDetailConstants.neutered,
                color: PetDetailConstants.neuteredColor,
                context: context,
              ),
              _HealthStatusItem(
                icon: Icons.content_paste,
                label: PetDetailConstants.healthRecordAvailable,
                color: PetDetailConstants.healthRecordColor,
                context: context,
              ),
              SizedBox(height: AppDimensions.heightPercent(context, 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class PetTitle extends StatelessWidget {
  const PetTitle({
    required this.petName,
    required this.petLocation,
    required this.petDistance,
    required this.petBreed,
    super.key,
  });

  final String petName;
  final String petLocation;
  final String petDistance;
  final String petBreed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                petName,
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.extraLarge(context) * 1.5,
                  fontWeight: FontWeight.bold,
                  color: PetDetailConstants.darkTextColor,
                ),
              ),
              SizedBox(height: AppDimensionsSpacing.extraSmall(context) * 0.5),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: AppDimensionsSize.iconSizeSmall(context),
                    color: PetDetailConstants.grey,
                  ),
                  SizedBox(
                    width: AppDimensionsSpacing.extraSmall(context) * 0.3,
                  ),
                  Text(
                    '$petLocation • $petDistance',
                    style: TextStyle(
                      color: PetDetailConstants.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: AppDimensionsFontSize.small(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(
              Icons.pets,
              color: PetDetailConstants.primaryColor,
              size: AppDimensionsSize.iconSizeLarge(context),
            ),
            SizedBox(height: AppDimensionsSpacing.extraSmall(context) * 0.3),
            Text(
              petBreed,
              style: TextStyle(
                fontSize: AppDimensionsFontSize.extraSmall(context),
                fontWeight: FontWeight.w800,
                color: PetDetailConstants.grey,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.petAge,
    required this.petGender,
    required this.petWeight,
    required this.petColor,
    super.key,
  });

  final String petAge;
  final String petGender;
  final String petWeight;
  final String petColor;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _InfoCard(
            icon: Icons.cake,
            color: PetDetailConstants.ageIconColor,
            label: PetDetailConstants.ageLabel,
            value: petAge,
            context: context,
          ),
          SizedBox(width: AppDimensionsSpacing.small(context)),
          _InfoCard(
            icon: Icons.male,
            color: PetDetailConstants.genderIconColor,
            label: PetDetailConstants.genderLabel,
            value: petGender,
            context: context,
          ),
          SizedBox(width: AppDimensionsSpacing.small(context)),
          _InfoCard(
            icon: Icons.monitor_weight,
            color: PetDetailConstants.weightIconColor,
            label: PetDetailConstants.weightLabel,
            value: petWeight,
            context: context,
          ),
          SizedBox(width: AppDimensionsSpacing.small(context)),
          _InfoCard(
            icon: Icons.palette,
            color: PetDetailConstants.primaryColor,
            label: PetDetailConstants.colorLabel,
            value: petColor,
            context: context,
          ),
        ],
      ),
    );
  }
}

class OwnerCard extends StatelessWidget {
  const OwnerCard({
    required this.petOwnerImage,
    required this.petOwnerName,
    super.key,
  });

  final String petOwnerImage;
  final String petOwnerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimensionsPadding.allMedium(context),
      decoration: BoxDecoration(
        color: PetDetailConstants.white,
        borderRadius: AppDimensionsRadius.circularLarge(context),
        border: Border.all(color: PetDetailConstants.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppDimensionsSize.iconSizeLarge(context),
            backgroundImage: petOwnerImage.isNotEmpty
                ? NetworkImage(petOwnerImage)
                : null,
            child: petOwnerImage.isEmpty ? const Icon(Icons.person) : null,
          ),
          SizedBox(width: AppDimensionsSpacing.medium(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  petOwnerName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensionsFontSize.medium(context),
                  ),
                ),
                Text(
                  PetDetailConstants.ownerLabel,
                  style: TextStyle(
                    color: PetDetailConstants.grey,
                    fontSize: AppDimensionsFontSize.small(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppDimensionsPadding.medium(context)),
            decoration: const BoxDecoration(
              color: PetDetailConstants.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              color: PetDetailConstants.white,
              size: AppDimensionsSize.iconSizeSmall(context),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget: Info Card
class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.context,
  });
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensionsPadding.medium(context),
        vertical: AppDimensionsPadding.small(context),
      ),
      decoration: BoxDecoration(
        color: PetDetailConstants.white,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        border: Border.all(color: PetDetailConstants.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: AppDimensionsSize.iconSizeMedium(context),
          ),
          SizedBox(width: AppDimensionsSpacing.small(context)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.extraSmall(context) * 0.8,
                  fontWeight: FontWeight.w800,
                  color: PetDetailConstants.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: AppDimensionsFontSize.small(context),
                  fontWeight: FontWeight.bold,
                  color: PetDetailConstants.lightTextColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper Widget: Health Status Item
class _HealthStatusItem extends StatelessWidget {
  const _HealthStatusItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.context,
  });
  final IconData icon;
  final String label;
  final Color color;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensionsSpacing.small(context)),
      padding: AppDimensionsPadding.allSmall(context),
      decoration: BoxDecoration(
        color: PetDetailConstants.white,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        border: Border.all(color: PetDetailConstants.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              icon,
              color: color,
              size: AppDimensionsSize.iconSizeSmall(context) * 0.9,
            ),
          ),
          SizedBox(width: AppDimensionsSpacing.small(context)),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: PetDetailConstants.lightTextColor,
              fontSize: AppDimensionsFontSize.small(context),
            ),
          ),
          const Spacer(),
          Icon(
            Icons.check_circle,
            color: PetDetailConstants.successColor,
            size: AppDimensionsSize.iconSizeSmall(context),
          ),
        ],
      ),
    );
  }
}
