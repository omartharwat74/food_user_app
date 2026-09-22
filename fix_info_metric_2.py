with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'r') as f:
    content = f.read()

old_class = """class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.assetName,
    required this.label,
    required this.iconOnRight,
  });

  final String assetName;
  final String label;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final children = [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
      ),
      const SizedBox(width: 4),
      _RestaurantIconAsset(assetName: assetName, size: 20),
    ];"""

new_class = """class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.assetName,
    this.label,
    this.labelWidget,
    required this.iconOnRight,
  });

  final String assetName;
  final String? label;
  final Widget? labelWidget;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final children = [
      labelWidget ?? Text(
        label ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.body(context).copyWith(fontSize: 12, height: 1.3),
      ),
      const SizedBox(width: 4),
      _RestaurantIconAsset(assetName: assetName, size: 20),
    ];"""
content = content.replace(old_class, new_class)

with open('lib/features/restaurant/presentation/pages/restaurant_detail_screen.dart', 'w') as f:
    f.write(content)
