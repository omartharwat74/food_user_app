import re

with open('lib/features/home/presentation/widgets/category_grid.dart', 'r') as f:
    content = f.read()

old_class = """class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  void initState() {
    super.initState();
    context.read<SectionsCubit>().fetchSections();
  }

  @override
  Widget build(BuildContext context) {"""

new_class = """class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {"""

content = content.replace(old_class, new_class)

with open('lib/features/home/presentation/widgets/category_grid.dart', 'w') as f:
    f.write(content)
