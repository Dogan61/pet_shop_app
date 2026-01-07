import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/core/models/pet_category.dart';
import 'package:pet_shop_app/feature/admin/pets/controllers/admin_pet_form_controller.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet/bloc/pet_state.dart';

class AdminPetFormView extends StatefulWidget {
  const AdminPetFormView({super.key, this.petId});

  final String? petId;

  @override
  State<AdminPetFormView> createState() => _AdminPetFormViewState();
}

class _AdminPetFormViewState extends State<AdminPetFormView> {
  late final AdminPetFormController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AdminPetFormController(petId: widget.petId);

    if (widget.petId != null) {
      // Load pet data for editing
      context.read<PetCubit>().getPetById(widget.petId!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<PetCubit>(),
      child: BlocListener<PetCubit, PetState>(
        listener: (context, state) {
          // Handle pet state changes
          if (_controller.shouldLoadPetData(state)) {
            final pet = _controller.getPetFromState(state);
            if (pet != null) {
              _controller.loadPetData(pet);
            }
          }

          // Show success message
          final successMessage = _controller.getSuccessMessage(state);
          if (successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(successMessage),
                backgroundColor: AdminConstants.addPetColor,
              ),
            );
            context.go(AdminConstants.adminPetsRoute);
          }

          // Show error message
          final errorMessage = _controller.getErrorMessage(state);
          if (errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AdminConstants.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              _controller.isEdit
                  ? AdminConstants.editPetTitle
                  : AdminConstants.addNewPetTitle,
            ),
            backgroundColor: AdminConstants.primaryColor,
            foregroundColor: AdminConstants.white,
          ),
          body: BlocBuilder<PetCubit, PetState>(
            builder: (context, state) {
              final isLoading = state is PetLoading;

              if (_controller.isEdit &&
                  state is PetDetailLoaded &&
                  _controller.nameController.text.isEmpty) {
                _controller.loadPetData(state.pet);
              }

              return SingleChildScrollView(
                padding: AppDimensionsPadding.allMedium(context),
                child: Form(
                  key: _controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildSectionTitle(AdminConstants.basicInformationTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.nameController,
                        label: AdminConstants.petNameLabel,
                        icon: Icons.pets,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.petNameRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.breedController,
                        label: AdminConstants.breedLabel,
                        icon: Icons.category,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.breedRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.ageController,
                        label: AdminConstants.ageLabel,
                        icon: Icons.calendar_today,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.ageRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildDropdown(
                        label: AdminConstants.genderLabel,
                        value: _controller.selectedGender,
                        items: AdminConstants.genderOptions,
                        onChanged: (value) =>
                            setState(() => _controller.selectedGender = value!),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildDropdown(
                        label: AdminConstants.categoryLabel,
                        value: _controller.selectedCategory,
                        items: PetCategory.values
                            .where((c) => c != PetCategory.all)
                            .map((c) => c.name)
                            .toList(),
                        onChanged: (value) => setState(
                          () => _controller.selectedCategory = value!,
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Physical Details
                      _buildSectionTitle(AdminConstants.physicalDetailsTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.weightController,
                        label: AdminConstants.weightLabel,
                        icon: Icons.scale,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.weightRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.colorController,
                        label: AdminConstants.colorLabel,
                        icon: Icons.palette,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.colorRequired,
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Location Details
                      _buildSectionTitle(AdminConstants.locationDetailsTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.locationController,
                        label: AdminConstants.locationLabel,
                        icon: Icons.location_on,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.locationRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.distanceController,
                        label: AdminConstants.distanceLabel,
                        icon: Icons.straighten,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.distanceRequired,
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Price & Image
                      _buildSectionTitle(AdminConstants.priceImageTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.priceController,
                        label: AdminConstants.priceLabel,
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                        validator: _controller.validatePrice,
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.imageUrlController,
                        label: AdminConstants.imageUrlLabel,
                        icon: Icons.image,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.imageUrlRequired,
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Description
                      _buildSectionTitle(AdminConstants.descriptionTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.descriptionController,
                        label: AdminConstants.descriptionLabel,
                        icon: Icons.description,
                        maxLines: 4,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.descriptionRequired,
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Owner Information
                      _buildSectionTitle(AdminConstants.ownerInformationTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.ownerNameController,
                        label: AdminConstants.ownerNameLabel,
                        icon: Icons.person,
                        validator: (value) => _controller.validateRequired(
                          value,
                          AdminConstants.ownerNameRequired,
                        ),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildTextField(
                        controller: _controller.ownerImageController,
                        label: AdminConstants.ownerImageUrlLabel,
                        icon: Icons.person_outline,
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Health Status
                      _buildSectionTitle(AdminConstants.healthStatusTitle),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildSwitch(
                        label: AdminConstants.vaccinesCompleteLabel,
                        value: _controller.vaccines,
                        onChanged: (value) =>
                            setState(() => _controller.vaccines = value),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildSwitch(
                        label: AdminConstants.neuteredLabel,
                        value: _controller.neutered,
                        onChanged: (value) =>
                            setState(() => _controller.neutered = value),
                      ),
                      AppDimensionsSpacing.verticalSmall(context),
                      _buildSwitch(
                        label: AdminConstants.healthRecordLabel,
                        value: _controller.healthRecord,
                        onChanged: (value) =>
                            setState(() => _controller.healthRecord = value),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: AppDimensionsSize.buttonHeight(context),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (!_controller.validateForm()) {
                                    return;
                                  }

                                  final authState = context
                                      .read<AuthCubit>()
                                      .state;
                                  if (!_controller.isUserAuthenticated(
                                    authState,
                                  )) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          AdminConstants.accessDenied,
                                        ),
                                        backgroundColor: AdminConstants.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final token = _controller.getAuthToken(
                                    authState,
                                  );
                                  if (token == null) {
                                    return;
                                  }

                                  final pet = _controller.buildPetModel();
                                  final petCubit = context.read<PetCubit>();

                                  if (_controller.isEdit) {
                                    petCubit.updatePet(
                                      _controller.petId!,
                                      pet,
                                      token,
                                    );
                                  } else {
                                    petCubit.createPet(pet, token);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdminConstants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  AppDimensionsRadius.circularExtraLarge(
                                    context,
                                  ),
                            ),
                            disabledBackgroundColor: AdminConstants.grey300,
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: AppDimensionsSize.iconSizeSmall(context),
                                  width: AppDimensionsSize.iconSizeSmall(context),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AdminConstants.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  _controller.isEdit
                                      ? AdminConstants.updatePetButton
                                      : AdminConstants.createPetButton,
                                  style: TextStyle(
                                    fontSize: AppDimensionsFontSize.medium(
                                      context,
                                    ),
                                    fontWeight: FontWeight.w600,
                                    color: AdminConstants.white,
                                  ),
                                ),
                        ),
                      ),

                      AppDimensionsSpacing.verticalLarge(context),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AdminConstants.primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AdminConstants.primaryColor),
        filled: true,
        fillColor: AdminConstants.lightBackground,
        border: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.lightGreen,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.primaryColor,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.red,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.red,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.list, color: AdminConstants.primaryColor),
        filled: true,
        fillColor: AdminConstants.lightBackground,
        border: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.lightGreen,
            width: AppDimensionsBorderWidth.normal(context),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensionsRadius.circularExtraLarge(context),
          borderSide: BorderSide(
            color: AdminConstants.primaryColor,
            width: AppDimensionsBorderWidth.thick(context),
          ),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item.toUpperCase()),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      child: SwitchListTile(
        title: Text(label),
        value: value,
        onChanged: onChanged,
        activeThumbColor: AdminConstants.primaryColor,
      ),
    );
  }
}
