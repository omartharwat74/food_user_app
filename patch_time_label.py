import re

with open('lib/core/widgets/shared_store_list_tile.dart', 'r') as f:
    content = f.read()

new_label = r"""class _TimeLabel extends StatelessWidget {
  const _TimeLabel({
    required this.time,
  });

  final String time;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.onSurface(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final minLabel = isRtl ? 'دقيقة' : 'mins';
    
    // Clean up any existing "min", "mins", or "دقيقة"
    var cleanTime = time.replaceAll(RegExp(r'\s*(mins?|دقيقة)'), '').trim();
    if (cleanTime.isEmpty) cleanTime = time; 

    final parts = cleanTime.split('-');
    final textStyle = AppTextStyles.caption(context).copyWith(
      color: color,
      fontSize: 10,
      height: 1.0,
    );

    Widget timeWidget;
    if (isRtl && parts.length == 2) {
      final minTime = parts[0].trim();
      final maxTime = parts[1].trim();
      timeWidget = Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.ltr,
        children: [
          Text(maxTime, style: textStyle),
          Text(' - ', style: textStyle),
          Text(minTime, style: textStyle),
        ],
      );
    } else {
      timeWidget = Text(
        cleanTime,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppRasterImage.asset(
          AppAssets.serviceTimeIconPng,
          width: 14,
          height: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(child: timeWidget),
        const SizedBox(width: 4),
        Text(minLabel, style: textStyle),
      ],
    );
  }
}"""
content = re.sub(r'class _TimeLabel extends StatelessWidget \{[\s\S]*?\}\n\}', new_label.replace('\\', '\\\\'), content)

with open('lib/core/widgets/shared_store_list_tile.dart', 'w') as f:
    f.write(content)
