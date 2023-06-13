// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dea/models/models.dart';

import 'storage.dart';

/// Implementing an in memory repositories
class PartiesRepository implements IStorageRepository<Party> {
  final List<Party> storage;
  PartiesRepository({
    required this.storage,
  });

  @override
  void create(Party value) {
    try {
      storage.add(value);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }

  @override
  List<Party> findAll() {
    return storage;
  }

  @override
  Party findOne(String key) {
    return storage.firstWhere((element) => element.name.contains(key));
  }

  @override
  void update(Party value) {}

  @override
  void createAll(List<Party> values) {
    try {
      storage.addAll(values);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }
}
