// ignore_for_file: public_member_api_docs, sort_constructors_first
// Double entry accounting algorithm

import 'package:dea/models/models.dart';

import 'models/enums.dart';

// Common Business Transactions API
abstract class Dea {
  void setupMerchant({
    required String name,
    String? phone,
    String? email,
  });
  void addAccount(
      {required String id,
      required AccountType accountType,
      required String name,
      String? code});

  void transact(String merchantId);

  void debit(
      {required String account, required double amount, String? description});

  void credit(
      {required String account, required double amount, String? description});
  void commit();

  List<Account> getAccounts({required String merchantId});

  List<Tx> getTransactions({required String merchantId});

  List<Party> getParties({required String merchantId});

  Merchant getMerchant({required String merchantId});

  List<Journal> getAccountStatement({required String accountId});

  List<Journal> getTrialBalances({required String merchantId});

  List<Journal> getBalanceSheet({required String merchantId});

  List<Journal> getIncomeStatement({required String merchantId});
}
