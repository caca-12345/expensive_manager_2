import 'dart:io'; 
// --- Kelas User ---
class User {
  final String username;
  String password;
  String name;
  String? email;
  DateTime createdAt;

  Map<String, dynamic> settings = {
    'currency': 'IDR',
    'theme': 'light',
    'notifications': true,
  };

  late BudgetManager budgetManager;

  User({
    required this.username,
    required this.password,
    this.name = 'User',
    this.email,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now() {
    budgetManager = BudgetManager();
  }

  @override
  String toString() {
    return '👤 $name ($username) - Email: $email';
  }
}

// --- Kelas Expense ---
class Expense {
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.description,
    required this.amount,
    required this.category,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();

  @override
  String toString() {
    return '${date.toString().split(' ')[0]} | $category | \$${amount.toStringAsFixed(2)} | $description';
  }
}

// --- Kelas BudgetManager ---
class BudgetManager {
  final Map<String, double> _budgets = {};
  final List<Expense> _expenses = [];

  void setBudget(String category, double amount) {
    if (amount < 0) return;
    _budgets[category] = amount;
    print('✅ Budget "$category": \$${amount.toStringAsFixed(2)}');
  }

  void recordExpense(Expense expense) {
    _expenses.add(expense);
    double currentExpense = _expenses
        .where((e) => e.category == expense.category)
        .map((e) => e.amount)
        .reduce((a, b) => a + b);

    double budget = _budgets[expense.category] ?? 0.0;
    double remaining = budget - currentExpense;
    double percentageUsed = budget > 0 ? (currentExpense / budget) * 100 : 0;

    if (percentageUsed >= 90) {
      print('⚠️ PERINGATAN: "$expense.category" telah ${percentageUsed.toStringAsFixed(1)}% digunakan!');
      if (remaining < 0) {
        print('🚨 Melebihi: \$${(-remaining).toStringAsFixed(2)}');
      } else {
        print('💰 Sisa: \$${remaining.toStringAsFixed(2)}');
      }
    }
  }

  void generateReport() {
    print('\n📊 LAPORAN BUDGET');
    print('-' * 50);

    var groupedExpenses = <String, double>{};
    for (var e in _expenses) {
      groupedExpenses[e.category] = (groupedExpenses[e.category] ?? 0) + e.amount;
    }

    for (var category in _budgets.keys) {
      double budget = _budgets[category]!;
      double expense = groupedExpenses[category] ?? 0.0;
      double remaining = budget - expense;
      double percentageUsed = budget > 0 ? (expense / budget) * 100 : 0;

      String status = '';
      if (expense == 0) {
        status = '🟢 Belum ada pengeluaran';
      } else if (percentageUsed >= 100) {
        status = '🔴 MELEBIHI BUDGET';
      } else if (percentageUsed >= 80) {
        status = '🟡 Mendekati limit';
      } else {
        status = '🔵 Aman';
      }

      print(
          '$category: \$${expense.toStringAsFixed(2)} / \$${budget.toStringAsFixed(2)} ($percentageUsed.toStringAsFixed(1)%) — $status');
      if (remaining < 0) {
        print('   ⚠️ Melebihi: \$${(-remaining).toStringAsFixed(2)}');
      } else {
        print('   💰 Sisa: \$${remaining.toStringAsFixed(2)}');
      }
      print('');
    }

    // Total
    double totalBudget = _budgets.values.isEmpty ? 0.0 : _budgets.values.reduce((a, b) => a + b);
    double totalExpense = groupedExpenses.values.isEmpty ? 0.0 : groupedExpenses.values.reduce((a, b) => a + b);
    double totalRemaining = totalBudget - totalExpense;

    print('-' * 50);
    print('TOTAL: \$${totalExpense.toStringAsFixed(2)} / \$${totalBudget.toStringAsFixed(2)}');
    if (totalRemaining < 0) {
      print('🚨 TOTAL MELEBIHI BUDGET: \$${(-totalRemaining).toStringAsFixed(2)}');
    } else {
      print('💰 TOTAL SISA: \$${totalRemaining.toStringAsFixed(2)}');
    }
  }

  List<Expense> get expenses => List.unmodifiable(_expenses);
}

// --- Kelas UserManager ---
class UserManager {
  final Map<String, User> _users = {};

  User? login(String username, String password) {
    if (!_users.containsKey(username)) {
      print('❌ Pengguna tidak ditemukan.');
      return null;
    }

    User user = _users[username]!;
    if (user.password != password) {
      print('❌ Password salah.');
      return null;
    }

    print('✅ Selamat datang, ${user.name}!');
    return user;
  }

  User register(String username, String password, {String name = 'User', String? email}) {
    if (_users.containsKey(username)) {
      throw Exception('Username sudah digunakan.');
    }

    User newUser = User(
      username: username,
      password: password,
      name: name,
      email: email,
    );
    _users[username] = newUser;
    print('✅ Akun "$username" berhasil dibuat.');
    return newUser;
  }

  bool changePassword(User user, String oldPassword, String newPassword) {
    if (user.password != oldPassword) {
      print('❌ Password lama salah.');
      return false;
    }
    user.password = newPassword;
    print('✅ Password berhasil diubah.');
    return true;
  }

  List<User> getAllUsers() => _users.values.toList();
  User? getUser(String username) => _users[username];
}

// --- Kelas Utama: FinanceApp ---
class FinanceApp {
  final UserManager userManager = UserManager();
  User? currentUser;

  void run() {
    print('🌟 Selamat datang di FinanceApp Multi-User!');
    print('Gunakan: login, register, profile, setbudget, expense, report, logout, quit');

    while (true) {
      print('\n> Masukkan perintah:');
      String? input = stdin.readLineSync()?.trim();
      if (input == null || input.isEmpty) continue;

      List<String> parts = input.split(' ');
      String command = parts[0].toLowerCase();

      switch (command) {
        case 'login':
          if (parts.length < 3) {
            print('❌ Format: login <username> <password>');
            break;
          }
          currentUser = userManager.login(parts[1], parts[2]);
          if (currentUser != null) {
            print('📌 Anda masuk sebagai: ${currentUser!.username}');
          }
          break;

        case 'register':
          if (parts.length < 3) {
            print('❌ Format: register <username> <password> [nama] [email]');
            break;
          }
          try {
            userManager.register(
              parts[1],
              parts[2],
              name: parts.length > 3 ? parts[3] : 'User',
              email: parts.length > 4 ? parts[4] : null,
            );
          } catch (e) {
            print('❌ Error: $e');
          }
          break;

        case 'profile':
          if (currentUser == null) {
            print('❌ Silakan login terlebih dahulu.');
            break;
          }
          print('\n📋 PROFIL USER');
          print(currentUser);
          print('Pengaturan:');
          currentUser!.settings.forEach((key, value) {
            print('  • $key: $value');
          });
          break;

        case 'setbudget':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          if (parts.length < 3) {
            print('❌ Format: setbudget <kategori> <jumlah>');
            break;
          }
          String category = parts[1];
          double? amount = double.tryParse(parts[2]);
          if (amount == null || amount < 0) {
            print('❌ Jumlah harus berupa angka positif.');
            break;
          }
          currentUser!.budgetManager.setBudget(category, amount);
          break;

        case 'expense':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          if (parts.length < 4) {
            print('❌ Format: expense <kategori> <jumlah> <deskripsi>');
            break;
          }
          String category = parts[1];
          double? amount = double.tryParse(parts[2]);
          String description = parts.sublist(3).join(' ');

          if (amount == null || amount <= 0) {
            print('❌ Jumlah harus berupa angka lebih dari 0.');
            break;
          }

          var expense = Expense(
            description: description,
            amount: amount,
            category: category,
          );
          currentUser!.budgetManager.recordExpense(expense);
          print('✅ Pengeluaran "$description" sebesar \$${amount.toStringAsFixed(2)} ditambahkan ke "$category".');
          break;

        case 'report':
          if (currentUser == null) {
            print('❌ Login dulu!');
            break;
          }
          currentUser!.budgetManager.generateReport();
          break;

        case 'logout':
          currentUser = null;
          print('👋 Anda telah logout.');
          break;

        case 'quit':
          print('🔒 Terima kasih telah menggunakan FinanceApp!');
          exit(0); // atau return;

        default:
          print('❓ Perintah tidak dikenali. Coba: login, register, profile, setbudget, expense, report, logout, quit');
      }
    }
  }
}

// --- Main Function ---
void main() {
  var app = FinanceApp();
  app.run();
}