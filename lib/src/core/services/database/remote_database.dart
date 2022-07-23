abstract class RemoteDatabase<V> {
  Future<V> query(
    String sql, {
    List<Object?> params = const [],
  });
}
