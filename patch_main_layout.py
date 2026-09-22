import re

with open('lib/features/main/presentation/pages/main_layout.dart', 'r') as f:
    content = f.read()

# Make the key public or add a static key
if 'static final GlobalKey' not in content:
    content = content.replace('class MainLayout extends StatefulWidget {', 'class MainLayout extends StatefulWidget {\n  static final GlobalKey<MainLayoutState> globalKey = GlobalKey();\n')
    content = content.replace('State<MainLayout> createState() => _MainLayoutState();', 'State<MainLayout> createState() => MainLayoutState();')
    content = content.replace('class _MainLayoutState extends State<MainLayout> {', 'class MainLayoutState extends State<MainLayout> {\n  void changeIndex(int index) {\n    if (mounted) setState(() => _selectedIndex = index);\n  }\n')

with open('lib/features/main/presentation/pages/main_layout.dart', 'w') as f:
    f.write(content)
