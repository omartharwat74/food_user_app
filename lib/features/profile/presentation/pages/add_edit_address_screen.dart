import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/router/route_names.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/checkout/domain/entities/map_picker_result.dart';
import 'package:food_user_app/features/profile/domain/models/saved_address.dart';
import 'package:food_user_app/features/profile/domain/models/saved_address_input.dart';
import 'package:food_user_app/features/profile/presentation/controllers/saved_addresses_scope.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/profile/presentation/widgets/address_type_selector.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';

enum AddressFlowMode { add, edit, onboarding }

class ProfileAddressDetailsArgs {
  const ProfileAddressDetailsArgs({
    this.addressId,
    this.mapResult,
    this.isOnboarding = false,
  });

  final String? addressId;
  final MapPickerResult? mapResult;
  final bool isOnboarding;
}

class AddressMapSelectionScreen extends StatelessWidget {
  const AddressMapSelectionScreen({super.key, required this.mode});

  final AddressFlowMode mode;

  static const _screenPadding = 16.0;
  static const _topInset = 20.0;
  static const _contentTopGap = 20.0;
  static const _mapHeight = 469.0;
  static const _buttonHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detailsRoute = mode == AddressFlowMode.add
        ? RouteNames.addressBookAddDetails
        : RouteNames.addressBookEditDetails;

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
              child: _AddressFlowHeader(title: l10n.chooseLocation),
            ),
            const SizedBox(height: _contentTopGap),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: _screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SearchLocationField(label: l10n.searchForAddress),
                    const SizedBox(height: 12),
                    const _MapPreview(
                      latLng: LatLng(30.0444, 31.2357),
                      height: _mapHeight,
                    ),
                    const SizedBox(height: 16),
                    _SelectedLocationRow(text: l10n.deliveryAddress, size: 24),
                    const SizedBox(height: 24),
                    // TODO: Replace static map preview with the real map picker.
                  ],
                ),
              ),
            ),
            _AddressBottomBar(
              label: l10n.confirmLocation,
              onTap: () => context.push(detailsRoute),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({
    super.key,
    required this.mode,
    this.addressId,
    this.mapResult,
  });

  final AddressFlowMode mode;
  final String? addressId;
  final MapPickerResult? mapResult;

  static const _screenPadding = 16.0;
  static const _topInset = 20.0;
  static const _contentTopGap = 20.0;

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  // fullAddress is sourced from the map pick result or existing address;
  // it is sent silently in the API payload — no UI input field needed.
  String _fullAddress = '';
  final _formKey = GlobalKey<FormState>();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  String? _hydratedAddressId;
  String _selectedAddressType = 'primary';

  @override
  void initState() {
    super.initState();
    final initialAddress = widget.mapResult?.address;
    if (initialAddress != null && initialAddress.isNotEmpty) {
      _fullAddress = initialAddress;
    }
  }

  @override
  void dispose() {
    _buildingController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEdit = widget.mode == AddressFlowMode.edit;
    final title = isEdit ? l10n.editAddressTitle : l10n.addAddressTitle;
    final buttonLabel = isEdit ? l10n.updateAddress : l10n.saveAddress;
    final snackMessage = isEdit
        ? l10n.addressUpdatedDesignOnly
        : l10n.addressSavedDesignOnly;
    final addressesController = SavedAddressesScope.of(context);
    final editedAddress = isEdit
        ? (widget.addressId == null
              ? addressesController.selectedAddress
              : addressesController.addressById(widget.addressId!))
        : null;
    _hydrateFields(editedAddress);
    final previewAddress =
        widget.mapResult?.address ??
        editedAddress?.location(Localizations.localeOf(context)) ??
        l10n.deliveryAddress;
    final previewLatLng = LatLng(
      widget.mapResult?.latitude ?? editedAddress?.latitude ?? 30.0444,
      widget.mapResult?.longitude ?? editedAddress?.longitude ?? 31.2357,
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: AddressDetailsScreen._screenPadding,
                top: AddressDetailsScreen._topInset,
                end: AddressDetailsScreen._screenPadding,
              ),
              child: _AddressFlowHeader(title: title),
            ),
            const SizedBox(height: AddressDetailsScreen._contentTopGap),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: AddressDetailsScreen._screenPadding,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _CurrentAddressPreview(
                        address: previewAddress,
                        latLng: previewLatLng,
                      ),
                      const SizedBox(height: 16),
                      _AddressInputField(
                        hint: l10n.building,
                        controller: _buildingController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context)!.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _AddressInputField(
                              hint: l10n.floor,
                              controller: _floorController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.fieldRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _AddressInputField(
                              hint: l10n.apartment,
                              controller: _apartmentController,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppLocalizations.of(
                                    context,
                                  )!.fieldRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      AddressTypeSelector(
                        initialValue: _selectedAddressType,
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressType = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _AddressBottomBar(
              label: buttonLabel,
              isLoading: addressesController.isMutating,
              onTap: addressesController.isMutating
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;

                      final ok = await _submitAddress(
                        context: context,
                        mode: widget.mode,
                        existingAddress: editedAddress,
                        mapResult: widget.mapResult,
                      );
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ok ? snackMessage : l10n.authErrorRequestFailed,
                          ),
                        ),
                      );
                      if (!ok) return;

                      if (widget.mode == AddressFlowMode.onboarding) {
                        context.go(RouteNames.home);
                        return;
                      } else {
                        context.pop();
                        if (context.mounted && context.canPop()) {
                          context.pop();
                        }
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _hydrateFields(SavedAddress? address) {
    if (address == null || _hydratedAddressId == address.id) return;
    _hydratedAddressId = address.id;
    _buildingController.text = address.buildingNumber ?? '';
    _floorController.text = address.floor ?? '';
    _apartmentController.text = address.apartment ?? '';
    // Silently capture the full address for the API payload.
    if (_fullAddress.isEmpty) {
      _fullAddress = address.fullAddress ?? address.locationEn;
    }
    // Set initial address type based on existing
    if (address.addressType != null) {
      final t = address.addressType!.toLowerCase();
      if (t == 'work') {
        _selectedAddressType = 'work';
      } else if (t == 'other')
        _selectedAddressType = 'other';
      else
        _selectedAddressType = 'primary';
    }
  }

  Future<bool> _submitAddress({
    required BuildContext context,
    required AddressFlowMode mode,
    required SavedAddress? existingAddress,
    required MapPickerResult? mapResult,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final controller = SavedAddressesScope.of(context);
    final locale = Localizations.localeOf(context);
    final location =
        mapResult?.address ??
        existingAddress?.location(locale) ??
        l10n.deliveryAddress;
    final detailedAddress = _fullAddress.trim().isNotEmpty
        ? _fullAddress.trim()
        : location;
    final selectedLatitude = mapResult?.latitude ?? existingAddress?.latitude;
    final selectedLongitude =
        mapResult?.longitude ?? existingAddress?.longitude;
    final validationPassed =
        !((mode == AddressFlowMode.add || mode == AddressFlowMode.onboarding) &&
            mapResult == null) &&
        detailedAddress.trim().isNotEmpty;

    _logAddressDebug(
      'ADD_ADDRESS_UI_SUBMIT '
      'selectedLat=$selectedLatitude '
      'selectedLng=$selectedLongitude '
      'fullAddress="$detailedAddress" '
      'label="${existingAddress?.title(locale) ?? l10n.apartmentAddressTitle}" '
      'addressType="${existingAddress?.addressType ?? 'APARTMENT'}" '
      'buildingNumber="${_buildingController.text}" '
      'floor="${_floorController.text}" '
      'apartment="${_apartmentController.text}" '
      'isDefault=${existingAddress?.isDefault ?? controller.addresses.isEmpty} '
      'validationPassed=$validationPassed',
    );

    if (!validationPassed) {
      return Future.value(false);
    }

    final latitude = selectedLatitude ?? 30.0444;
    final longitude = selectedLongitude ?? 31.2357;

    String localizedLabel = l10n.addressTypeHome;
    if (_selectedAddressType == 'work') {
      localizedLabel = l10n.addressTypeWork;
    } else if (_selectedAddressType == 'other')
      localizedLabel = l10n.addressTypeOffice;

    final input = SavedAddressInput(
      label: localizedLabel,
      fullAddress: detailedAddress,
      lat: latitude,
      lng: longitude,
      city: existingAddress?.city ?? mapResult?.city,
      neighborhood: existingAddress?.neighborhood ?? mapResult?.neighborhood,
      streetNumber: existingAddress?.streetNumber,
      buildingNumber: _buildingController.text,
      floor: _floorController.text,
      apartment: _apartmentController.text,
      addressType: _selectedAddressType,
      isDefault: existingAddress?.isDefault ?? controller.addresses.isEmpty,
    );

    if (mode == AddressFlowMode.edit && existingAddress != null) {
      return controller.updateAddress(id: existingAddress.id, input: input);
    }

    return controller.addAddress(input);
  }
}

void _logAddressDebug(String message) {
  if (kDebugMode) {
    debugPrint('[ADDRESS_DEBUG] $message');
  }
}

class _AddressFlowHeader extends StatelessWidget {
  const _AddressFlowHeader({required this.title});

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

class _SearchLocationField extends StatelessWidget {
  const _SearchLocationField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppAssets.addressSearchIcon,
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
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: AppTextStyles.caption(context).copyWith(
                color: AppColors.paragraph(context),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({
    required this.latLng,
    this.height,
    this.compactBottomRadius = false,
  });

  final LatLng latLng;
  final double? height;
  final bool compactBottomRadius;

  @override
  Widget build(BuildContext context) {
    final radius = compactBottomRadius
        ? const BorderRadius.vertical(bottom: Radius.circular(12))
        : BorderRadius.circular(16);

    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: [
          if (height == null)
            _StaticMap(latLng: latLng)
          else
            SizedBox(
              height: height,
              width: double.infinity,
              child: _StaticMap(latLng: latLng),
            ),
          Positioned.fill(
            child: ColoredBox(color: AppColors.black.withValues(alpha: 0.20)),
          ),
          if (!compactBottomRadius)
            PositionedDirectional(
              end: 16,
              bottom: 16,
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  AppAssets.addressMapIcon,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.onSurface(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SelectedLocationRow extends StatelessWidget {
  const _SelectedLocationRow({required this.text, required this.size});

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.addressLocationIcon,
          width: size,
          height: size,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: AppTextStyles.footerSecondary(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrentAddressPreview extends StatelessWidget {
  const _CurrentAddressPreview({required this.address, required this.latLng});

  final String address;
  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context), width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.selectedLocation,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: AppTextStyles.body(context).copyWith(
                    color: AppColors.onSurface(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                _SelectedLocationRow(text: address, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _MapPreview(latLng: latLng, compactBottomRadius: true),
          ),
        ],
      ),
    );
  }
}

class _StaticMap extends StatelessWidget {
  const _StaticMap({required this.latLng});

  final LatLng latLng;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: latLng, zoom: 15),
      markers: {
        Marker(markerId: const MarkerId('selected-address'), position: latLng),
      },
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      zoomGesturesEnabled: false,
      mapToolbarEnabled: false,
      liteModeEnabled: true,
      style: isDarkMode ? AppColors.darkMapStyle : null,
    );
  }
}

class _AddressInputField extends StatefulWidget {
  const _AddressInputField({
    required this.hint,
    this.controller,
    this.validator,
  });

  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  State<_AddressInputField> createState() => _AddressInputFieldState();
}

class _AddressInputFieldState extends State<_AddressInputField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus &&
        widget.controller != null &&
        widget.controller!.text.isNotEmpty) {
      widget.controller!.selection = TextSelection.collapsed(
        offset: widget.controller!.text.length,
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      controller: widget.controller,
      validator: widget.validator,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      textAlign: TextAlign.start,
      cursorColor: AppColors.cursor(context),
      style: AppTextStyles.inputText(
        context,
      ).copyWith(fontSize: 12, height: 1.3),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: AppTextStyles.inputHint(
          context,
        ).copyWith(color: AppColors.hint(context), fontSize: 12, height: 1.3),
        filled: true,
        fillColor: AppColors.surfaceCard(context),
        contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.fieldFocusBorder(context),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class _AddressBottomBar extends StatelessWidget {
  const _AddressBottomBar({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

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
          height: AddressMapSelectionScreen._buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.text,
                  ),
                )
              : Text(
                  label,
                  style: AppTextStyles.primaryButtonLabel.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.25,
                  ),
                ),
        ),
      ),
    );
  }
}
