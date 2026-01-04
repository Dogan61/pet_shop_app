import 'package:flutter/material.dart';

/// Constants for Admin feature
class AdminConstants {
  AdminConstants._();

  // Route Constants
  static const String adminLoginRoute = '/admin/login';
  static const String adminDashboardRoute = '/admin/dashboard';
  static const String adminPetsRoute = '/admin/pets';
  static const String adminPetsAddRoute = '/admin/pets/add';
  static String adminPetsEditRoute(String id) => '/admin/pets/edit/$id';

  // Dashboard Constants
  static const String dashboardTitle = 'Admin Dashboard';
  static const String welcomeText = 'Welcome, Admin';
  static const String welcomeSubtitle = 'Manage your pet shop';
  static const String quickActionsTitle = 'Quick Actions';
  static const String statisticsTitle = 'Statistics';

  // Dashboard Action Cards
  static const String managePetsTitle = 'Manage Pets';
  static const String addPetTitle = 'Add Pet';
  static const String manageUsersTitle = 'Manage Users';
  static const String settingsTitle = 'Settings';

  // Statistics Labels
  static const String totalPetsLabel = 'Total Pets';
  static const String totalUsersLabel = 'Total Users';
  static const String totalFavoritesLabel = 'Total Favorites';

  // Login Constants
  static const String adminLoginTitle = 'Admin Login';
  static const String adminLoginSubtitle = 'Sign in to manage pets and users';
  static const String signInButton = 'Sign In';
  static const String backToUserLogin = 'Back to User Login';

  // Login Messages
  static const String adminLoginSuccess = 'Admin login successful';
  static const String accessDenied =
      'Access denied. Admin privileges required.';

  // Pet Management Constants
  static const String managePetsTitleAppBar = 'Manage Pets';
  static const String addNewPetTitle = 'Add New Pet';
  static const String editPetTitle = 'Edit Pet';
  static const String noPetsFound = 'No pets found';
  static const String addFirstPet = 'Add First Pet';

  // Pet Form Section Titles
  static const String basicInformationTitle = 'Basic Information';
  static const String physicalDetailsTitle = 'Physical Details';
  static const String locationDetailsTitle = 'Location Details';
  static const String priceImageTitle = 'Price & Image';
  static const String descriptionTitle = 'Description';
  static const String ownerInformationTitle = 'Owner Information';
  static const String healthStatusTitle = 'Health Status';

  // Pet Form Field Labels
  static const String petNameLabel = 'Pet Name';
  static const String breedLabel = 'Breed';
  static const String ageLabel = 'Age';
  static const String genderLabel = 'Gender';
  static const String categoryLabel = 'Category';
  static const String weightLabel = 'Weight';
  static const String colorLabel = 'Color';
  static const String locationLabel = 'Location';
  static const String distanceLabel = 'Distance';
  static const String priceLabel = 'Price';
  static const String imageUrlLabel = 'Image URL';
  static const String descriptionLabel = 'Description';
  static const String ownerNameLabel = 'Owner Name';
  static const String ownerImageUrlLabel = 'Owner Image URL (Optional)';
  static const String vaccinesCompleteLabel = 'Vaccines Complete';
  static const String neuteredLabel = 'Neutered';
  static const String healthRecordLabel = 'Health Record Available';

  // Pet Form Buttons
  static const String createPetButton = 'Create Pet';
  static const String updatePetButton = 'Update Pet';

  // Pet Form Validation Messages
  static const String petNameRequired = 'Please enter pet name';
  static const String breedRequired = 'Please enter breed';
  static const String ageRequired = 'Please enter age';
  static const String weightRequired = 'Please enter weight';
  static const String colorRequired = 'Please enter color';
  static const String locationRequired = 'Please enter location';
  static const String distanceRequired = 'Please enter distance';
  static const String priceRequired = 'Please enter price';
  static const String priceInvalid = 'Please enter a valid number';
  static const String imageUrlRequired = 'Please enter image URL';
  static const String descriptionRequired = 'Please enter description';
  static const String ownerNameRequired = 'Please enter owner name';

  // Pet Management Messages
  static const String petCreatedSuccess = 'Pet created successfully';
  static const String petUpdatedSuccess = 'Pet updated successfully';
  static const String petDeletedSuccess = 'Pet deleted successfully';
  static const String deletePetTitle = 'Delete Pet';
  static const String deletePetConfirmation =
      'Are you sure you want to delete this pet?';
  static const String cancelButton = 'Cancel';
  static const String deleteButton = 'Delete';

  // Gender Options
  static const List<String> genderOptions = ['Male', 'Female'];

  // Health Status Labels
  static const String vaccinesComplete = 'Vaccines Complete';
  static const String neutered = 'Neutered';
  static const String healthRecordAvailable = 'Health Record Available';

  // Colors
  static const Color primaryColor = Color(0xFF7BAF7B);
  static const Color lightBackground = Color(0xFFF7FBF7);
  static const Color lightGreen = Color(0xFFD3E7D3);
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static Color grey300 = Colors.grey.shade300;

  // Action Card Colors
  static const Color managePetsColor = Colors.blue;
  static const Color addPetColor = Colors.green;
  static const Color manageUsersColor = Colors.orange;
  static const Color settingsColor = Colors.purple;

  // Icons
  static const IconData dashboardIcon = Icons.admin_panel_settings;
  static const IconData managePetsIcon = Icons.pets;
  static const IconData addPetIcon = Icons.add_circle_outline;
  static const IconData manageUsersIcon = Icons.people;
  static const IconData settingsIcon = Icons.settings;
  static const IconData logoutIcon = Icons.logout;
  static const IconData petsIcon = Icons.pets;
  static const IconData usersIcon = Icons.people;
  static const IconData favoritesIcon = Icons.favorite;
  static const IconData editIcon = Icons.edit;
  static const IconData deleteIcon = Icons.delete;
  static const IconData addIcon = Icons.add;
}
