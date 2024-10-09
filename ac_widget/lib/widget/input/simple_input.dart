import 'package:flutter/material.dart';

//我想要的输入框是什么样的？ 有边框 无边框 边框圆角  边框颜色
//

enum BorderType {
  under,
  outline,
}

class SimpleInput extends StatefulWidget {
  final TextEditingController controller;
  final BorderType borderType;

  const SimpleInput(
      {super.key,
      required this.controller,
      this.borderType = BorderType.outline});

  @override
  State<SimpleInput> createState() => _SimpleInputState();
}

class _SimpleInputState extends State<SimpleInput> {
  final FocusNode _focusNode = FocusNode();
  Color _fillColor = const Color(0xffe5e6e8); // 默认填充色
  late InputBorder border;

  @override
  void initState() {
    if (widget.borderType == BorderType.outline) {
      border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(width:1,color: Color(0xff267ef0)),
      );
    } else {
      border = const UnderlineInputBorder();
    }
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _fillColor = _focusNode.hasFocus ? Colors.white : const Color(0xffe5e6e8);
    });
  }

  bool _error = false;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      style: const TextStyle(height: 1),
      decoration: InputDecoration(
        // isDense: true,
        // constraints: BoxConstraints(maxWidth: 240),
        // filled: true,
        // contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        // fillColor: _fillColor,
        // prefixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 32),
        // prefixIcon: const Icon(Icons.supervised_user_circle, size: 18),
        // prefixIconColor: const Color(0xff63676d),
        // prefixText: "User:: ",
        // prefixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        // suffixText: '::call',
        // suffixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        // suffixIcon:
        //     GestureDetector(onTap: _toggleError, child: Icon(Icons.call)),
        // suffixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 32),
        // focusColor: Colors.white,
        // suffixIconColor: Colors.blue,
        // labelStyle: const TextStyle(color: Colors.grey),
        // hintText: 'Input...',
        // hintStyle: const TextStyle(color: Colors.grey),
        // labelText: 'Account',
        // helperText: 'Help me?',
        // helperStyle: const TextStyle(
        //     color: Colors.blue,
        //     decoration: TextDecoration.underline,
        //     decorationColor: Colors.blue),
        // errorText: _error ? 'This is an Test Error!' : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xff267ef0)),
        ),
        // errorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(4),
        //   borderSide: const BorderSide(color: Colors.redAccent),
        // ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(4),
        //   borderSide: const BorderSide(color: Colors.redAccent),
        // ),
        enabledBorder:OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(width:1,color: Color(0xff267ef0)),
        ),
        border: border,
      ),
    );
  }

  void _toggleError() {
    setState(() {
      _error = !_error;
    });
  }
}
