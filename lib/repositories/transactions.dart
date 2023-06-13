// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dea/models/models.dart';

import 'storage.dart';

/// Implementing an in memory repositories
class TxsRepository implements IStorageRepository<Tx> {
  final List<Tx> storage;
  TxsRepository({
    required this.storage,
  });

  @override
  void create(Tx value) {
    try {
      storage.add(value);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }

  @override
  List<Tx> findAll() {
    return storage;
  }

  @override
  Tx findOne(String key) {
    return storage.firstWhere((element) => element.txnId.contains(key));
  }

  @override
  void update(Tx value) {}

  @override
  void createAll(List<Tx> values) {
    try {
      storage.addAll(values);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }
}
