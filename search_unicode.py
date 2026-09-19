import os
import json

def search_files(directory):
    target = 'تسوق'.encode('unicode_escape').decode('ascii').replace('\\u', '\\\\u')
    target2 = 'التصنيفات'.encode('unicode_escape').decode('ascii').replace('\\u', '\\\\u')
    print(f"Searching for {target} and {target2}")
    
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if 'تسوق' in content or 'التصنيفات' in content:
                            print(f'Found literal in: {filepath}')
                        if target in content or target2 in content:
                            print(f'Found unicode in: {filepath}')
                        if '\\u062a\\u0633\\u0648\\u0642' in content:
                            print(f'Found manual unicode in: {filepath}')
                except Exception as e:
                    pass

search_files('lib/')
