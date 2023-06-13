// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dea/models/models.dart';

import 'storage.dart';

/// Implementing an in memory repositories
class MerchantsRepository implements IStorageRepository<Merchant> {
  final List<Merchant> storage;
  MerchantsRepository({
    required this.storage,
  });

  @override
  void create(Merchant value) {
    try {
      storage.add(value);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }

  @override
  List<Merchant> findAll() {
    return storage;
  }

  @override
  Merchant findOne(String key) {
    return storage.firstWhere((element) => element.name.contains(key));
  }

  @override
  void update(Merchant value) {}

  @override
  void createAll(List<Merchant> values) {
    try {
      storage.addAll(values);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }
}
