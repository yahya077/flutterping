enum LogLevel { emergency, alert, critical, error, warning, notice, info, debug }

abstract class LogAdapter {
  void log(LogLevel level, String message);
}

class FrameworkLogAdapter implements LogAdapter {
  @override
  void log(LogLevel level, String message) {

  }
}

class LogManager {
  final Map<String, LogAdapter> _channels = {};

  LogManager(Map<String, LogAdapter> channels) {
    _channels.addAll(channels);
  }

  void registerChannel(String channel, LogAdapter adapter) {
    _channels[channel] = adapter;
  }

  void log(String channel, LogLevel level, String message) {
    if (_channels.containsKey(channel)) {
      _channels[channel]!.log(level, message);
    } else {
      throw ArgumentError('Channel $channel is not registered.');
    }
  }
}