with open('lib/core/widgets/delivery_time_text.dart', 'r') as f:
    content = f.read()

old_code = """    if (isArabic) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$minTime - $maxTime', textDirection: TextDirection.ltr, style: textStyle),
          const SizedBox(width: 4),
          Text('دقيقة', style: textStyle),
        ],
      );
    }"""

new_code = """    if (isArabic) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text('$minTime - $maxTime', style: textStyle),
          ),
          const SizedBox(width: 4),
          Text('دقيقة', style: textStyle),
        ],
      );
    }"""
content = content.replace(old_code, new_code)
with open('lib/core/widgets/delivery_time_text.dart', 'w') as f:
    f.write(content)
