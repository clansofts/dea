abstract class IStorageRepository<T> {
  void create(T value);
  void createAll(List<T> values);
  void update(T value);
  T findOne(String key);
  List<T> findAll();
}
