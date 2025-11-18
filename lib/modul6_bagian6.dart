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

  // Konstruktor named 'quick' untuk membuat expense dengan cepat
  Expense.quick({
    required this.description,
    required this.amount,
    required this.category,
  }) : this.date = DateTime.now(), this.isPaid = false;

  // Getter untuk ringkasan
  String getSummary() {
    String status = isPaid ? '✅' : '⏳';
    return '${date.toString().split(' ')[0]} | $category | Rp${amount.toStringAsFixed(2)} | $description $status';
  }
}

// --- Kelas ExpenseManager ---
class ExpenseManager {
  List<Expense> _expenses = [];

  void addExpense(Expense expense) {
    _expenses.add(expense);
    print('✅ Ditambahkan: ${expense.description}');
  }

  // Hapus expense berdasarkan index
  bool removeExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) {
      print('❌ Index tidak valid');
      return false;
    }
    var removed = _expenses.removeAt(index);
    print('🗑️ Dihapus: ${removed.description}');
    return true;
  }

  // Hapus expense berdasarkan deskripsi
  bool removeExpenseByDescription(String description) {
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].description == description) {
        var removed = _expenses.removeAt(i);
        print('🗑️ Dihapus: ${removed.description}');
        return true;
      }
    }
    print('❌ Expense tidak ditemukan: $description');
    return false;
  }

  // Hapus semua expenses di kategori tertentu
  int removeByCategory(String category) {
    int count = 0;
    _expenses.removeWhere((expense) {
      if (expense.category == category) {
        count++;
        return true;
      }
      return false;
    });
    print('🗑️ Dihapus $count expenses dari kategori: $category');
    return count;
  }

  // Bersihkan semua expenses
  void clearAll() {
    int count = _expenses.length;
    _expenses.clear();
    print('🗑️ Dibersihkan semua $count expenses');
  }

  // Update expense di index tertentu
  bool updateExpense(int index, Expense newExpense) {
    if (index < 0 || index >= _expenses.length) {
      print('❌ Index tidak valid');
      return false;
    }
    _expenses[index] = newExpense;
    print('✏️ Expense diupdate di index $index');
    return true;
  }

  // Dapatkan expense berdasarkan index
  Expense? getExpenseAt(int index) {
    if (index < 0 || index >= _expenses.length) {
      return null;
    }
    return _expenses[index];
  }

  // Cari index expense berdasarkan deskripsi
  int findIndexByDescription(String description) {
    for (int i = 0; i < _expenses.length; i++) {
      if (_expenses[i].description == description) {
        return i;
      }
    }
    return -1;
  }

  // Dapatkan semua expenses (dibutuhkan oleh main())
  List<Expense> getAllExpenses() => List.from(_expenses);
}

// --- Fungsi Utama ---
void main() {
  var manager = ExpenseManager();

  manager.addExpense(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Lunch', amount: 15.75, category: 'Food'));
  manager.addExpense(Expense.quick(description: 'Gas', amount: 45.00, category: 'Transport'));

  print('\n--- Menghapus ---');
  manager.removeExpenseByDescription('Coffee');

  print('\n--- Mengupdate ---');
  int index = manager.findIndexByDescription('Lunch');
  if (index != -1) {
    manager.updateExpense(index, Expense.quick(description: 'Dinner', amount: 25.00, category: 'Food'));
  }

  print('\n--- List akhir ---');
  for (var expense in manager.getAllExpenses()) {
    print(expense.getSummary());
  }
}