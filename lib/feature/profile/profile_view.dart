import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/constants/app_dimensions.dart';
import 'package:pet_shop_app/core/constants/home_constants.dart';
import 'package:pet_shop_app/core/constants/pet_detail_constants.dart';
import 'package:pet_shop_app/core/constants/profile_constants.dart';
import 'package:pet_shop_app/core/router/bottom_navigation_items.dart';
import 'package:pet_shop_app/core/widgets/app_bars.dart';
import 'package:pet_shop_app/l10n/app_localizations.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _notificationsEnabled = true;
  int _currentIndex = 2; // Profile index

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
        body: Center(child: Text('Localizations not available')),
      );
    }

    return Scaffold(
      backgroundColor: ProfileConstants.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensionsPadding.large(context),
          vertical: AppDimensionsPadding.large(context) * 1.2,
        ),
        child: Column(
          children: [
            _buildProfileHeader(context, l10n),
            SizedBox(height: AppDimensionsSpacing.large(context) * 1.5),
            _buildSectionHeader(l10n.personalInformation),
            SizedBox(height: AppDimensionsSpacing.small(context)),
            _buildInfoCard(
              context,
              Icons.person_outline,
              l10n.fullName,
              ProfileConstants.defaultUserName,
            ),
            _buildInfoCard(
              context,
              Icons.mail_outline,
              l10n.email,
              ProfileConstants.defaultEmail,
            ),
            _buildInfoCard(
              context,
              Icons.call_outlined,
              l10n.phone,
              ProfileConstants.defaultPhone,
            ),
            _buildInfoCard(
              context,
              Icons.location_on_outlined,
              l10n.address,
              ProfileConstants.defaultAddress,
              isLongText: true,
            ),
            SizedBox(height: AppDimensionsSpacing.large(context) * 1.5),
            _buildSectionHeader(l10n.appSettings),
            SizedBox(height: AppDimensionsSpacing.small(context)),
            _buildSettingToggle(
              context,
              Icons.notifications_none,
              l10n.notifications,
              _notificationsEnabled,
            ),
            _buildSettingItem(
              context,
              Icons.shopping_bag_outlined,
              l10n.myOrders,
            ),
            _buildSettingItem(
              context,
              Icons.security_outlined,
              l10n.privacyPolicy,
            ),
            _buildSettingItem(
              context,
              Icons.credit_card_outlined,
              l10n.paymentMethods,
            ),
            SizedBox(height: AppDimensionsSpacing.extraLarge(context)),
            _buildLogoutButton(context, l10n),
            SizedBox(height: AppDimensionsSpacing.large(context)),
            Text(
              '${ProfileConstants.appVersion} • ${ProfileConstants.appCompany}',
              style: TextStyle(
                fontSize: AppDimensionsFontSize.extraSmall(context),
                color: ProfileConstants.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppDimensionsSpacing.medium(context)),
          ],
        ),
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

  Widget _buildProfileHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: AppDimensionsSize.extraLarge(context) * 1.5,
              height: AppDimensionsSize.extraLarge(context) * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ProfileConstants.surfaceColor,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
                image: const DecorationImage(
                  image: NetworkImage(ProfileConstants.defaultAvatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
                decoration: BoxDecoration(
                  color: PetDetailConstants.successColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ProfileConstants.backgroundColor,
                    width: 4,
                  ),
                ),
                child: Icon(
                  Icons.edit,
                  size: AppDimensionsSize.iconSizeSmall(context) * 0.9,
                  color: ProfileConstants.textDark,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensionsSpacing.medium(context)),
        Text(
          ProfileConstants.defaultUserName,
          style: TextStyle(
            fontSize: AppDimensionsFontSize.extraLarge(context) * 1.2,
            fontWeight: FontWeight.w800,
            color: ProfileConstants.textDark,
          ),
        ),
        Text(
          ProfileConstants.defaultEmail,
          style: TextStyle(
            fontSize: AppDimensionsFontSize.medium(context),
            color: ProfileConstants.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppDimensionsSpacing.medium(context)),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.edit_square,
            size: AppDimensionsSize.iconSizeSmall(context) * 0.9,
          ),
          label: Text(l10n.editProfile),
          style: ElevatedButton.styleFrom(
            backgroundColor: PetDetailConstants.successColor,
            foregroundColor: ProfileConstants.textDark,
            elevation: 10,
            shadowColor: PetDetailConstants.successColor.withOpacity(0.4),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensionsPadding.large(context) * 1.2,
              vertical: AppDimensionsPadding.small(context),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppDimensionsRadius.circularLarge(context) * 2,
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: AppDimensionsFontSize.small(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensionsPadding.small(context),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensionsFontSize.extraSmall(context),
            fontWeight: FontWeight.bold,
            color: ProfileConstants.textMuted,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isLongText = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensionsSpacing.small(context)),
      padding: AppDimensionsPadding.allSmall(context),
      decoration: BoxDecoration(
        color: ProfileConstants.surfaceColor,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            isLongText ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
            decoration: const BoxDecoration(
              color: ProfileConstants.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ProfileConstants.textMuted,
              size: AppDimensionsSize.iconSizeSmall(context),
            ),
          ),
          SizedBox(width: AppDimensionsSpacing.medium(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppDimensionsFontSize.extraSmall(context) * 0.8,
                    fontWeight: FontWeight.bold,
                    color: ProfileConstants.textMuted,
                  ),
                ),
                SizedBox(
                    height: AppDimensionsSpacing.extraSmall(context) * 0.3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppDimensionsFontSize.small(context) * 0.9,
                    fontWeight: FontWeight.w600,
                    color: ProfileConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensionsSpacing.small(context)),
      decoration: BoxDecoration(
        color: ProfileConstants.surfaceColor,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
          decoration: const BoxDecoration(
            color: ProfileConstants.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: ProfileConstants.textDark,
            size: AppDimensionsSize.iconSizeSmall(context),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppDimensionsFontSize.medium(context),
            fontWeight: FontWeight.bold,
            color: ProfileConstants.textDark,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
        onTap: () {},
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensionsRadius.circularMedium(context),
        ),
      ),
    );
  }

  Widget _buildSettingToggle(
    BuildContext context,
    IconData icon,
    String title,
    bool value,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensionsSpacing.small(context)),
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensionsPadding.medium(context),
        vertical: AppDimensionsPadding.small(context),
      ),
      decoration: BoxDecoration(
        color: ProfileConstants.surfaceColor,
        borderRadius: AppDimensionsRadius.circularMedium(context),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimensionsPadding.small(context)),
            decoration: const BoxDecoration(
              color: ProfileConstants.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ProfileConstants.textDark,
              size: AppDimensionsSize.iconSizeSmall(context),
            ),
          ),
          SizedBox(width: AppDimensionsSpacing.medium(context)),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: AppDimensionsFontSize.medium(context),
                fontWeight: FontWeight.bold,
                color: ProfileConstants.textDark,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (v) {
              setState(() {
                _notificationsEnabled = v;
              });
            },
            activeThumbColor: PetDetailConstants.successColor,
            activeTrackColor: PetDetailConstants.successColor.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout),
        label: Text(l10n.logout),
        style: OutlinedButton.styleFrom(
          foregroundColor: ProfileConstants.logoutButtonColor,
          side:
              const BorderSide(color: ProfileConstants.logoutButtonBorderColor),
          backgroundColor: ProfileConstants.surfaceColor,
          padding: AppDimensionsPadding.allMedium(context),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensionsRadius.circularMedium(context),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: AppDimensionsFontSize.medium(context),
          ),
        ),
      ),
    );
  }
}
