import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:food_user_app/features/checkout/domain/entities/map_picker_result.dart';
import 'package:food_user_app/features/profile/domain/models/saved_address.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_controller.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: KeyboardDismissOnTap(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 0),
                child: _AddressHeader(title: l10n.checkoutChangeAddress),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _CheckoutAddressList(
                  controller: addressesController,
                  locale: locale,
                ),
              ),
              _AddressBottomBar(
                label: l10n.addNewAddress,
                onTap: () async {
                  final mapResult = await context.push<MapPickerResult>(
                    RouteNames.mapPicker,
                    extra: const MapPickerArgs(mode: MapPickerMode.add),
                  );
                  if (mapResult == null || !context.mounted) return;
                  final updated = await context.push<Object?>(
                    RouteNames.addressBookAddDetails,
                    extra: mapResult,
                  );
                  if (!context.mounted) return;
                  if (updated is MapPickerResult) {
                    context.pop(updated);
                  } else if (updated == true) {
                    context.pop(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutAddressList extends StatelessWidget {
  const _CheckoutAddressList({required this.controller, required this.locale});

  final SavedAddressesController controller;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final addresses = controller.addresses;

    if (controller.isLoading && !controller.hasLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.hasError && addresses.isEmpty) {
      return _CheckoutAddressMessage(message: l10n.savedAddressesLoadFailed);
    }

    if (addresses.isEmpty) {
      return _CheckoutAddressMessage(message: l10n.savedAddressesEmpty);
    }

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
      itemCount: addresses.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final address = addresses[index];
        return _CheckoutAddressCard(
          address: address,
          selected: address.id == controller.selectedAddressId,
          onTap: () async {
            final ok = await controller.selectAddress(address.id);
            if (!context.mounted) return;
            if (!ok) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.authErrorRequestFailed)),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.checkoutAddressUpdated)),
            );
            context.pop(
              MapPickerResult(
                latitude: address.latitude,
                longitude: address.longitude,
                address: address.location(locale),
              ),
            );
          },
        );
      },
    );
  }
}

class _CheckoutAddressMessage extends StatelessWidget {
  const _CheckoutAddressMessage({required this.message});

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
      height: 28,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.pop(),
              child: SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  AppDirectionalIcons.backChevron(context),
                  size: 28,
                  color: AppColors.onSurface(context),
                ),
              ),
            ),
            const SizedBox(width: 4),
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

class _CheckoutAddressCard extends StatelessWidget {
  const _CheckoutAddressCard({
    required this.address,
    required this.selected,
    required this.onTap,
  });

  final SavedAddress address;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.onSurface(context)
                : AppColors.border(context),
            width: selected ? 1 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Flexible(
                        child: Text(
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.addressDetailsFormat(
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
                ],
              ),
            ),
            const SizedBox(width: 8),
            _SelectionMark(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _SelectionMark extends StatelessWidget {
  const _SelectionMark({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.onSurface(context);

    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? selectedColor : AppColors.paragraph(context),
          width: 1,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: selectedColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _AddressBottomBar extends StatelessWidget {
  const _AddressBottomBar({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe + 20),
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
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, size: 20, color: AppColors.text),
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
