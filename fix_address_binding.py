import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

content = content.replace(
    'final selectedSavedAddress = addressesController.selectedAddress?.fullAddress ?? addressesController.selectedAddress?.titleAr;',
    'final selectedSavedAddress = addressesController.selectedAddress?.fullAddress ?? addressesController.selectedAddress?.title(Localizations.localeOf(context));'
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)

