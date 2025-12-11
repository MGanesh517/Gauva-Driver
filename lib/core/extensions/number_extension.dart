extension NumFormatter on num {
  String get formattedCount {
    if (this >= 1e9) return '${(this / 1e9).toStringAsFixed(1)}B';
    if (this >= 1e6) return '${(this / 1e6).toStringAsFixed(1)}M';
    if (this >= 1e3) return '${(this / 1e3).toStringAsFixed(1)}k';
    return toString();
  }
}
