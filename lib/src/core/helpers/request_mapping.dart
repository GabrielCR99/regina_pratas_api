abstract class RequestMapping {
  final Map<String, dynamic> data;

  RequestMapping({required this.data}) {
    map();
  }

  void map();
}
