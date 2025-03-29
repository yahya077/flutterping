import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection';

// Events
abstract class OverlayEvent {
  final String? identifier;
  final bool isDismissible;

  OverlayEvent({
    this.identifier,
    this.isDismissible = true,
  });
}

class ShowLoadingEvent extends OverlayEvent {
  final String message;
  final Widget Function(String)? builder;
  final Duration animationDuration;

  ShowLoadingEvent({
    super.identifier,
    super.isDismissible = false,
    this.message = 'Yükleniyor...',
    this.builder,
    this.animationDuration = const Duration(milliseconds: 200),
  });
}

class ShowToastEvent extends OverlayEvent {
  final String message;
  final Duration duration;
  final Duration animationDuration;
  final Widget Function(String)? builder;
  final Alignment alignment;

  ShowToastEvent({
    super.identifier,
    super.isDismissible = false,
    required this.message,
    this.duration = const Duration(seconds: 2),
    this.animationDuration = const Duration(milliseconds: 200),
    this.builder,
    this.alignment = Alignment.bottomCenter,
  });
}

class ShowDialogEvent extends OverlayEvent {
  final Widget Function(BuildContext)? builder;
  final Duration animationDuration;

  ShowDialogEvent({
    super.identifier,
    super.isDismissible = true,
    this.builder,
    this.animationDuration = const Duration(milliseconds: 200),
  });
}

class ShowAlertEvent extends OverlayEvent {
  final String title;
  final String message;
  final List<Widget>? actions;
  final Widget Function(String, String, List<Widget>?)? builder;
  final Duration animationDuration;

  ShowAlertEvent({
    super.identifier,
    super.isDismissible = true,
    required this.title,
    required this.message,
    this.actions,
    this.builder,
    this.animationDuration = const Duration(milliseconds: 200),
  });
}

class HideOverlayEvent extends OverlayEvent {
  final Duration animationDuration;

  HideOverlayEvent({
    super.identifier,
    this.animationDuration = const Duration(milliseconds: 200),
  });
}

// Toast Queue Manager
class ToastQueueManager {
  final Queue<ShowToastEvent> _queue = Queue();
  bool _isProcessing = false;
  Timer? _currentToastTimer;
  Function(ShowToastEvent)? _showToastCallback;

  void enqueue(ShowToastEvent event) {
    _queue.add(event);
    _processQueue();
  }

  void setShowCallback(Function(ShowToastEvent) callback) {
    _showToastCallback = callback;
  }

  void _processQueue() {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;

    final event = _queue.removeFirst();
    _showToastCallback?.call(event);

    _currentToastTimer?.cancel();
    _currentToastTimer = Timer(event.duration, () {
      _isProcessing = false;
      _processQueue();
    });
  }

  void clear() {
    _queue.clear();
    _currentToastTimer?.cancel();
    _isProcessing = false;
  }
}

// Global Overlay Service
class GlobalOverlay {
  static final GlobalOverlay _instance = GlobalOverlay._internal();

  factory GlobalOverlay() => _instance;

  GlobalOverlay._internal();

  final _eventController = StreamController<OverlayEvent>.broadcast();
  final toastQueue = ToastQueueManager();

  Stream<OverlayEvent> get eventStream => _eventController.stream;

  void show({required OverlayEvent event}) {
    if (event is ShowToastEvent) {
      toastQueue.enqueue(event);
    } else {
      _eventController.add(event);
    }
  }

  void hide({String? identifier, Duration? animationDuration}) {
    _eventController.add(HideOverlayEvent(
      identifier: identifier,
      animationDuration: animationDuration ?? const Duration(milliseconds: 200),
    ));
  }

  void dispose() {
    toastQueue.clear();
    _eventController.close();
  }
}

// Animated Overlay Entry Widget
class AnimatedOverlayEntry extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final bool isClosing;
  final VoidCallback onComplete;

  const AnimatedOverlayEntry({
    super.key,
    required this.child,
    required this.animationDuration,
    required this.isClosing,
    required this.onComplete,
  });

  @override
  State<AnimatedOverlayEntry> createState() => _AnimatedOverlayEntryState();
}

