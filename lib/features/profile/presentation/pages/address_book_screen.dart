import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/checkout/domain/entities/map_picker_result.dart';
import 'package:food_user_app/features/profile/domain/models/saved_address.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:food_user_app/features/profile/presentation/pages/add_edit_address_screen.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/core/errors/failures.dart';

class AddressBookScreen extends StatelessWidget {
  const AddressBookScreen({super.key});

  static const _screenPadding = 16.0;
  static const _topInset = 20.0;
  static const _headerHeight = 28.0;
  static const _headerIconSize = 28.0;
  static const _headerGap = 4.0;
  static const _contentTopGap = 20.0;
  static const _cardGap = 12.0;
  static const _bottomBarTop = 16.0;
  static const _bottomBarBottom = 20.0;
  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: _screenPadding,
                top: _topInset,
                end: _screenPadding,
              ),
              child: _AddressHeader(title: l10n.savedAddressesTitle),
            ),
            const SizedBox(height: _contentTopGap),
            Expanded(child: _AddressBookBody(controller: addressesController)),
            _BottomActionBar(
              label: l10n.addNewAddress,
              iconAsset: AppAssets.addressPlusIcon,
              onTap: () async {
                final result = await context.push<MapPickerResult>(
                  RouteNames.mapPicker,
                  extra: const MapPickerArgs(mode: MapPickerMode.add),
                );
                if (result == null || !context.mounted) return;
                await context.push(
                  RouteNames.addressBookAddDetails,
                  extra: result,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressBookBody extends StatelessWidget {
  const _AddressBookBody({required this.controller});

  final SavedAddressesController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addresses = controller.addresses;

    if (controller.isLoading && !controller.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError && addresses.isEmpty) {
      return _AddressStatusMessage(message: l10n.savedAddressesLoadFailed);
    }

    if (addresses.isEmpty) {
      return _AddressStatusMessage(message: l10n.savedAddressesEmpty);
    }

    return ListView.separated(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AddressBookScreen._screenPadding,
        0,
        AddressBookScreen._screenPadding,
        24,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: addresses.length,
      separatorBuilder: (_, _) =>
          const SizedBox(height: AddressBookScreen._cardGap),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _SavedAddressCard(
          address: address,
          selected: address.id == controller.selectedAddressId,
          onSelected: () async {
            final ok = await controller.selectAddress(address.id);
            if (!context.mounted) return;
            if (ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.addressUpdatedDesignOnly)),
              );
              if (context.canPop()) {
                context.pop();
              }
            } else {
              final failure = controller.lastError;
              final errorMessage = failure is Failure
                  ? failure.message
                  : l10n.authErrorRequestFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          onDelete: () async {
            final ok = await controller.deleteAddress(address.id);
            if (!context.mounted) return;
            if (ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.addressDeletedDesignOnly)),
              );
            } else {
              final failure = controller.lastError;
              final errorMessage = failure is Failure
                  ? failure.message
                  : l10n.authErrorRequestFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _AddressStatusMessage extends StatelessWidget {
  const _AddressStatusMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.body(context).copyWith(
            color: AppColors.paragraph(context),
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _AddressHeader extends StatelessWidget {
  const _AddressHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AddressBookScreen._headerHeight,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: AddressBookScreen._headerIconSize,
                height: AddressBookScreen._headerIconSize,
                child: Icon(
                  AppDirectionalIcons.backChevron(context),
                  size: AddressBookScreen._headerIconSize,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: AddressBookScreen._headerGap),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: AppTextStyles.appBarTitle(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedAddressCard extends StatelessWidget {
  const _SavedAddressCard({
    required this.address,
    required this.selected,
    required this.onSelected,
    required this.onDelete,
  });

  final SavedAddress address;
  final bool selected;
  final VoidCallback onSelected;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Material(
      color: AppColors.surfaceCard(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onSelected,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.activeBorder(context)
                  : AppColors.border(context),
              width: selected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    address.iconAsset,
                    width: 20,
                    height: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    address.title(locale),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: AppTextStyles.body(context).copyWith(
                      color: AppColors.onSurface(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.addressDetailsFormat(
                  address.buildingNumber ?? '',
                  address.apartment ?? '',
                  address.floor ?? '',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: AppTextStyles.caption(context).copyWith(
                  color: AppColors.paragraph(context),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppAssets.addressLocationIcon,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.paragraph(context),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      (address.fullAddress != null &&
                              address.fullAddress!.trim().isNotEmpty)
                          ? address.fullAddress!.trim()
                          : address.location(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.caption(context).copyWith(
                        color: AppColors.onSurface(context),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _AddressActionButton(
                      label: l10n.editAddress,
                      iconAsset: AppAssets.addressEditIcon,
                      foreground: AppColors.success,
                      background: AppColors.success.withValues(alpha: 0.10),
                      onTap: () async {
                        final result = await context.push<MapPickerResult>(
                          RouteNames.mapPicker,
                          extra: MapPickerArgs(
                            initialLatitude: address.latitude,
                            initialLongitude: address.longitude,
                            initialAddress: address.location(locale),
                            mode: MapPickerMode.edit,
                          ),
                        );
                        if (result == null || !context.mounted) return;
                        await context.push(
                          RouteNames.addressBookEditDetails,
                          extra: ProfileAddressDetailsArgs(
                            addressId: address.id,
                            mapResult: result,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AddressActionButton(
                      label: l10n.deleteAddress,
                      iconAsset: AppAssets.addressDeleteIcon,
                      foreground: AppColors.error,
                      background: AppColors.error.withValues(alpha: 0.10),
                      onTap: () => _showDeleteAddressDialog(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAddressDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.languageModalBarrier(context),
      builder: (dialogContext) {
        return _DeleteAddressDialog(onDelete: onDelete);
      },
    );
  }
}

class _AddressActionButton extends StatelessWidget {
  const _AddressActionButton({
    required this.label,
    required this.iconAsset,
    required this.foreground,
    required this.background,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final Color foreground;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textLink(context).copyWith(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.label,
    required this.iconAsset,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        AddressBookScreen._screenPadding,
        AddressBookScreen._bottomBarTop,
        AddressBookScreen._screenPadding,
        bottomSafe + AddressBookScreen._bottomBarBottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: AddressBookScreen._buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.text,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.primaryButtonLabel.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAddressDialog extends StatelessWidget {
  const _DeleteAddressDialog({required this.onDelete});

  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      backgroundColor: AppColors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 20),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBackground(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.addressDeleteDialogIcon,
              width: 48,
              height: 48,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.deleteAddressTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.appBarTitle(context).copyWith(
                color: AppColors.onSurface(context),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.deleteAddressMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.footerSecondary(context).copyWith(
                color: AppColors.paragraph(context),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: l10n.cancel,
                    foreground: AppColors.text,
                    background: AppColors.primary,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _DialogButton(
                    label: l10n.deleteAddress,
                    foreground: AppColors.primary,
                    background: AppColors.transparent,
                    borderColor: AppColors.primary,
                    onTap: () {
                      onDelete();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.foreground,
    required this.background,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color? borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: borderColor == null
              ? null
              : Border.all(color: borderColor!, width: 0.5),
        ),
        child: Text(
          label,
          style: AppTextStyles.primaryButtonLabel.copyWith(
            color: foreground,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
