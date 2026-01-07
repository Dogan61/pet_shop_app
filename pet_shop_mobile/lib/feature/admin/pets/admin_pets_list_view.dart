import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/feature/admin/pets/mixins/admin_pets_list_mixin.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';

class AdminPetsListView extends StatefulWidget {
  const AdminPetsListView({super.key});

  @override
  State<AdminPetsListView> createState() => _AdminPetsListViewState();
}

class _AdminPetsListViewState extends State<AdminPetsListView>
    with AdminPetsListMixin {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<PetCubit>().getAllPets();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PetCubit>()..getAllPets(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AdminConstants.managePetsTitleAppBar),
          backgroundColor: AdminConstants.primaryColor,
          foregroundColor: AdminConstants.white,
          actions: [
            IconButton(
              icon: const Icon(AdminConstants.addIcon),
              onPressed: () => navigateToAddPet(context),
            ),
          ],
        ),
        body: BlocConsumer<PetCubit, PetState>(
          listener: handlePetState,
          builder: (context, state) {
            if (state is PetLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PetLoaded) {
              final pets = state.pets;

              if (pets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AdminConstants.petsIcon,
                        size: AppDimensionsSize.extraLarge(context) * 2,
                        color: AdminConstants.grey300,
                      ),
                      AppDimensionsSpacing.verticalMedium(context),
                      Text(
                        AdminConstants.noPetsFound,
                        style: TextStyle(
                          fontSize: AppDimensionsFontSize.large(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      ElevatedButton(
                        onPressed: () => navigateToAddPet(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminConstants.primaryColor,
                        ),
                        child: const Text(AdminConstants.addFirstPet),
                      ),
                    ],
                  ),
                );
              }

              final token = getAuthToken(context);

              return ListView.builder(
                padding: AppDimensionsPadding.allMedium(context),
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Card(
                    margin: EdgeInsets.only(
                      bottom: AppDimensionsSpacing.small(context),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(pet.imageUrl),
                        onBackgroundImageError: (_, _) {},
                        child: const Icon(Icons.pets),
                      ),
                      title: Text(
                        pet.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Breed: ${pet.breed}'),
                          Text('Category: ${pet.category}'),
                          Text('Price: ₺${pet.price.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              AdminConstants.editIcon,
                              color: AdminConstants.managePetsColor,
                            ),
                            onPressed: () => navigateToEditPet(context, pet.id),
                          ),
                          IconButton(
                            icon: const Icon(
                              AdminConstants.deleteIcon,
                              color: AdminConstants.red,
                            ),
                            onPressed: () =>
                                showDeleteDialog(context, pet.id, token),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is PetError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: AppDimensionsSize.extraLarge(context) * 2,
                      color: AdminConstants.red,
                    ),
                    AppDimensionsSpacing.verticalMedium(context),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDimensionsFontSize.medium(context),
                      ),
                    ),
                    AppDimensionsSpacing.verticalMedium(context),
                    ElevatedButton(
                      onPressed: () {
                        final authState = context.read<AuthCubit>().state;
                        if (authState is AuthAuthenticated) {
                          context.read<PetCubit>().getAllPets();
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No data'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => navigateToAddPet(context),
          backgroundColor: AdminConstants.primaryColor,
          child: const Icon(
            AdminConstants.addIcon,
            color: AdminConstants.white,
          ),
        ),
      ),
    );
  }
}
