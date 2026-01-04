import 'package:pet_shop_app/core/constants/image_constants.dart';
import 'package:pet_shop_app/core/constants/pet_constants.dart';
import 'package:pet_shop_app/core/constants/pet_detail_constants.dart';

/// Business logic controller for pet detail page
class PetDetailController {
  PetDetailController._();

  /// Pet data model
  static PetData getPetData({
    int? index,
    String? imageUrl,
    String? name,
    String? breed,
    String? age,
    String? distance,
    String? location,
    String? gender,
    String? weight,
    String? color,
    String? price,
    String? ownerName,
    String? ownerImage,
    String? description,
  }) {
    final petIndex = index ?? 0;

    return PetData(
      imageUrl:
          imageUrl ??
          ImageConstants.petImages[petIndex % ImageConstants.petImages.length],
      name:
          name ??
          PetConstants.petNames[petIndex % PetConstants.petNames.length],
      breed:
          breed ??
          PetConstants.petBreeds[petIndex % PetConstants.petBreeds.length],
      age: age ?? PetConstants.petAges[petIndex % PetConstants.petAges.length],
      distance:
          distance ??
          PetConstants.distances[petIndex % PetConstants.distances.length],
      location: location ?? PetDetailConstants.defaultLocation,
      gender:
          gender ??
          (petIndex % 2 == 0
              ? PetDetailConstants.maleGender
              : PetDetailConstants.femaleGender),
      weight:
          weight ??
          '${PetDetailConstants.baseWeight + (petIndex * PetDetailConstants.weightIncrement)} kg',
      color:
          color ??
          (petIndex % 2 == 0
              ? PetDetailConstants.goldColor
              : PetDetailConstants.brownColor),
      price:
          price ??
          '₺${PetDetailConstants.basePrice + (petIndex * PetDetailConstants.priceIncrement)}',
      ownerName: ownerName ?? PetDetailConstants.defaultOwnerName,
      ownerImage: ownerImage ?? ImageConstants.imageAvatar,
      description:
          description ??
          PetDetailConstants.descriptionTemplate
              .replaceAll(
                '{name}',
                name ??
                    PetConstants.petNames[petIndex %
                        PetConstants.petNames.length],
              )
              .replaceAll(
                '{breed}',
                breed ??
                    PetConstants.petBreeds[petIndex %
                        PetConstants.petBreeds.length],
              ),
    );
  }
}

/// Pet data model
class PetData {
  const PetData({
    required this.imageUrl,
    required this.name,
    required this.breed,
    required this.age,
    required this.distance,
    required this.location,
    required this.gender,
    required this.weight,
    required this.color,
    required this.price,
    required this.ownerName,
    required this.ownerImage,
    required this.description,
  });

  final String imageUrl;
  final String name;
  final String breed;
  final String age;
  final String distance;
  final String location;
  final String gender;
  final String weight;
  final String color;
  final String price;
  final String ownerName;
  final String ownerImage;
  final String description;
}