class _AnimatedOverlayEntryState extends State<AnimatedOverlayEntry> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isClosing) {
      Future.microtask(() {
        if (mounted) setState(() => _isVisible = true);
      });
    } else {
      _isVisible = true;
      Future.microtask(() {
        if (mounted) setState(() => _isVisible = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: widget.animationDuration,
      onEnd: widget.isClosing ? widget.onComplete : null,
      child: widget.child,
    );
  }
}

// Overlay Widget
class GlobalOverlayWidget extends StatefulWidget {
  final Widget child;

  const GlobalOverlayWidget({
    super.key,
    required this.child,
  });

  @override
  State<GlobalOverlayWidget> createState() => _GlobalOverlayWidgetState();
}

class _GlobalOverlayWidgetState extends State<GlobalOverlayWidget> {
  final Map<String?, OverlayEntry> _overlays = {};

  @override
  void initState() {
    super.initState();
    _listenToEvents();
    GlobalOverlay().toastQueue.setShowCallback(_showToast);
  }

  void _listenToEvents() {
    GlobalOverlay().eventStream.listen((event) {
      if (event is ShowLoadingEvent) {
        _showLoading(event);
      } else if (event is ShowAlertEvent) {
        _showAlert(event);
      } else if (event is ShowDialogEvent) {
        _showDialog(event);
      } else if (event is HideOverlayEvent) {
        _hideOverlay(event.identifier, event.animationDuration);
      }
    });
  }

  void _showLoading(ShowLoadingEvent event) {
    _showAnimatedOverlay(
      event.identifier,
      event.animationDuration,
      event.isDismissible,
      (context, onComplete) => Stack(
        children: [
          GestureDetector(
            onTap: event.isDismissible
                ? () => _hideOverlay(event.identifier, event.animationDuration)
                : null,
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          event.builder?.call(event.message) ??
              _defaultLoadingWidget(event.message),
        ],
      ),
    );
  }

  void _showToast(ShowToastEvent event) {
    _showAnimatedOverlay(
      event.identifier,
      event.animationDuration,
      event.isDismissible,
      (context, onComplete) =>
          event.builder?.call(event.message) ??
          _defaultToastWidget(event.message, event.alignment),
      autoHide: event.duration,
    );
  }

  void _showAlert(ShowAlertEvent event) {
    _showAnimatedOverlay(
      event.identifier,
      event.animationDuration,
      event.isDismissible,
      (context, onComplete) => Stack(
        children: [
          GestureDetector(
            onTap: event.isDismissible
                ? () => _hideOverlay(event.identifier, event.animationDuration)
                : null,
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          event.builder?.call(event.title, event.message, event.actions) ??
              _defaultAlertWidget(
                event.title,
                event.message,
                event.actions,
                event.identifier,
                event.animationDuration,
              ),
        ],
      ),
    );
  }

  void _showDialog(ShowDialogEvent event) {
    _showAnimatedOverlay(
      event.identifier,
      event.animationDuration,
      event.isDismissible,
      (context, onComplete) => Stack(
        children: [
          GestureDetector(
            onTap: event.isDismissible
                ? () => _hideOverlay(event.identifier, event.animationDuration)
                : null,
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),
          Center(
            child: Material(
              type: MaterialType.transparency,
              child: event.builder?.call(context) ?? const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  void _showAnimatedOverlay(String? identifier, Duration animationDuration,
      bool isDismissible, Widget Function(BuildContext, VoidCallback) builder,
      {Duration? autoHide}) {
    OverlayEntry? overlay;
    overlay = OverlayEntry(
      builder: (context) => AnimatedOverlayEntry(
        animationDuration: animationDuration,
        isClosing: false,
        onComplete: () {
          if (autoHide != null) {
            Future.delayed(autoHide, () {
              _hideOverlay(identifier, animationDuration);
            });
          }
        },
        child: builder(context, () => overlay?.remove()),
      ),
    );

    _overlays[identifier] = overlay;
    Overlay.of(context).insert(overlay);
  }

  void _hideOverlay(String? identifier, Duration animationDuration) {
    final overlay = _overlays[identifier];
    if (overlay == null) return;

    overlay.remove();
    _overlays.remove(identifier);
  }

  // Default widgets implementation remains the same...
  Widget _defaultLoadingWidget(String message) {
    return Center(
      child: Container(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _defaultToastWidget(String message, Alignment alignment) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _defaultAlertWidget(
    String title,
    String message,
    List<Widget>? actions,
    String? identifier,
    Duration animationDuration,
  ) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 5,
        child: Container(
          width: 320,
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Alert header with icon
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  children: [
                    // Warning icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.red.shade600,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Message
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ),
              // Action buttons
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: actions != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: actions.map((widget) {
                          return Expanded(child: widget);
                        }).toList(),
                      )
                    : InkWell(
                        onTap: () => _hideOverlay(identifier, animationDuration),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'OK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var overlay in _overlays.values) {
      overlay.remove();
    }
    _overlays.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
