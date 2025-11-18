// --- Kelas Expense (DIPERLUKAN OLEH MAIN) ---
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

// --- Fungsi Utama ---
void main() {
  // Membuat list expenses
  List<Expense> expenses = [];

  // Menambah expenses
  expenses.add(Expense.quick(description: 'Coffee', amount: 4.50, category: 'Food'));
  expenses.add(Expense.quick(description: 'Lunch', amount: 12.75, category: 'Food'));
  expenses.add(Expense.quick(description: 'Gas', amount: 45.00, category: 'Transport'));

  // Mengakses expenses
  print('Expense pertama: ${expenses[0].description}');
  print('Total jumlah: ${expenses.length}');

  // Loop semua expenses
  print('\nSemua expenses:');
  for (var expense in expenses) {
    print(expense.getSummary());
  }

  // Menghapus expense
  expenses.removeAt(1);  // Hapus lunch
  print('\nSetelah hapus lunch: ${expenses.length} expenses');

  print('\nSisa expenses:');
  for (var expense in expenses) {
    print(expense.getSummary());
  }
}