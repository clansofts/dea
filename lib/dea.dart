// ignore_for_file: public_member_api_docs, sort_constructors_first
// Double entry accounting algorithm

import 'package:dea/models.dart';

// Common Business Transactions API
abstract class Dea {
  void setupOwner({
    required String name,
    String? phone,
    String? email,
  });
  void addAccount({
    required String id,
    required AccountType accountType,
    required String name,
    String? code,
  });
  void transact();
  void debit({
    required String account,
    required double amount,
    String? description,
  });
  void credit({
    required String account,
    required double amount,
    String? description,
  });
  void commit();
  void postTransaction({
    required Tx tx,
    required List<Journal> entries,
  });
}
