import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

# Replace _CheckoutBottomBar definition
# Everything from `class _CheckoutBottomBar` to the end of the file.
new_bottom_bar = """class _CheckoutBottomBar extends StatefulWidget {
  const _CheckoutBottomBar({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_CheckoutBottomBar> createState() => _CheckoutBottomBarState();
}

class _CheckoutBottomBarState extends State<_CheckoutBottomBar> {
  bool isSummaryExpanded = false;

  Widget _buildSummaryRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.paragraph(context),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body(context).copyWith(
              color: AppColors.onSurface(context),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cart = state.maybeWhen(
          loaded: (cart, promo) => cart,
          error: (cart, promo, message) => cart,
          orElse: () => null,
        );

        final subtotal = cart?.subtotal ?? 0.0;
        final deliveryFee = cart?.deliveryFee ?? 0.0;
        final tax = cart?.tax ?? 0.0;
        final discount = cart?.discount ?? 0.0;
        final total = cart?.total ?? 0.0;

        return Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe + 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard(context),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: isSummaryExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ملخص الطلب :',
                            style: AppTextStyles.body(context).copyWith(
                              color: AppColors.onSurface(context),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow(context, 'قيمة الطلب', '${subtotal.toFormattedPrice()} ج.م'),
                          _buildSummaryRow(context, 'التوصيل', '${deliveryFee.toFormattedPrice()} ج.م'),
                          _buildSummaryRow(context, 'الضريبة', '${tax.toFormattedPrice()} ج.م'),
                          _buildSummaryRow(context, 'الخصم', '${discount.toFormattedPrice()} ج.م'),
                          const Divider(height: 16, thickness: 1),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  setState(() {
                    isSummaryExpanded = !isSummaryExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        isSummaryExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                        color: AppColors.onSurface(context),
                        size: 24,
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'الاجمالي : ',
                              style: AppTextStyles.body(context).copyWith(
                                color: AppColors.onSurface(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '${total.toFormattedPrice()} ج.م',
                              style: AppTextStyles.body(context).copyWith(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.label,
                    style: AppTextStyles.primaryButtonLabel.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
"""

content = re.sub(r'class _CheckoutBottomBar extends StatelessWidget \{.*', new_bottom_bar, content, flags=re.DOTALL)

# Also update the instantiation
content = content.replace("""                    _CheckoutBottomBar(
                      label: l10n.checkoutConfirmOrder,
                      totalLabel: l10n.orderGrandTotal,
                      total: l10n.cartPrice((total).toFormattedPrice()),
                      onTap: () {
                        context.read<CheckoutCubit>().checkout();
                      },
                    ),""", """                    _CheckoutBottomBar(
                      label: l10n.checkoutConfirmOrder,
                      onTap: () {
                        context.read<CheckoutCubit>().checkout();
                      },
                    ),""")

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)

