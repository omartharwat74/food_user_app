import re

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'r') as f:
    content = f.read()

bottom_bar_code = """class _ProductBottomBar extends StatelessWidget {
  const _ProductBottomBar({
    required this.quantity,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onSubmit,
  });

  final int quantity;
  final int total;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enabled = quantity > 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        border: Border(
          top: BorderSide(color: AppColors.border(context), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 20, 16, 20),
          child: Row(
            children: [
              _BottomQuantityControl(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    final isLoading = state.maybeWhen(
                      loading: () => true,
                      orElse: () => false,
                    );
                    final isError = state.maybeWhen(
                      error: (cart, promo, msg) => true,
                      orElse: () => false,
                    );
                    final message = state.maybeWhen(
                      error: (cart, promo, msg) => msg,
                      orElse: () => null,
                    );

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (enabled && !isLoading) ? onSubmit : null,
                      child: Container(
                        height: 48,
                        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        decoration: BoxDecoration(
                          color: (enabled && !isLoading)
                              ? AppColors.primary
                              : AppColors.inactiveIndicator,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: isLoading
                            ? const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      isError ? (message ?? 'حدث خطأ') : l10n.productAddToCart,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.buttonHeading(context).copyWith(
                                        color: (enabled && !isLoading)
                                            ? AppColors.text
                                            : AppColors.paragraph(context),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.25,
                                      ),
                                    ),
                                  ),
                                  if (!isError)
                                    Text(
                                      l10n.cartPrice(total),
                                      style: AppTextStyles.buttonHeading(context).copyWith(
                                        color: (enabled && !isLoading)
                                            ? AppColors.text
                                            : AppColors.paragraph(context),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.25,
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}"""

content = re.sub(r'class _ProductBottomBar extends StatelessWidget \{[\s\S]*?class _BottomQuantityControl', bottom_bar_code + '\n\nclass _BottomQuantityControl', content)

with open('lib/features/product/presentation/pages/product_details_screen.dart', 'w') as f:
    f.write(content)

