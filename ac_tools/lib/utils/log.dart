import 'package:logger/logger.dart';

enum LogLevel {
  d('DEBUG '),
  i('INFO'),
  w('WARNING'),
  e('ERROR'),
  t('TRACE'),
  ;

  final String level;

  const LogLevel(this.level);
}

//通过输入枚举更改输出的日志，颜色没有必要自定义，反正日志是给自己看的
//支持筛选指定类型的日志
class Log {
  static Log? _instance;

  static Log get instance => _instance ??= Log._();

  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  Log._();

  /// 自由控制日志筛选
  void init(
      {Level? filterLevel,
      String? filterMessage,
      Level? targetLevel,
      bool isDebug = true}) {
    logger = Logger(
      printer: PrettyPrinter(),
      level: filterLevel,
      filter: CustomFilter(
        message: filterMessage,
        targetLevel: targetLevel,
        isDebug: isDebug,
      ),
    );
  }

  static t(dynamic message) {
    logger.t('TRACK<level:1000> $message');
  }

  static d(dynamic message) {
    logger.d('DEBUG<level:2000> $message');
  }

  static i(dynamic message) {
    logger.i('INFO<level:3000> $message');
  }

  static w(dynamic message) {
    logger.w('WARNING<level:4000> $message');
  }

  static e(dynamic message) {
    logger.e('ERROR<level:5000> $message');
  }

  static f(dynamic message) {
    logger.f('FATAL<level:6000> $message');
  }

}

void main() {
  // Log.instance.init(filterLevel: Level.trace,filterMessage: 'WARNING<level:4000> w');
  // Log.instance.init(filterLevel: Level.trace,);

  Log.d([1,2,3,]);
  Log.i('i');
  Log.w('w');
  Log.t('t');
}

class DevelopmentFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;
    assert(() {
      ///log的紧急程度比当前高
      if (event.level.value >= level!.value) {
        shouldLog = true;
      }
      return true;
    }());
    return shouldLog;
  }
}

/// 筛选指定[level]的日志
class CustomFilter extends LogFilter {
  final String? message;
  final Level? targetLevel;
  final bool isDebug;

  CustomFilter({
    this.message,
    this.targetLevel,
    this.isDebug = true,
  });

  /// 每次发送新的日志消息时调用，并决定是打印还是取消。如果消息应该是 logger，则返回“true”  日日志信息和时间也能筛选
  ///在 assert 内的代码块中，shouldLog 会根据条件来更新，但这些更新只在 调试模式下生效；在 发布模式中，assert 语句会被跳过。
//     if (kDebugMode)
  @override
  bool shouldLog(LogEvent event) {
    var shouldLog = false;

    // 在 assert 内的代码块中执行条件判断，只有在调试模式下才会生效。
    assert(() {
      shouldLog = (message != null && event.message == message) ||
          (targetLevel != null && event.level.value == targetLevel?.value) ||
          (event.level.value >= level!.value &&
              targetLevel == null &&
              message == null);
      return true;
    }());

    // 如果不在调试模式，则直接进行条件判断
    if (!isDebug) {
      shouldLog = (message != null && event.message == message) ||
          (targetLevel != null && event.level.value == targetLevel?.value) ||
          (event.level.value >= level!.value &&
              targetLevel == null &&
              message == null);
    }

    return shouldLog;
  }
}
