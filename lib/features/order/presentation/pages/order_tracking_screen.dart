import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_tracking_cubit.dart';
import 'package:food_user_app/features/order/presentation/cubit/order_tracking_state.dart';
import 'package:intl/intl.dart';

import 'package:food_user_app/l10n/app_localizations.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderTrackingCubit>()..startTracking(orderId),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.trackOrderTitle),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Text(
                  message,
                  style: AppTextStyles.body(
                    context,
                  ).copyWith(color: AppColors.error),
                ),
              ),
              loaded: (tracking) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${tracking.orderId}',
                        style: AppTextStyles.heading4(
                          context,
                        ).copyWith(color: AppColors.onSurface(context)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${tracking.status}',
                        style: AppTextStyles.body(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Timeline',
                        style: AppTextStyles.heading4(
                          context,
                        ).copyWith(color: AppColors.onSurface(context)),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tracking.timeline.length,
                          itemBuilder: (context, index) {
                            final entry = tracking.timeline[index];
                            final isLast =
                                index == tracking.timeline.length - 1;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 50,
                                        color: AppColors.border(context),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.status,
                                        style: AppTextStyles.body(
                                          context,
                                        ).copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      if (entry.description != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          entry.description!,
                                          style: AppTextStyles.caption(context)
                                              .copyWith(
                                                color: AppColors.paragraph(
                                                  context,
                                                ),
                                              ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat.yMMMd().add_jm().format(
                                          entry.timestamp,
                                        ),
                                        style: AppTextStyles.caption(context)
                                            .copyWith(
                                              color: AppColors.paragraph(
                                                context,
                                              ),
                                              fontSize: 12,
                                            ),
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
