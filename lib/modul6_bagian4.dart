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
}

// --- Kelas ExpenseManager ---
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) => _expenses.add(expense);

  // Total pengeluaran
  double getTotalSpending() {
    double total = 0;
    for (var expense in _expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Total berdasarkan kategori
  double getTotalByCategory(String category) {
    double total = 0;
    for (var expense in _expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }
    return total;
  }

  // Rata-rata jumlah expense
  double getAverageExpense() {
    if (_expenses.isEmpty) return 0;
    return getTotalSpending() / _expenses.length;
  }

  // Expense terbesar
  Expense? getLargestExpense() {
    if (_expenses.isEmpty) return null;

    Expense largest = _expenses[0];
    for (var expense in _expenses) {
      if (expense.amount > largest.amount) {
        largest = expense;
      }
    }
    return largest;
  }

  // Expense terkecil
  Expense? getSmallestExpense() {
    if (_expenses.isEmpty) return null;

    Expense smallest = _expenses[0];
    for (var expense in _expenses) {
      if (expense.amount < smallest.amount) {
        smallest = expense;
      }
    }
    return smallest;
  }

  // Hitung berdasarkan kategori
  int countByCategory(String category) {
    int count = 0;
    for (var expense in _expenses) {
      if (expense.category == category) {
        count++;
      }
    }
    return count;
  }

  // Dapatkan semua kategori unik
  List<String> getAllCategories() {
    List<String> categories = [];
    for (var expense in _expenses) {
      if (!categories.contains(expense.category)) {
        categories.add(expense.category);
      }
    }
    return categories;
  }

  // Total yang belum dibayar
  double getTotalUnpaid() {
    double total = 0;
    for (var expense in _expenses) {
      if (!expense.isPaid) {
        total += expense.amount;
      }
    }
    return total;
  }

  // Dapatkan breakdown kategori (map kategori -> total)
  Map<String, double> getCategoryBreakdown() {
    Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      if (breakdown.containsKey(expense.category)) {
        breakdown[expense.category] = breakdown[expense.category]! + expense.amount;
      } else {
        breakdown[expense.category] = expense.amount;
      }
    }
    return breakdown;
  }
}

// --- Fungsi Utama ---
void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense(description: 'Rent', amount: 1200.0, category: 'Bills', isPaid: true));
  manager.addExpense(Expense(description: 'Laptop', amount: 899.99, category: 'Electronics'));
  manager.addExpense(Expense(description: 'Lunch', amount: 15.75, category: 'Food'));
  manager.addExpense(Expense(description: 'Gas', amount: 45.00, category: 'Transport'));

  print('📊 STATISTIK:\n');
  print('Total pengeluaran: Rp${manager.getTotalSpending().toStringAsFixed(2)}');
  print('Rata-rata expense: Rp${manager.getAverageExpense().toStringAsFixed(2)}');
  print('Total belum dibayar: Rp${manager.getTotalUnpaid().toStringAsFixed(2)}');

  var largest = manager.getLargestExpense();
  if (largest != null) {
    print('Terbesar: ${largest.description} - Rp${largest.amount}');
  }

  var smallest = manager.getSmallestExpense();
  if (smallest != null) {
    print('Terkecil: ${smallest.description} - Rp${smallest.amount}');
  }

  print('\n📁 BREAKDOWN KATEGORI:');
  var breakdown = manager.getCategoryBreakdown();
  breakdown.forEach((category, total) {
    print('$category: Rp${total.toStringAsFixed(2)}');
  });
}