import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_shop_app/core/constants/admin_constants.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/login_constants.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;
import 'package:pet_shop_app/feature/admin/dashboard/mixins/admin_dashboard_mixin.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_cubit.dart';
import 'package:pet_shop_app/feature/auth/bloc/auth_state.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_cubit.dart';
import 'package:pet_shop_app/feature/pet_detail/bloc/pet_state.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});
  //Todo : Refactor admin dashboard view
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView>
    with AdminDashboardMixin {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<AuthCubit>()),
        BlocProvider(create: (context) => di.sl<PetCubit>()..getAllPets()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: handleAuthState,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AdminConstants.dashboardTitle),
            backgroundColor: AdminConstants.primaryColor,
            foregroundColor: AdminConstants.white,
            actions: [
              IconButton(
                icon: const Icon(AdminConstants.logoutIcon),
                onPressed: () => handleLogout(context),
              ),
            ],
          ),
          body: BlocBuilder<PetCubit, PetState>(
            builder: (context, petState) {
              final totalPets = petState is PetLoaded
                  ? petState.pets.length
                  : 0;

              return SingleChildScrollView(
                padding: AppDimensionsPadding.allMedium(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Card
                    Card(
                      color: LoginConstants.primaryColor.withOpacity(0.1),
                      child: Padding(
                        padding: AppDimensionsPadding.allLarge(context),
                        child: Row(
                          children: [
                            Icon(
                              AdminConstants.dashboardIcon,
                              size: AppDimensionsSize.extraLarge(context),
                              color: AdminConstants.primaryColor,
                            ),
                            AppDimensionsSpacing.horizontalMedium(context),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AdminConstants.welcomeText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  AppDimensionsSpacing.verticalExtraSmall(
                                    context,
                                  ),
                                  Text(
                                    AdminConstants.welcomeSubtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    AppDimensionsSpacing.verticalLarge(context),

                    // Quick Actions
                    Text(
                      AdminConstants.quickActionsTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    AppDimensionsSpacing.verticalMedium(context),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppDimensionsSpacing.medium(context),
                      mainAxisSpacing: AppDimensionsSpacing.medium(context),
                      childAspectRatio: 1.2,
                      children: [
                        _AdminActionCard(
                          icon: AdminConstants.managePetsIcon,
                          title: AdminConstants.managePetsTitle,
                          color: AdminConstants.managePetsColor,
                          onTap: () => navigateToPets(context),
                        ),
                        _AdminActionCard(
                          icon: AdminConstants.addPetIcon,
                          title: AdminConstants.addPetTitle,
                          color: AdminConstants.addPetColor,
                          onTap: () => navigateToAddPet(context),
                        ),
                        _AdminActionCard(
                          icon: AdminConstants.manageUsersIcon,
                          title: AdminConstants.manageUsersTitle,
                          color: AdminConstants.manageUsersColor,
                          onTap: () => navigateToUsers(context),
                        ),
                        _AdminActionCard(
                          icon: AdminConstants.settingsIcon,
                          title: AdminConstants.settingsTitle,
                          color: AdminConstants.settingsColor,
                          onTap: () => navigateToSettings(context),
                        ),
                      ],
                    ),

                    AppDimensionsSpacing.verticalLarge(context),

                    // Statistics Card
                    StatisticsCard(totalPets: totalPets),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({required this.totalPets, super.key});

  final int totalPets;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppDimensionsPadding.allLarge(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AdminConstants.statisticsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimensionsSpacing.verticalMedium(context),
            _StatItem(
              label: AdminConstants.totalPetsLabel,
              value: totalPets.toString(),
              icon: AdminConstants.petsIcon,
            ),
            AppDimensionsSpacing.verticalSmall(context),
            const _StatItem(
              label: AdminConstants.totalUsersLabel,
              value: '0', // TODO: Get from user service
              icon: AdminConstants.usersIcon,
            ),
            AppDimensionsSpacing.verticalSmall(context),
            const _StatItem(
              label: AdminConstants.totalFavoritesLabel,
              value: '0', // TODO: Get from favorite service
              icon: AdminConstants.favoritesIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        child: Padding(
          padding: AppDimensionsPadding.allMedium(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimensionsSize.extraLarge(context),
                color: color,
              ),
              AppDimensionsSpacing.verticalSmall(context),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AdminConstants.primaryColor),
        AppDimensionsSpacing.horizontalSmall(context),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AdminConstants.primaryColor,
          ),
        ),
      ],
    );
  }
}
