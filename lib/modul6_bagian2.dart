// --- Kelas Expense (DIPERLUKAN OLEH EXPENSEMANAGER) ---
class Expense {
  String description;
  double amount;
  String category;
  DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  // Konstruktor named 'quick' untuk membuat expense dengan cepat
  Expense.quick({
    required this.description,
    required this.amount,
    required this.category,
  }) : this.date = DateTime.now();

  // Getter untuk ringkasan
  String getSummary() {
    return '${date.toString().split(' ')[0]} | $category | Rp${amount.toStringAsFixed(2)} | $description';
  }
}

// --- Kelas ExpenseManager ---
class ExpenseManager {
  // List private untuk menyimpan semua expenses
  List<Expense> _expenses = [];

  // Tambah expense
  void addExpense(Expense expense) {
    _expenses.add(expense);
    print('✅ Ditambahkan: ${expense.description}');
  }

  // Dapatkan semua expenses (return copy untuk melindungi list internal)
  List<Expense> getAllExpenses() {
    return List.from(_expenses);
  }

  // Dapatkan total jumlah expenses
  int getCount() {
    return _expenses.length;
  }

  // Hitung total pengeluaran
  double getTotalSpending() {
    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Print ringkasan sederhana
  void printSummary() {
    print('\n💰 RINGKASAN PENGELUARAN');
    print('Total expenses: ${getCount()}');
    print('Total yang dikeluarkan: Rp${getTotalSpending().toStringAsFixed(2)}');
  }
}

// --- Fungsi Utama ---
void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Uber', amount: 12.00, category: 'Transport'));
  manager.addExpense(Expense.quick(description: 'Lunch', amount: 15.75, category: 'Food'));

  manager.printSummary();

  print('\nSemua expenses:');
  for (var expense in manager.getAllExpenses()) {
    print(expense.getSummary());
  }
}