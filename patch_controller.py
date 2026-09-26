import re

filepath = 'lib/features/profile/presentation/controllers/saved_addresses_controller.dart'
with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

old_map = """  SavedAddress _mapAddressToSavedAddress(Address address) {
    final loc = '${address.city}, ${address.neighborhood}';
    return SavedAddress(
      id: address.id,
      titleAr: address.label,
      titleEn: address.label,"""

new_map = """  SavedAddress _mapAddressToSavedAddress(Address address) {
    final loc = '${address.city}, ${address.neighborhood}';
    
    final type = address.addressType?.toLowerCase();
    String titleAr = address.label;
    String titleEn = address.label;
    
    if (type == 'primary' || type == 'home') {
      titleAr = 'المنزل';
      titleEn = 'Home';
    } else if (type == 'work') {
      titleAr = 'العمل';
      titleEn = 'Work';
    } else if (type == 'other' || type == 'office') {
      titleAr = 'المكتب';
      titleEn = 'Office';
    } else if (type == 'apartment') {
      titleAr = 'الشقة';
      titleEn = 'Apartment';
    }

    return SavedAddress(
      id: address.id,
      titleAr: titleAr,
      titleEn: titleEn,"""

content = content.replace(old_map, new_map)

with open(filepath, 'w', encoding='utf-8') as f:
    f.write(content)

print("Patched controller.")
