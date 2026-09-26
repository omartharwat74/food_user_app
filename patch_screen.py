import re

filepath = 'lib/features/profile/presentation/pages/add_edit_address_screen.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

# Add import
import_str = "import 'package:food_user_app/features/profile/presentation/widgets/address_type_selector.dart';"
if import_str not in content:
    content = content.replace("import 'package:food_user_app/l10n/app_localizations.dart';", f"import 'package:food_user_app/l10n/app_localizations.dart';\n{import_str}")

# Add _selectedAddressType
if "String _selectedAddressType = 'primary';" not in content:
    content = content.replace("String? _hydratedAddressId;", "String? _hydratedAddressId;\n  String _selectedAddressType = 'primary';")

# Hydrate _selectedAddressType
hydrate_logic = """    if (_fullAddress.isEmpty) {
      _fullAddress = address.fullAddress ?? address.locationEn;
    }
    // Set initial address type based on existing
    if (address.addressType != null) {
      final t = address.addressType!.toLowerCase();
      if (t == 'work') _selectedAddressType = 'work';
      else if (t == 'other') _selectedAddressType = 'other';
      else _selectedAddressType = 'primary';
    }"""
if "if (address.addressType != null) {" not in content:
    content = content.replace("""    if (_fullAddress.isEmpty) {
      _fullAddress = address.fullAddress ?? address.locationEn;
    }""", hydrate_logic)


# Insert AddressTypeSelector below apartment
selector_widget = """                          ),
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
                      ),"""
if "AddressTypeSelector(" not in content:
    content = content.replace("""                          ),
                        ],
                      ),""", selector_widget)

# Update submit payload
payload_old = """    final input = SavedAddressInput(
      label:
          existingAddress?.title(Localizations.localeOf(context)) ??
          l10n.apartmentAddressTitle,
      fullAddress: detailedAddress,
      lat: latitude,
      lng: longitude,
      city: existingAddress?.city ?? mapResult?.city,
      neighborhood: existingAddress?.neighborhood ?? mapResult?.neighborhood,
      streetNumber: existingAddress?.streetNumber,
      buildingNumber: _buildingController.text,
      floor: _floorController.text,
      apartment: _apartmentController.text,
      addressType: existingAddress?.addressType ?? 'APARTMENT',
      isDefault: existingAddress?.isDefault ?? controller.addresses.isEmpty,
    );"""

payload_new = """    String localizedLabel = l10n.addressTypeHome;
    if (_selectedAddressType == 'work') localizedLabel = l10n.addressTypeWork;
    else if (_selectedAddressType == 'other') localizedLabel = l10n.addressTypeOffice;

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
    );"""

if "String localizedLabel = l10n.addressTypeHome;" not in content:
    content = content.replace(payload_old, payload_new)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched screen.")
