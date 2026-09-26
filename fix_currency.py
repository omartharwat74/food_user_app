import os

def replace_currency(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # ProductDetailsScreen
    content = content.replace(r"'${val.price.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.priceWithCurrency(val.price.toFormattedPrice())")
    content = content.replace(r"'(${val.priceAfterDiscount!.toFormattedPrice()} ج.م)'", r"'(' + AppLocalizations.of(context)!.priceWithCurrency(val.priceAfterDiscount!.toFormattedPrice()) + ')'")
    content = content.replace(r"'(+${(val.price).toFormattedPrice()} ج.م)'", r"'(+' + AppLocalizations.of(context)!.priceWithCurrency(val.price.toFormattedPrice()) + ')'")
    content = content.replace(r"'(${(val.price).toFormattedPrice()} ج.م)'", r"'(' + AppLocalizations.of(context)!.priceWithCurrency(val.price.toFormattedPrice()) + ')'")

    # CheckoutScreen
    content = content.replace(r"'${subtotal.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.priceWithCurrency(subtotal.toFormattedPrice())")
    content = content.replace(r"'${deliveryFee.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.priceWithCurrency(deliveryFee.toFormattedPrice())")
    content = content.replace(r"'${tax.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.priceWithCurrency(tax.toFormattedPrice())")
    content = content.replace(r"'${discount.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.priceWithCurrency(discount.toFormattedPrice())")
    content = content.replace(r"'الاجمالي : ${total.toFormattedPrice()} ج.م'", r"AppLocalizations.of(context)!.total + ' ' + AppLocalizations.of(context)!.priceWithCurrency(total.toFormattedPrice())")
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)

replace_currency('lib/features/product/presentation/pages/product_details_screen.dart')
replace_currency('lib/features/checkout/presentation/pages/checkout_screen.dart')

print("Currency fixed.")
