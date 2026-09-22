import re

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'r') as f:
    content = f.read()

content = content.replace("""                ),
              );
  }
  }
}

class _RateHeader extends StatelessWidget {""", """        ),
      ),
    );
  }
}

class _RateHeader extends StatelessWidget {""")

with open('lib/features/restaurant/presentation/pages/restaurant_rate_screen.dart', 'w') as f:
    f.write(content)
