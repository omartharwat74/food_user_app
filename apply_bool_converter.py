import os
import re

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Skip generated files
    if filepath.endswith('.g.dart') or filepath.endswith('.freezed.dart'):
        return

    # Only process files that use freezed or JsonSerializable
    if '@freezed' not in content and '@JsonSerializable' not in content:
        return

    # Check if there are bool fields (match bool, bool?, final bool, required bool) inside class
    if not re.search(r'\bbool\??\s+', content):
        return

    print(f'Processing {filepath}')

    # Ensure IntBoolConverter is imported
    if 'bool_converter.dart' not in content:
        import_stmt = "import 'package:food_user_app/core/utils/bool_converter.dart';\n"
        
        # Find the last import statement to place it after
        last_import_match = list(re.finditer(r"^import\s+['\"].*?['\"];\s*$", content, re.MULTILINE))
        if last_import_match:
            last_import = last_import_match[-1]
            content = content[:last_import.end()] + '\n' + import_stmt + content[last_import.end():]
        else:
            # Or put it at the top
            content = import_stmt + content

    # Add @IntBoolConverter() before bool fields
    lines = content.split('\n')
    new_lines = []
    
    for i, line in enumerate(lines):
        # We need to match bool fields
        if re.search(r'\bbool\??\s+\w+\s*[,;]', line):
            # Check if IntBoolConverter is already there (maybe above it)
            if '@IntBoolConverter()' not in line and (i == 0 or '@IntBoolConverter()' not in lines[i-1]):
                indent = len(line) - len(line.lstrip())
                new_lines.append(' ' * indent + '@IntBoolConverter()')
                
        # If line has fromJson: parseBoolFromJson, we can remove it because we use the converter now
        # Actually it's better to keep it or remove it? The JsonConverter handles it so fromJson might conflict.
        # Let's remove `fromJson: parseBoolFromJson` from @JsonKey if present.
        line = re.sub(r',\s*fromJson:\s*parseBoolFromJson', '', line)
        line = re.sub(r'fromJson:\s*parseBoolFromJson\s*,?', '', line)
        
        new_lines.append(line)

    with open(filepath, 'w') as f:
        f.write('\n'.join(new_lines))

for root, _, files in os.walk('lib/features'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))

