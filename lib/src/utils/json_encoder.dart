class PingJsonEncoder {
  /// Custom JSON encoder that handles special cases and provides more control
  /// Matches the interface of jsonEncode from dart:convert
  static String encode(Object? object,
      {Object? Function(Object?)? toEncodable}) {
    if (object == null) {
      return 'null';
    }

    // Handle basic types
    if (object is String) {
      return '"${_escapeString(object)}"';
    }

    if (object is num || object is bool) {
      return object.toString();
    }

    if (object is DateTime) {
      return '"${object.toIso8601String()}"';
    }

    if (object is Uri) {
      return '"${object.toString()}"';
    }

    if (object is List) {
      return '[${object.map((e) => encode(e, toEncodable: toEncodable)).join(',')}]';
    }

    if (object is Map) {
      final entries = object.entries
          .map((e) =>
              '"${_escapeString(e.key.toString())}":${encode(e.value, toEncodable: toEncodable)}')
          .join(',');
      return '{$entries}';
    }

    // Handle custom objects
    try {
      // First try the provided toEncodable function
      if (toEncodable != null) {
        final encoded = toEncodable(object);
        return encode(encoded, toEncodable: toEncodable);
      }

      // Special handling for objects with value or id property
      final dynamicObj = object as dynamic;
      if (dynamicObj.value != null) {
        return encode(dynamicObj.value, toEncodable: toEncodable);
      }
      if (dynamicObj.id != null) {
        return encode(dynamicObj.id, toEncodable: toEncodable);
      }

      // Then try the object's toJson method using dynamic
      if (dynamicObj.toJson != null) {
        final toJsonMethod = dynamicObj.toJson;
        if (toJsonMethod is Function) {
          return encode(toJsonMethod(), toEncodable: toEncodable);
        }
      }
    } catch (e) {
      // If all attempts fail, fall back to string representation
      return '"${_escapeString(object.toString())}"';
    }

    // Fallback for any other type
    return '"${_escapeString(object.toString())}"';
  }

  /// Helper method to escape special characters in strings
  static String _escapeString(String str) {
    return str
        .replaceAll(r'\', r'\\')
        .replaceAll(r'"', r'\"')
        .replaceAll(r'\n', r'\\n')
        .replaceAll(r'\r', r'\\r')
        .replaceAll(r'\t', r'\\t')
        .replaceAll(r'\b', r'\\b')
        .replaceAll(r'\f', r'\\f');
  }
}
