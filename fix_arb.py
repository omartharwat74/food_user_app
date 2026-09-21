import json

def process(filepath):
    with open(filepath, 'r') as f:
        data = json.load(f)
    
    if '@cartPrice' in data:
        data['@cartPrice']['placeholders']['amount']['type'] = 'String'
        
    with open(filepath, 'w') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

process('lib/l10n/app_ar.arb')
try:
    process('lib/l10n/app_en.arb')
except:
    pass

