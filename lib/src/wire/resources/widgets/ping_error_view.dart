import 'package:flutter/material.dart';
import 'dart:convert';

/// A error view with detailed error information
class PingErrorView extends StatefulWidget {
  /// The error object that was thrown
  final dynamic error;
  
  /// The stack trace associated with the error
  final StackTrace? stackTrace;
  
  /// Optional request information (URL, method, etc.)
  final Map<String, dynamic>? requestInfo;
  
  /// Optional context data relevant to the error
  final Map<String, dynamic>? context;
  
  /// Optional application information (version, environment, etc.)
  final Map<String, dynamic>? appInfo;
  
  /// Callback when the user taps the "Report" button
  final VoidCallback? onReport;
  
  /// Whether to show the full detailed view (default: true)
  /// Note: This will be overridden to false in production environment
  final bool showFullDetails;

  final bool debugMode;
  
  /// Optional custom actions to display in the footer
  final List<Widget>? actions;

  const PingErrorView({
    Key? key,
    required this.error,
    this.stackTrace,
    this.requestInfo,
    this.context,
    this.appInfo,
    this.onReport,
    this.showFullDetails = true,
    this.debugMode = false,
    this.actions,
  }) : super(key: key);

  @override
  PingErrorViewState createState() => PingErrorViewState();
}

