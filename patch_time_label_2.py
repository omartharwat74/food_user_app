import re

with open('lib/core/widgets/shared_store_list_tile.dart', 'r') as f:
    content = f.read()

new_label = """class _TimeLabel extends StatelessWidget {
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
    final displayTime = '$cleanTime $minLabel';

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
        Flexible(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              cleanTime,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption(context).copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          minLabel,
          style: AppTextStyles.caption(context).copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.25,
          ),
        ),
      ],
    );
  }
}"""
content = re.sub(r'class _TimeLabel extends StatelessWidget \{[\s\S]*?\}\n\}', new_label, content)

with open('lib/core/widgets/shared_store_list_tile.dart', 'w') as f:
    f.write(content)
