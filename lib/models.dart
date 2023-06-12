// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

enum ProfileType { person, business }

class Owner {
  final String name;
  final String? phone;
  final String? email;
  final ProfileType profileType;

  Owner({
    required this.name,
    required this.profileType,
    this.phone,
    this.email,
  });

  @override
  String toString() {
    return 'Owner(name: $name, phone: $phone, email: $email, profileType: $profileType)';
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

enum AccountType { assets, liabilities, equity, revenues, expenses, drawings }

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
  final String txnId;
  final DateTime date;

  Tx({
    required this.txnId,
    required this.date,
  });

  @override
  String toString() => 'Tx(txnId: $txnId, date: $date)';
}

enum JournalType { dr, cr }

class Journal {
  final String journalId;
  final String owner;
  final JournalType journalType;
  final String account;
  final String? tx;
  final String? party;
  final double debit;
  final double credit;
  final String? description;

  Journal({
    required this.journalId,
    required this.owner,
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
          owner: "",
          account: account,
          tx: "",
          debit: 0.00,
          credit: 0.00,
          description: description,
        );

  @override
  String toString() {
    return 'Journal(journalId: $journalId, owner: $owner, journalType: $journalType, account: $account, tx: $tx, party: $party, debit: $debit, credit: $credit, description: $description)';
  }

  Journal copyWith({
    String? journalId,
    String? owner,
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
      owner: owner ?? this.owner,
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
