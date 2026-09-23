import 'package:flutter/foundation.dart';
import 'package:food_user_app/core/usecases/usecase.dart';

import 'package:food_user_app/features/profile/domain/models/saved_address.dart';
import 'package:food_user_app/features/profile/domain/models/saved_address_input.dart';
import 'package:food_user_app/features/address/domain/entities/address.dart';
import 'package:food_user_app/features/address/domain/models/address_request.dart';
import 'package:food_user_app/features/checkout/domain/usecases/get_saved_addresses_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/save_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/update_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/delete_address_usecase.dart';
import 'package:food_user_app/features/checkout/domain/usecases/set_default_address_usecase.dart';

class SavedAddressesController extends ChangeNotifier {
  SavedAddressesController({
    required this.getSavedAddressesUseCase,
    required this.saveAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setDefaultAddressUseCase,
  });

  final GetSavedAddressesUseCase getSavedAddressesUseCase;
  final SaveAddressUseCase saveAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetDefaultAddressUseCase setDefaultAddressUseCase;

  List<SavedAddress> _addresses = const [];
  String? _selectedAddressId;
  bool _hasLoaded = false;
  bool _isLoading = false;
  bool _isMutating = false;
  Object? _lastError;

  List<SavedAddress> get addresses => List.unmodifiable(_addresses);

  String? get selectedAddressId => _selectedAddressId;

  bool get hasLoaded => _hasLoaded;

  bool get isLoading => _isLoading;

  bool get isMutating => _isMutating;

  bool get hasError => _lastError != null;

  Object? get lastError => _lastError;

  SavedAddress? get selectedAddress {
    final selectedId = _selectedAddressId;
    if (selectedId == null) return null;

    return addressById(selectedId);
  }

  SavedAddress? addressById(String id) {
    for (final address in _addresses) {
      if (address.id == id) return address;
    }
    return null;
  }

  Future<void> loadAddressesIfNeeded() async {
    if (_hasLoaded || _isLoading) return;
    await loadAddresses();
  }

  Future<void> loadAddresses() async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    final result = await getSavedAddressesUseCase(NoParams());
    result.fold(
      (failure) {
        _lastError = failure;
        _addresses = const [];
        _selectedAddressId = null;
        _hasLoaded = true;
      },
      (addressList) {
        _setAddresses(addressList.map(_mapAddressToSavedAddress).toList());
        _hasLoaded = true;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> selectAddress(String id) async {
    if (_selectedAddressId == id || !_addresses.any((item) => item.id == id)) {
      return true;
    }
    final previousId = _selectedAddressId;
    _selectedAddressId = id;
    _addresses = [
      for (final address in _addresses)
        address.copyWith(isDefault: address.id == id),
    ];
    _lastError = null;
    notifyListeners();

    final result = await setDefaultAddressUseCase(id);
    return result.fold(
      (failure) {
        _lastError = failure;
        _selectedAddressId = previousId;
        _addresses = [
          for (final address in _addresses)
            address.copyWith(isDefault: address.id == previousId),
        ];
        notifyListeners();
        return false;
      },
      (_) async {
        await loadAddresses();
        return true;
      },
    );
  }

  Future<bool> addAddress(SavedAddressInput input) async {
    _logAddressDebug('SavedAddressesController.addAddress');
    return _mutate(() async {
      final result = await saveAddressUseCase(_mapInputToRequest(input));
      return result.fold((f) => throw f, (_) => null);
    });
  }

  Future<bool> updateAddress({
    required String id,
    required SavedAddressInput input,
  }) async {
    return _mutate(() async {
      final result = await updateAddressUseCase(
        UpdateAddressParams(id: id, request: _mapInputToRequest(input)),
      );
      return result.fold((f) => throw f, (_) => null);
    });
  }

  Future<bool> deleteAddress(String id) async {
    return _mutate(() async {
      final wasSelected = _selectedAddressId == id;
      final result = await deleteAddressUseCase(id);
      result.fold((f) => throw f, (_) => null);
      if (wasSelected && _addresses.isNotEmpty && _selectedAddressId == null) {
        await selectAddress(_addresses.first.id);
      }
    });
  }

  Future<bool> _mutate(Future<void> Function() action) async {
    if (_isMutating) return false;
    _isMutating = true;
    _lastError = null;
    notifyListeners();
    try {
      await action();
      await loadAddresses();
      return true;
    } catch (error) {
      _lastError = error;
      notifyListeners();
      return false;
    } finally {
      _isMutating = false;
      notifyListeners();
    }
  }

  void _setAddresses(List<SavedAddress> addresses) {
    _addresses = addresses;
    if (_addresses.isEmpty) {
      _selectedAddressId = null;
      return;
    }

    final defaultAddress = _addresses.where((address) => address.isDefault);
    final currentStillExists =
        _selectedAddressId != null && addressById(_selectedAddressId!) != null;
    _selectedAddressId = defaultAddress.isNotEmpty
        ? defaultAddress.first.id
        : currentStillExists
        ? _selectedAddressId
        : _addresses.first.id;
  }

  SavedAddress _mapAddressToSavedAddress(Address address) {
    final loc = '${address.city}, ${address.neighborhood}';
    return SavedAddress(
      id: address.id,
      titleAr: address.label,
      titleEn: address.label,
      detailsAr: address.fullAddress,
      detailsEn: address.fullAddress,
      locationAr: loc,
      locationEn: loc,
      latitude: address.lat,
      longitude: address.lng,
      fullAddress: address.fullAddress,
      city: address.city,
      neighborhood: address.neighborhood,
      streetNumber: address.streetNumber,
      buildingNumber: address.buildingNumber,
      floor: address.floor,
      apartment: address.apartment,
      addressType: address.addressType,
      isDefault: address.isDefault,
    );
  }

  AddressRequest _mapInputToRequest(SavedAddressInput input) {
    return AddressRequest(
      label: input.label,
      fullAddress: input.fullAddress,
      lat: input.lat,
      lng: input.lng,
      city: input.city,
      neighborhood: input.neighborhood,
      streetNumber: input.streetNumber,
      buildingNumber: input.buildingNumber,
      floor: input.floor,
      apartment: input.apartment,
      addressType: input.addressType,
      isDefault: input.isDefault,
    );
  }
}

void _logAddressDebug(String message) {
  if (kDebugMode) {
    debugPrint('[ADDRESS_DEBUG] $message');
  }
}
