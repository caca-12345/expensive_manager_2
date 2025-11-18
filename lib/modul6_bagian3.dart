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

  // Apakah ini major expense?
  bool isMajorExpense() {
    return amount > 100;
  }

  // Apakah expense ini bulan ini?
  bool isThisMonth() {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }
}

// --- Kelas ExpenseManager ---
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
  }

  List<Expense> getAllExpenses() => List.from(_expenses);

  // Filter berdasarkan kategori
  List<Expense> getByCategory(String category) {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.category == category) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // Filter berdasarkan rentang jumlah
  List<Expense> getByAmountRange(double min, double max) {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.amount >= min && expense.amount <= max) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // Dapatkan major expenses saja
  List<Expense> getMajorExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isMajorExpense()) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // Dapatkan expenses bulan ini
  List<Expense> getThisMonth() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isThisMonth()) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  // Dapatkan expenses yang sudah/belum dibayar
  List<Expense> getPaidExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (expense.isPaid) {
        filtered.add(expense);
      }
    }
    return filtered;
  }

  List<Expense> getUnpaidExpenses() {
    List<Expense> filtered = [];
    for (var expense in _expenses) {
      if (!expense.isPaid) {
        filtered.add(expense);
      }
    }
    return filtered;
  }
}

// --- Fungsi Utama ---
void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true));
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics'));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food'));

  print('EXPENSES MAKANAN:');
  for (var expense in manager.getByCategory('Food')) {
    print(expense.getSummary());
  }

  print('\nMAJOR EXPENSES (>Rp100):');
  for (var expense in manager.getMajorExpenses()) {
    print(expense.getSummary());
  }

  print('\nEXPENSES BELUM DIBAYAR:');
  for (var expense in manager.getUnpaidExpenses()) {
    print(expense.getSummary());
  }
}