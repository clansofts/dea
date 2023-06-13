// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dea/models/models.dart';

import 'storage.dart';

/// Implementing an in memory repositories
class JournalsRepository implements IStorageRepository<Journal> {
  final List<Journal> storage;
  JournalsRepository({
    required this.storage,
  });

  @override
  void create(Journal value) {
    try {
      storage.add(value);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }

  @override
  List<Journal> findAll() {
    return storage;
  }

  @override
  Journal findOne(String key) {
    return storage.firstWhere((element) => element.journalId.contains(key));
  }

  @override
  void update(Journal value) {}

  @override
  void createAll(List<Journal> values) {
    try {
      storage.addAll(values);
    } catch (e) {
      print("{create} ${e.toString()}");
    }
  }
}
