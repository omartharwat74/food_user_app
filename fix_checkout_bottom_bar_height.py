import re

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'r') as f:
    content = f.read()

content = content.replace(
    'padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe > 0 ? bottomSafe : 24),',
    'padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, bottomSafe > 0 ? bottomSafe : 16),'
)

with open('lib/features/checkout/presentation/pages/checkout_screen.dart', 'w') as f:
    f.write(content)

