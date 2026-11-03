class StoreAddressCache {
  StoreAddressCache._();

  static final Map<String, String> _cache = {};

  static String? get(String? storeId) {
    if (storeId == null) return null;
    final trimmed = storeId.trim();
    if (trimmed.isEmpty || trimmed == '0') return null;
    return _cache[trimmed];
  }

  static void set(String? storeId, String? address) {
    if (storeId == null) return;
    final trimmedId = storeId.trim();
    if (trimmedId.isEmpty || trimmedId == '0') return;
    if (address == null) return;
    final trimmedAddress = address.trim();
    if (trimmedAddress.isEmpty) return;
    _cache[trimmedId] = trimmedAddress;
  }

  static void clear() {
    _cache.clear();
  }
}
