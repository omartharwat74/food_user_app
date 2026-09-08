import re

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'r') as f:
    content = f.read()

old_switch = """    switch (availability.toLowerCase()) {
      case 'busy':
        color = Colors.orange;
        text = 'مشغول';
        break;
      case 'closed':
        color = Colors.red;
        text = 'مغلق';
        break;
      case 'open':
      default:
        color = Colors.green;
        text = 'متاح';
        break;
    }"""

new_switch = """    switch (availability.toLowerCase()) {
      case 'busy':
        color = const Color(0xFFEFBE1C);
        text = 'مشغول';
        break;
      case 'closed':
        color = const Color(0xFFEC2D30);
        text = 'مغلق';
        break;
      case 'open':
      default:
        color = const Color(0xFF0C9D61);
        text = 'متاح';
        break;
    }"""

content = content.replace(old_switch, new_switch)

with open('lib/features/restaurant/presentation/widgets/restaurant_card.dart', 'w') as f:
    f.write(content)

