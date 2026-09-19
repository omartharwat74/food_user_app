import os

def search_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                        if 'تسوق' in content or 'التصنيفات' in content or 'المنتجات' in content or 'طلباً' in content:
                            print(f'Found in: {filepath}')
                except Exception as e:
                    pass

search_files('lib/')
