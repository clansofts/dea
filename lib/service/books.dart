import 'package:dea/dea.dart';
import 'package:dea/models/enums.dart';
import 'package:dea/models/models.dart';
import 'package:dea/repositories/accounts.dart';
import 'package:dea/repositories/journals.dart';
import 'package:dea/repositories/merchants.dart';
import 'package:dea/repositories/parties.dart';
import 'package:dea/repositories/storage.dart';
import 'package:dea/repositories/transactions.dart';
import 'package:uuid/uuid.dart';

class Books implements Dea {
  // To easily manage the collections of the entities we include all available repositories
  final IStorageRepository merchantsRepo = MerchantsRepository(storage: []);
  final IStorageRepository accountsRepo = AccountsRepository(storage: []);
  final IStorageRepository journalsRepo = JournalsRepository(storage: []);
  final IStorageRepository partiesRepo = PartiesRepository(storage: []);
  final IStorageRepository txsRepo = TxsRepository(storage: []);

  // only used internally
  List<Journal> _journals = [];
  late Tx _tx;

  @override
  void setupMerchant({
    required String name,
    String? phone,
    String? email,
  }) {
    // setting up the base merchant info
    final merchant = Merchant(
        name: name,
        email: email,
        phone: phone,
        profileType: ProfileType.business);
    // initialize all books ownership
    merchantsRepo.create(merchant);
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
    accountsRepo.create(account);
  }

  @override
  void transact(String merchantId) {
    _tx = Tx(txnId: Uuid().v4(), date: DateTime.now(), merchantId: merchantId);
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
              merchant: _tx.merchantId,
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
              merchant: _tx.merchantId,
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
      //print(balance);

      if (balance.debits != balance.credits) {
        final note = balance.debits < balance.credits
            ? 'debits less by ${balance.credits - balance.debits}'
            : 'debits more by ${balance.debits - balance.credits}';
        throw "total debits ${balance.debits} must always equal total credits ${balance.credits}. $note";
      }

      if (balance.assets != balance.sources) {
        throw "{commit} transaction does not satisfy double entry equation: {assets = liabilities + equity / assets = liabilities + (capital - drawings) + (revenue - expenses)} ";
      }

      txsRepo.create(_tx);
      journalsRepo.createAll(_journals);

      print("{commit} successful");
    } catch (e) {
      print("{commit}: ${e.toString()}");
    }
  }

  Account getAccount(String id) {
    final accounts = accountsRepo.findAll() as List<Account>;
    return accounts.firstWhere((element) => element.accountId == id);
  }

  @override
  List<Journal> getAccountStatement({required String accountId}) {
    final journals = journalsRepo.findAll() as List<Journal>;
    return journals.where((element) => element.account == accountId).toList();
  }

  @override
  List<Journal> getBalanceSheet({required String merchantId}) {
    return journalsRepo.findAll() as List<Journal>;
  }

  @override
  List<Journal> getIncomeStatement({required String merchantId}) {
    final journals = journalsRepo.findAll() as List<Journal>;
    return journals.where((element) => element.merchant == merchantId).toList();
  }

  @override
  List<Journal> getTrialBalances({required String merchantId}) {
    final journals = journalsRepo.findAll() as List<Journal>;
    return journals.where((element) => element.merchant == merchantId).toList();
  }

  @override
  List<Account> getAccounts({required String merchantId}) {
    return accountsRepo.findAll() as List<Account>;
  }

  @override
  List<Party> getParties({required String merchantId}) {
    return partiesRepo.findAll() as List<Party>;
  }

  @override
  List<Tx> getTransactions({required String merchantId}) {
    return txsRepo.findAll() as List<Tx>;
  }

  @override
  Merchant getMerchant({required String merchantId}) {
    return merchantsRepo.findOne(merchantId);
  }
}
