extension PriceFormatter on num {
  String toFormattedPrice() {
    if (this == truncateToDouble()) {
      return toInt().toString(); // e.g., 680.0 -> "680", 70.0 -> "70"
    }
    String formatted = toStringAsFixed(2);
    if (formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1); // e.g., 63.50 -> "63.5"
    }
    return formatted;
  }
}
