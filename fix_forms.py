import json

en_file = 'lib/l10n/app_en.arb'
ar_file = 'lib/l10n/app_ar.arb'

def update_arb(filepath, updates):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    for k, v in updates.items():
        data[k] = v
        
    with open(filepath, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

update_arb(en_file, {"fieldRequired": "This field is required", "minutes": "min"})
update_arb(ar_file, {"fieldRequired": "هذا الحقل مطلوب", "minutes": "دقيقة"})

