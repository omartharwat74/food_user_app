import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:food_user_app/features/auth/presentation/cubit/settings_cubit.dart';
import 'package:food_user_app/core/di/injection_container.dart';
import 'package:food_user_app/features/auth/domain/repositories/auth_repository.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late SettingsCubit _settingsCubit;

  @override
  void initState() {
    super.initState();
    _settingsCubit = SettingsCubit(repository: sl<AuthRepository>())..fetchSettings();
  }

  @override
  void dispose() {
    _settingsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bg = AppColors.scaffoldBackground(context);
    final fg = AppColors.onSurface(context);
    
    return BlocProvider.value(
      value: _settingsCubit,
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          leading: BackButton(color: fg, onPressed: () => context.pop()),
          title: Text(l10n.termsTitle, style: AppTextStyles.appBarTitle(context)),
          centerTitle: true,
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsSuccess) {
              final termsHtml = state.settings.terms ?? l10n.termsBody;
              return SingleChildScrollView(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
                child: HtmlWidget(
                  termsHtml,
                  textStyle: AppTextStyles.termsBody(context),
                ),
              );
            } else if (state is SettingsError) {
              return Center(child: Text(state.message));
            }

            // Fallback (SettingsInitial or empty)
            return SingleChildScrollView(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 32),
              child: Text(
                l10n.termsBody,
                textAlign: TextAlign.start,
                style: AppTextStyles.termsBody(context),
              ),
            );
          },
        ),
      ),
    );
  }
}
