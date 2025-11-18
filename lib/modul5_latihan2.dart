class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime? date; // Opsional, karena tidak semua expense butuh tanggal

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    this.date, // Jadikan opsional
  });

  // Format jumlah dengan dua desimal (misal: "15.99")
  String getFormattedAmount() {
    return amount.toStringAsFixed(2);
  }

  double getAmountRounded() {
    return amount.roundToDouble();
  }

  double getDailyAverage(int days) {
    if (days <= 0) return 0.0;
    return amount / days;
  }

  double projectedYearly() {
    return amount * 12;
  }
}

void main() {
  var subscription = Expense(
    description: 'Netflix',
    amount: 15.99,
    category: 'Hiburan',
    // date tidak wajib, jadi boleh tidak diisi
  );

  print('Jumlah: \${subscription.getFormattedAmount()}');
  print('Dibulatkan: \$${subscription.getAmountRounded().toStringAsFixed(2)}');
  print('Rata-rata harian (30 hari): \$${subscription.getDailyAverage(30).toStringAsFixed(2)}');
  print('Proyeksi tahunan: \$${subscription.projectedYearly().toStringAsFixed(2)}');
}