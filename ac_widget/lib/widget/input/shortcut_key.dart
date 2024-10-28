import 'package:flutter/cupertino.dart';

///一个快捷键对应一个意图， 一个意图绑定一个回调

class ShortData<T extends Intent> {
  ///快捷键对应的回调函数
  final OnInvokeCallback<T> callback;
  ///一个自定义的意图
  /// class CustomInter extends Intent {
  ///   const CustomInter();
  /// }
  final T intent;
  ///快捷键 SingleActivator（）
  final SingleActivator singleActivator;

  ShortData({
    required this.callback,
    required this.intent,
    required this.singleActivator,
  });
}

class ShortcutKey extends StatefulWidget {
  final Widget child;
  final List<ShortData> shorts;

  const ShortcutKey({super.key, required this.child, this.shorts = const []});

  @override
  State<ShortcutKey> createState() => _ShortcutKeyState();
}

class _ShortcutKeyState extends State<ShortcutKey> {
  final Map<ShortcutActivator, Intent> _shortcuts = {};
  final Map<Type, Action<Intent>> _actions = {};

  @override
  void initState() {
    super.initState();
    setShortcuts();
  }

  void setShortcuts() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (ShortData short in widget.shorts) {
        _shortcuts[short.singleActivator] = short.intent;
        _actions[short.intent.runtimeType] = CallbackAction<Intent>(
          onInvoke: (intent) => short.callback(intent),
        );
      }
      setState(() {}); // 更新界面
    });
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: _shortcuts,
      child: Actions(
        actions: _actions,
        child: Focus(
          autofocus: true, // 确保组件获取焦点以接收键盘事件
          child: widget.child,
        ),
      ),
    );
  }
}