class PingErrorViewState extends State<PingErrorView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  bool _expanded = true;
  
  // Extracted Laravel exception data
  Map<String, dynamic> _laravelExceptionData = {};
  
  // Computed showFullDetails
  late bool _effectiveShowFullDetails;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
    
    // Determine environment
    _detectEnvironment();
    
    // Try to extract Laravel exception data
    _extractLaravelExceptionData();
  }
  
  void _detectEnvironment() {
    // Override showFullDetails in production to ensure sensitive information isn't exposed
    _effectiveShowFullDetails = !widget.debugMode ? false : widget.showFullDetails;
  }
  
  void _extractLaravelExceptionData() {
    if (widget.error["exception"] != null) {
      _laravelExceptionData = widget.error as Map<String, dynamic>;
    }
  }
  
  void _tryExtractLaravelExceptionManually(String errorStr) {
    try {
      // Manual extraction for common patterns
      final messageMatch = RegExp(r'"message":\s*"(.*?)"').firstMatch(errorStr);
      final exceptionMatch = RegExp(r'"exception":\s*"(.*?)"').firstMatch(errorStr);
      final fileMatch = RegExp(r'"file":\s*"(.*?)"').firstMatch(errorStr);
      final lineMatch = RegExp(r'"line":\s*(\d+)').firstMatch(errorStr);
      
      if (messageMatch != null) {
        _laravelExceptionData['message'] = messageMatch.group(1);
      }
      
      if (exceptionMatch != null) {
        _laravelExceptionData['exception'] = exceptionMatch.group(1);
      }
      
      if (fileMatch != null) {
        _laravelExceptionData['file'] = fileMatch.group(1);
      }
      
      if (lineMatch != null) {
        _laravelExceptionData['line'] = int.tryParse(lineMatch.group(1) ?? '0') ?? 0;
      }
      
      // Try to extract trace - more complex
    } catch (e) {
      // Silently fail
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          margin: const EdgeInsets.all(16.0),
          clipBehavior: Clip.antiAlias,
          constraints: BoxConstraints(
            maxWidth: 480.0, // Limit max width for larger screens
            maxHeight: MediaQuery.of(context).size.height * 0.9, // Limit max height
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.minWidth,
                    maxWidth: constraints.maxWidth,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      if (_effectiveShowFullDetails) _buildTabBar(),
                      _buildContent(),
                      _buildFooter(),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    String errorType = widget.error.runtimeType.toString();
    String errorMessage = widget.error.toString();
    
    // If we have Laravel exception data, use that for a cleaner display
    if (_laravelExceptionData.isNotEmpty) {
      if (_laravelExceptionData.containsKey('exception')) {
        // Extract just the class name from the full namespace
        final fullExceptionName = _laravelExceptionData['exception'].toString();
        final parts = fullExceptionName.split('\\');
        errorType = parts.last;
      }
      
      if (_laravelExceptionData.containsKey('message')) {
        errorMessage = _laravelExceptionData['message'].toString();
      }
    } else {
      // Regular error handling
      errorMessage = errorMessage.replaceAll('$errorType: ', '');
    }
    
    // In production, we might want to sanitize error messages
    if (!widget.debugMode) {
      // Only show generic error types in production
      if (errorType.contains('Exception') || errorType.contains('Error')) {
        // Keep it as is
      } else {
        errorType = 'Error';
      }
      
      // Prevent potentially sensitive information in error messages
      if (errorMessage.contains('password') || 
          errorMessage.contains('token') || 
          errorMessage.contains('key') || 
          errorMessage.contains('secret')) {
        errorMessage = 'An error occurred. Please try again later.';
      }
    }
    
    // Simple user-friendly header when in production mode
    if (!_effectiveShowFullDetails && !widget.debugMode) {
      return Container(
        color: const Color(0xFFFF291B),
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Error',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            if (widget.onReport != null)
              ElevatedButton(
                onPressed: widget.onReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFFF291B),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Report'),
              ),
          ],
        ),
      );
    }
    
    // Original detailed header for debug mode
    return Container(
      color: const Color(0xFFFF291B),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  errorType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_effectiveShowFullDetails)
                IconButton(
                  icon: Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white
                  ),
                  onPressed: () => setState(() => _expanded = !_expanded),
                  tooltip: _expanded ? 'Collapse' : 'Expand',
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  padding: EdgeInsets.zero,
                ),
              if (widget.onReport != null && widget.debugMode)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bug_report, size: 14),
                    label: const Text(
                      'Report',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF291B),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(0, 32),
                    ),
                    onPressed: widget.onReport,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 120,
            ),
            child: SingleChildScrollView(
              child: Text(
                errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (widget.requestInfo != null && _effectiveShowFullDetails) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTagPill(
                  widget.requestInfo!['method'] ?? 'GET', 
                  backgroundColor: const Color(0xFFFF5943),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.requestInfo!['url'] ?? 'Unknown URL',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ],
          // Show file and line info if available from Laravel exception and not in production
          if (_laravelExceptionData.containsKey('file') && 
              _laravelExceptionData.containsKey('line') && 
              _effectiveShowFullDetails &&
              widget.debugMode) ...[
            const SizedBox(height: 8),
            Text(
              'at ${_laravelExceptionData['file']}:${_laravelExceptionData['line']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1F2937),
        unselectedLabelColor: const Color(0xFF6B7280),
        indicatorColor: const Color(0xFFFF291B),
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Stack Trace'),
          Tab(text: 'Context'),
          Tab(text: 'Request'),
          Tab(text: 'App Info'),
          Tab(text: 'Debug'),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (!_effectiveShowFullDetails) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Color(0xFFFF291B),
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              !widget.debugMode
                ? 'We\'re sorry, but we encountered an error. Our team has been notified and is working to fix the issue.'
                : 'Additional error details have been logged.',
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (!widget.debugMode && widget.onReport != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 160, // Fixed width for button
                child: ElevatedButton.icon(
                  onPressed: widget.onReport,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF291B),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }
    
    if (!_expanded) {
      return const SizedBox();
    }
    
    return SizedBox(
      height: 300,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildStackTraceTab(),
          _buildContextTab(),
          _buildRequestTab(),
          _buildAppInfoTab(),
          _buildDebugTab(),
        ],
      ),
    );
  }

  Widget _buildStackTraceTab() {
    // If we have Laravel exception data with a trace, use that
    if (_laravelExceptionData.containsKey('trace') && _laravelExceptionData['trace'] is List) {
      return _buildLaravelStackTrace();
    }
    
    final stackTrace = widget.stackTrace?.toString() ?? 'No stack trace available';
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stack Trace',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SelectableText(
                stackTrace,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLaravelStackTrace() {
    // Extract data for Laravel exception details
    final exception = _laravelExceptionData['exception'] ?? 'Unknown Exception';
    final file = _laravelExceptionData['file'] ?? 'Unknown file';
    final line = _laravelExceptionData['line']?.toString() ?? '?';
    final trace = _laravelExceptionData['trace'] as List;
    final controller = ScrollController();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exception: $exception',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'at $file:$line',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Stack Trace:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            width: double.infinity,
            child: ListView.builder(
              itemCount: trace.length,
              controller: controller,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final frame = trace[index] as Map<String, dynamic>;
                String frameText = '';
                
                // Format frame based on available information
                if (frame.containsKey('file') && frame.containsKey('line')) {
                  final function = frame.containsKey('function') ? frame['function'] : 'unknown';
                  final className = frame.containsKey('class') ? frame['class'] : '';
                  final type = frame.containsKey('type') ? frame['type'] : '';
                  
                  // Format: #index File: path/to/file.php:line
                  frameText = '#$index ${className}$type$function()';
                  frameText += '\n    ${frame['file']}:${frame['line']}';
                } else if (frame.containsKey('function')) {
                  // Some frames just have function
                  frameText = '#$index ${frame['function']}()';
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    frameText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextTab() {
    final context = widget.context ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Error Context',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          if (context.isEmpty)
            const Text(
              'No context data available',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _buildJsonTree(context),
        ],
      ),
    );
  }

  Widget _buildRequestTab() {
    final request = widget.requestInfo ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Request Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          if (request.isEmpty)
            const Text(
              'No request data available',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _buildJsonTree(request),
        ],
      ),
    );
  }

  Widget _buildAppInfoTab() {
    final appInfo = widget.appInfo ?? {};
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Application Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          if (appInfo.isEmpty)
            const Text(
              'No application info available',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontStyle: FontStyle.italic,
              ),
            )
          else
            _buildJsonTree(appInfo),
        ],
      ),
    );
  }

  Widget _buildDebugTab() {
    // Check if we have Laravel exception data
    if (_laravelExceptionData.isNotEmpty) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laravel Exception',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            _buildJsonTree(_laravelExceptionData),
            const SizedBox(height: 16),
            const Text(
              'Raw Error',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1F2937),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              child: SelectableText(
                widget.error.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // Default debug view for non-Laravel errors
    final errorString = widget.error.toString();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Raw Error',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            child: SelectableText(
              errorString,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Error Object',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          _buildErrorObjectInfo(),
        ],
      ),
    );
  }

  Widget _buildErrorObjectInfo() {
    // Extract properties from the error object if possible
    Map<String, dynamic> errorProps = {};
    
    try {
      // Try to extract properties from the error object
      final error = widget.error;
      
      // Get list of properties and methods using reflection (where available)
      // This is a simplified approach - in a real app you might use more
      // sophisticated reflection to extract properties
      errorProps = {
        'type': error.runtimeType.toString(),
        'toString()': error.toString(),
        'hashCode': error.hashCode.toString(),
      };
      
      // Try to get additional properties if they exist
      if (error is Exception) {
        errorProps['isException'] = 'true';
      }
      if (error is Error) {
        errorProps['isError'] = 'true';
      }
    } catch (e) {
      errorProps = {
        'extraction_error': 'Failed to extract error properties: $e',
      };
    }
    
    return _buildJsonTree(errorProps);
  }

  Widget _buildJsonTree(Map<String, dynamic> data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = data.entries.elementAt(index);
          return _buildJsonTreeItem(entry.key, entry.value);
        },
      ),
    );
  }

  Widget _buildJsonTreeItem(String key, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Make the key part flexible to prevent overflow on long keys
          Flexible(
            flex: 1,
            child: Text(
              key,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B5563),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Expand the value part to take remaining space
          Flexible(
            flex: 3,
            child: _buildValueWidget(value),
          ),
        ],
      ),
    );
  }

  Widget _buildValueWidget(dynamic value) {
    if (value == null) {
      return const Text(
        'null',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: Color(0xFF6B7280),
        ),
      );
    }

    if (value is String) {
      // Try to detect if the string is JSON
      try {
        final Map<String, dynamic> jsonMap = json.decode(value);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '[JSON String]',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            _buildJsonTree(jsonMap),
          ],
        );
      } catch (_) {
        // Not JSON, just show the string
        return SelectableText(
          value,
          style: TextStyle(
            color: value.isEmpty ? const Color(0xFF6B7280) : const Color(0xFF1F2937),
            fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
          ),
        );
      }
    }

    if (value is Map) {
      return _buildJsonTree(Map<String, dynamic>.from(value));
    }

    if (value is List) {
      if (value.isEmpty) {
        return const Text(
          '(empty list)',
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Color(0xFF6B7280),
          ),
        );
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < value.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Index label with fixed width
                  SizedBox(
                    width: 20,
                    child: Text(
                      '$i:',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  // Use Flexible for the value to prevent overflow
                  Flexible(
                    child: _buildValueWidget(value[i]),
                  ),
                ],
              ),
            ),
        ],
      );
    }

    // For all other types, just convert to string
    return Text(
      value.toString(),
      style: const TextStyle(color: Color(0xFF1F2937)),
    );
  }

  Widget _buildFooter() {
    final environmentTag = !widget.debugMode
        ? 'Production' 
        : (widget.appInfo?['debug_mode'] ?? 'Debug');
    
    // If we have custom actions, display them in a dedicated footer
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widget.actions!,
        ),
      );
    }
    
    // Show simplified footer for production/user-facing mode
    if (!_effectiveShowFullDetails && !widget.debugMode) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          color: Color(0xFFF9FAFB),
          border: Border(
            top: BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.info_outline,
              size: 14,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(width: 6),
            const Text(
              'If the problem persists, please contact support',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
        
    // Original technical footer for debug mode
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF9FAFB),
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max, // Ensure row takes full width
        children: [
          // Left side with info - use Flexible to allow text to shrink if needed
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'PingErrorView',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: !widget.debugMode ? Colors.orange : Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    environmentTag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Add spacing between left and right content
          const SizedBox(width: 8),
          
          // Right side with action button
          if (_effectiveShowFullDetails)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B7280),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
                // Minimize internal padding to save space
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(_expanded ? 'Collapse' : 'Expand Details'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildTagPill(String text, {Color backgroundColor = const Color(0xFFFF5943)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 