import re
import os

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Search hint
    content = re.sub(
        r"isArabic\s*\?\s*'ابحث عن متجر أو سوبرماركت\.\.\.'\s*:\s*'Search for a market\.\.\.'",
        r"AppLocalizations.of(context)!.searchMarketOrSupermarket",
        content
    )

    # Pickup Available filter chip
    content = re.sub(
        r"isArabic\s*\?\s*'استلام من الفرع'\s*:\s*'Pickup Available'",
        r"AppLocalizations.of(context)!.pickupAvailable",
        content
    )

    # MarketEmptyState title and message
    content = re.sub(
        r"isArabic\s*\?\s*'لا توجد متاجر متاحة'\s*:\s*'No Markets Available'",
        r"AppLocalizations.of(context)!.noMarketsAvailable",
        content
    )
    content = re.sub(
        r"isArabic\s*\?\s*'لم نتمكن من العثور على متاجر مطابقة لبحثك\.'\s*:\s*'No markets matched your search or filters\.'",
        r"AppLocalizations.of(context)!.noMarketsMatchingSearch",
        content
    )

    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

fix_file('lib/features/market/presentation/pages/markets_list_screen.dart')

print("Fixed markets list screen.")
