import 'dart:io';

class DotEnvService {
  final _map = <String, dynamic>{};

  DotEnvService({Map<String, dynamic>? mocks}) {
    if (mocks == null) {
      _init();
    } else {
      _map.addAll(mocks);
    }
  }

  void _init() {
    final env = File('.env').readAsStringSync();

    for (final line
        in env.replaceAll(String.fromCharCode(13), '').split('\n')) {
      if (line.isEmpty) {
        continue;
      }

      final parts = line.split('=');
      _map[parts.first] = parts.last.trim();
    }
  }

  String? getValue(String key) => _map[key] as String;

  String? operator [](String key) => _map[key] as String;
}
