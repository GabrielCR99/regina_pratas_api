abstract class RemoteDatabase {
  Future<dynamic> query(
    String sql, {
    List<Object?> params = const [],
  });
}
