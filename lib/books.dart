import 'package:dea/dea.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class BooksBalances {
  double assets;
  double liabilities;
  double equity;
  double revenue;
  double expenses;
  double drawings;
  double debits;
  double credits;

  BooksBalances({
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.revenue,
    required this.expenses,
    required this.drawings,
    required this.debits,
    required this.credits,
  });

  BooksBalances.init()
      : this(
          assets: 0.00,
          liabilities: 0.00,
          equity: 0.00,
          revenue: 0.00,
          expenses: 0.00,
          drawings: 0.00,
          debits: 0.00,
          credits: 0.00,
        );

  double get sources => (liabilities + equity + revenue - expenses - drawings);

  @override
  String toString() {
    return 'Balances(assets: $assets, liabilities: $liabilities, equity: $equity, revenue: $revenue, expenses: $expenses, drawings: $drawings)';
  }
}

class Books extends Dea {
  late final Owner owner;
  late final List<Account> accounts;
  late final List<Party> parties;
  late final List<Tx> transactions;
  late final List<Journal> journals;

  List<Journal> _journals = [];
  late Tx _tx;

  @override
  void setupOwner({
    required String name,
    String? phone,
    String? email,
  }) {
    // setting up the base owner info
    owner = Owner(
        name: name,
        email: email,
        phone: phone,
        profileType: ProfileType.business);
    // initialize all books storage units
    accounts = [];
    parties = [];
    transactions = [];
    journals = [];
  }

  @override
  void addAccount({
    required String id,
    required AccountType accountType,
    required String name,
    String? code,
  }) {
    // validate account is properly added
    final account =
        Account(accountId: id, name: name, accountType: accountType);
    accounts.add(account);
  }

  @override
  void transact() {
    _tx = Tx(txnId: Uuid().v4(), date: DateTime.now());
  }

  @override
  void debit({
    required String account,
    required double amount,
    String? description,
  }) {
    try {
      final d = Journal.create(
              account: account, amount: amount, description: description)
          .copyWith(
              owner: owner.name,
              journalType: JournalType.dr,
              tx: _tx.txnId,
              debit: amount);

      _journals.add(d);
    } catch (e) {
      print("{debit}: ${e.toString()}");
    }
  }

  @override
  void credit({
    required String account,
    required double amount,
    String? description,
  }) {
    try {
      final d = Journal.create(
              account: account, amount: amount, description: description)
          .copyWith(
              owner: owner.name,
              journalType: JournalType.cr,
              tx: _tx.txnId,
              credit: amount);

      _journals.add(d);
    } catch (e) {
      print("{credit}: ${e.toString()}");
    }
  }

  @override
  void commit() {
    try {
      final balance = BooksBalances.init();
      // enforce double entry rules
      if (_journals.length <= 1) {
        throw "{commit} a double entry accounting transaction must have a minimum of two journal entries";
      }

      for (var element in _journals) {
        final account = getAccount(element.account);
        final amount = element.journalType == JournalType.dr
            ? element.debit
            : element.credit;

        final _ = element.journalType == JournalType.dr
            ? balance.debits += element.debit
            : balance.credits += element.credit;

        // switch against account type
        switch (account.accountType) {
          case AccountType.assets:
            // adding amount to assets
            balance.assets += amount;
            break;
          case AccountType.liabilities:
            // adding amount to liabilities
            balance.liabilities += amount;
            break;
          case AccountType.equity:
            // adding amount to equity
            balance.equity += amount;
            break;
          case AccountType.revenues:
            // adding amount to revenues
            balance.revenue += amount;
            break;
          case AccountType.expenses:
            // adding amount to expenses
            balance.expenses += amount;
            break;
          case AccountType.drawings:
            // adding amount to drawings
            balance.drawings += amount;
            break;
          default:
        }
      }
      print(balance);

      if (balance.debits != balance.credits) {
        final note = balance.debits < balance.credits
            ? 'debits less by ${balance.credits - balance.debits}'
            : 'debits more by ${balance.debits - balance.credits}';
        throw "{commit} a total debits must always equal total credits for double entry accounting transaction. $note";
      }

      if (balance.assets != balance.sources) {
        throw "{commit} transaction does not satisfy double entry equation: {assets = liabilities + equity / assets = liabilities + (capital - drawings) + (revenue - expenses)} ";
      }

      postTransaction(tx: _tx, entries: _journals);
      print("{commit} successful");
    } catch (e) {
      print("{commit}: ${e.toString()}");
    }
  }

  @override
  void postTransaction({
    required Tx tx,
    required List<Journal> entries,
  }) {
    try {
      transactions.add(tx);
      journals.addAll(entries);
    } catch (e) {
      print("{postTransaction}: ${e.toString()}");
    }
  }

  Account getAccount(String id) {
    return accounts.firstWhere((element) => element.accountId == id);
  }

  List<Account> getAccounts() {
    return accounts;
  }

  List<Tx> _getTransactions() {
    return transactions;
  }

  List<Journal> _getjournals() {
    return journals;
  }

  List<Journal> getAccountStatement(String accountId) {
    return _getjournals()
        .where((element) => element.account == accountId)
        .toList();
  }

  List<Journal> getLedgers() {
    return _getjournals();
  }

  List<Tx> getTrialBalances() {
    return _getTransactions();
  }
}
