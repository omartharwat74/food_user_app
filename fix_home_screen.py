import re

with open('lib/features/home/presentation/pages/home_screen.dart', 'r') as f:
    content = f.read()

# Replace HomeScreen from StatelessWidget to StatefulWidget with AutomaticKeepAliveClientMixin
old_class_def = """class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {"""

new_class_def = """class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);"""

content = content.replace(old_class_def, new_class_def)

# We need to wrap Scaffold in MultiBlocProvider
# Find the start of the build method
old_build_body = """    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }
    final copy = _HomeCopy.of(context);

    return Scaffold("""

new_build_body = """    final addressesController = SavedAddressesScope.of(context);
    if (!addressesController.hasLoaded && !addressesController.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addressesController.loadAddressesIfNeeded();
      });
    }
    final copy = _HomeCopy.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SectionsCubit>(
          create: (context) => sl<SectionsCubit>()..fetchSections(),
        ),
        BlocProvider<SpotlightsCubit>(
          create: (context) => sl<SpotlightsCubit>()..fetchSpotlights(),
        ),
      ],
      child: Scaffold("""

content = content.replace(old_build_body, new_build_body)

# In the SliverList, remove the BlocProviders

old_sliver_list = """                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: BlocProvider<SectionsCubit>(
                    create: (context) => sl<SectionsCubit>(),
                    child: const CategoryGrid(),
                  ),
                ),
                const SizedBox(height: 20),
                const BannerSlider(),
                const SizedBox(height: 18),
                const SizedBox(height: 10),
                BlocProvider<SpotlightsCubit>(
                  create: (context) => sl<SpotlightsCubit>()..fetchSpotlights(),
                  child: const _SpotlightsSections(),
                ),"""

new_sliver_list = """                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: CategoryGrid(),
                ),
                const SizedBox(height: 20),
                const BannerSlider(),
                const SizedBox(height: 18),
                const SizedBox(height: 10),
                const _SpotlightsSections(),"""

content = content.replace(old_sliver_list, new_sliver_list)

# The MultiBlocProvider was opened but not closed correctly because it wraps Scaffold. Let's find the end of build.
# Scaffold ends at:
#       ),
#     );
#   }
# }
# Replace the end
old_end = """      ),
    );
  }
}

class _HomeHeader"""

new_end = """      ),
    ));
  }
}

class _HomeHeader"""

content = content.replace(old_end, new_end)

with open('lib/features/home/presentation/pages/home_screen.dart', 'w') as f:
    f.write(content)
