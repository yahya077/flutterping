import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

extension YamlMapConverter on YamlMap {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return _convertYamlMap(v);
    } else if (v is YamlList) {
      return _convertYamlList(v);
    } else if (v is YamlScalar) {
      return v.value;
    } else {
      return v;
    }
  }

  Map<String, dynamic> _convertYamlMap(YamlMap yamlMap) {
    var map = <String, dynamic>{};
    yamlMap.nodes.forEach((key, value) {
      if (key is YamlScalar) {
        map[key.value.toString()] = _convertNode(value);
      }
    });
    return map;
  }

  List<dynamic> _convertYamlList(YamlList yamlList) {
    var list = <dynamic>[];
    for (var item in yamlList) {
      list.add(_convertNode(item));
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    return _convertYamlMap(this);
  }
}

extension YamlListConverter on YamlList {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return (v).toMap();
    } else if (v is YamlList) {
      return _convertYamlList(v);
    } else {
      return v;
    }
  }

  List<dynamic> _convertYamlList(YamlList yamlList) {
    var list = <dynamic>[];
    for (var item in yamlList) {
      list.add(_convertNode(item));
    }
    return list;
  }

  List<T> toYamlList<T>() {
    var list = <T>[];
    for (var item in this) {
      list.add(_convertNode(item));
    }
    return list;
  }
}

abstract class AbstractConfig<T> {
  String getConfigName();
  get(String key);
  void set(String key, dynamic value);
  Map<String, dynamic> all();
  Future<Map<String, dynamic>> ensureAll();
  T allAs();
  Future<T> ensureAllAs();
}

class Config<T> implements AbstractConfig<T> {
  final Map<String, dynamic> _config = {
    'loaded': false,
  };

  Config() {
    load();
  }

  @override
  String getConfigName() {
    return 'default';
  }

  @override
  get(String key) {
    return _config[key] as T;
  }

  @override
  void set(String key, dynamic value) {
    _config[key] = value;
  }

  @override
  Map<String, dynamic> all() {
    return _config;
  }

  @override
  Future<Map<String, dynamic>> ensureAll() async {
    while (!_config['loaded']) {
      await Future.delayed(const Duration(milliseconds: 25));
    }

    return all();
  }

  @override
  T allAs() {
    throw UnimplementedError();
  }

  @override
  Future<T> ensureAllAs() async {
    throw UnimplementedError();
  }

  load() async {
    final String yamlString = await rootBundle.loadString('assets/config/${getConfigName()}.yml');
    final YamlMap yamlMap = loadYaml(yamlString);
    _config.addAll(yamlMap.toMap());
    _config['loaded'] = true;
  }
}

class AppConfig extends Config {
  AppConfig() : super();

  @override
  String getConfigName() {
    return 'app';
  }
}

