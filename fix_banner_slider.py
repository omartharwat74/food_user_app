import re

with open('lib/features/home/presentation/widgets/banner_slider.dart', 'r') as f:
    content = f.read()

old_init_state = """  @override
  void initState() {
    super.initState();
    _controller = PageController();
    context.read<BannerCubit>().getActiveBanners();
  }"""

new_init_state = """  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }"""

content = content.replace(old_init_state, new_init_state)

with open('lib/features/home/presentation/widgets/banner_slider.dart', 'w') as f:
    f.write(content)
