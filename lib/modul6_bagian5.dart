// --- Kelas Expense (DIPERLUKAN OLEH EXPENSEMANAGER) ---
class Expense {
  String description;
  double amount;
  String category;
  DateTime date;
  bool isPaid;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
    this.isPaid = false,
  }) : this.date = date ?? DateTime.now();

  // Getter untuk ringkasan
  String getSummary() {
    String status = isPaid ? '✅' : '⏳';
    return '${date.toString().split(' ')[0]} | $category | Rp${amount.toStringAsFixed(2)} | $description $status';
  }

  // Getter untuk tanggal dalam format pendek (misal: 2025-10-05)
  String getFormattedDate() {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

// --- Kelas ExpenseManager ---
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) => _expenses.add(expense);
  List<Expense> getAllExpenses() => List.from(_expenses);

  // Urutkan berdasarkan jumlah (ascending)
  List<Expense> sortByAmountAsc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.amount.compareTo(b.amount));
    return sorted;
  }

  // Urutkan berdasarkan jumlah (descending)
  List<Expense> sortByAmountDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.amount.compareTo(a.amount));
    return sorted;
  }

  // Urutkan berdasarkan tanggal (terbaru dulu)
  List<Expense> sortByDateDesc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  // Urutkan berdasarkan tanggal (terlama dulu)
  List<Expense> sortByDateAsc() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.date.compareTo(b.date));
    return sorted;
  }

  // Urutkan berdasarkan kategori
  List<Expense> sortByCategory() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.category.compareTo(b.category));
    return sorted;
  }

  // Urutkan berdasarkan deskripsi
  List<Expense> sortByDescription() {
    List<Expense> sorted = List.from(_expenses);
    sorted.sort((a, b) => a.description.compareTo(b.description));
    return sorted;
  }
}

// --- Fungsi Utama ---
void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics', date: DateTime(2025, 10, 5)));
  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food', date: DateTime(2025, 10, 9)));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', date: DateTime(2025, 10, 1)));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food', date: DateTime(2025, 10, 8)));

  print('DIURUTKAN BERDASARKAN JUMLAH (tertinggi dulu):');
  for (var expense in manager.sortByAmountDesc()) {
    print('${expense.description}: Rp${expense.amount}');
  }

  print('\nDIURUTKAN BERDASARKAN TANGGAL (terbaru dulu):');
  for (var expense in manager.sortByDateDesc()) {
    print('${expense.description}: ${expense.getFormattedDate()}');
  }

  print('\nDIURUTKAN BERDASARKAN KATEGORI:');
  for (var expense in manager.sortByCategory()) {
    print('${expense.category}: ${expense.description}');
  }
}