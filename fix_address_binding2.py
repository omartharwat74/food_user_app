import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

content = content.replace(
    'final selectedSavedAddress = addressesController.selectedAddress?.fullAddress ?? addressesController.selectedAddress?.title(Localizations.localeOf(context));',
    '''final address = addressesController.selectedAddress;
    final selectedSavedAddress = (address?.fullAddress?.isNotEmpty == true) 
        ? address!.fullAddress 
        : (address?.title(Localizations.localeOf(context))?.isNotEmpty == true) 
            ? address!.title(Localizations.localeOf(context)) 
            : null;'''
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)

