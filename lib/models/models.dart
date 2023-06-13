// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

import 'enums.dart';

class Merchant {
  final String name;
  final String? phone;
  final String? email;
  final ProfileType profileType;

  Merchant({
    required this.name,
    required this.profileType,
    this.phone,
    this.email,
  });

  @override
  String toString() {
    return 'Merchant(name: $name, phone: $phone, email: $email, profileType: $profileType)';
  }
}

class Party {
  final String name;
  final String? identifier;
  final String? phone;
  final String? email;

  Party({
    required this.name,
    this.identifier,
    this.phone,
    this.email,
  });

  @override
  String toString() {
    return 'Party(name: $name, identifier: $identifier, phone: $phone, email: $email)';
  }
}

class Account {
  final String accountId;
  final AccountType accountType;
  final String name;
  final String? code;
  final String? path;

  Account(
      {required this.accountId,
      required this.name,
      required this.accountType,
      this.code,
      this.path});

  @override
  String toString() {
    return '\nAccount(accountId: $accountId, accountType: $accountType, name: $name, code: $code, path: $path)';
  }
}

class Tx {
  final String merchantId;
  final String txnId;
  final DateTime date;

  Tx({
    required this.merchantId,
    required this.txnId,
    required this.date,
  });

  @override
  String toString() =>
      'Tx(merchantId: $merchantId, txnId: $txnId, date: $date)';
}

class Journal {
  final String journalId;
  final String merchant;
  final JournalType journalType;
  final String account;
  final String? tx;
  final String? party;
  final double debit;
  final double credit;
  final String? description;

  Journal({
    required this.journalId,
    required this.merchant,
    required this.journalType,
    required this.account,
    this.tx,
    this.party,
    required this.debit,
    required this.credit,
    this.description,
  });

  Journal.create({
    required String account,
    required double amount,
    String? description,
  }) : this(
          journalId: Uuid().v4(),
          journalType: JournalType.cr,
          merchant: "",
          account: account,
          tx: "",
          debit: 0.00,
          credit: 0.00,
          description: description,
        );

  @override
  String toString() {
    return 'Journal(journalId: $journalId, merchant: $merchant, journalType: $journalType, account: $account, tx: $tx, party: $party, debit: $debit, credit: $credit, description: $description)';
  }

  Journal copyWith({
    String? journalId,
    String? merchant,
    JournalType? journalType,
    String? account,
    String? tx,
    String? party,
    double? debit,
    double? credit,
    String? description,
  }) {
    return Journal(
      journalId: journalId ?? this.journalId,
      merchant: merchant ?? this.merchant,
      journalType: journalType ?? this.journalType,
      account: account ?? this.account,
      tx: tx ?? this.tx,
      party: party ?? this.party,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      description: description ?? this.description,
    );
  }
}

class BooksBalances {
  double assets;
  double liabilities;
  double equity;
  double revenue;
  double expenses;
  double drawings;
  double debits;
  double credits;

  BooksBalances(
      {this.assets = 0.00,
      this.liabilities = 0.00,
      this.equity = 0.00,
      this.revenue = 0.00,
      this.expenses = 0.00,
      this.drawings = 0.00,
      this.debits = 0.00,
      this.credits = 0.00});

  BooksBalances.init()
      : this(
            assets: 0.00,
            liabilities: 0.00,
            equity: 0.00,
            revenue: 0.00,
            expenses: 0.00,
            drawings: 0.00,
            debits: 0.00,
            credits: 0.00);

  double get sources => (liabilities + equity + revenue - expenses - drawings);

  @override
  String toString() {
    return 'Balances(assets: $assets, liabilities: $liabilities, equity: $equity, revenue: $revenue, expenses: $expenses, drawings: $drawings)';
  }
}
