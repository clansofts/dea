// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dea/models/models.dart';

import 'storage.dart';

/// Implementing an in memory repositories
class AccountsRepository implements IStorageRepository<Account> {
  final List<Account> storage;
  AccountsRepository({
    required this.storage,
  });

  @override
  void create(Account value) {
    try {
      storage.add(value);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }

  @override
  List<Account> findAll() {
    return storage;
  }

  @override
  Account findOne(String key) {
    return storage.firstWhere((element) => element.name.contains(key));
  }

  @override
  void update(Account value) {}

  @override
  void createAll(List<Account> values) {
    try {
      storage.addAll(values);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }
}
