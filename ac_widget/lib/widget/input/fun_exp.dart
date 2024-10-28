import 'dart:math';

void main() {
  String expression = "6+(sin(x)+cos(0)+sqrt(4))*2";
  var evaluator = ExpressionEvaluator(expression);
  var result = evaluator.evaluate({'x': pi / 2}); // sin(pi/2) = 1
  print(result); // 输出 2.0
}

class ExpressionEvaluator {
  String _expression;
  int _pos = 0;

  ExpressionEvaluator(String expression)
      : _expression = expression.replaceAll(RegExp(r'\s+'), ''); // 去掉所有空白字符

  void update(String expression){
    _expression = expression.replaceAll(RegExp(r'\s+'), '');
  }

  double evaluate(Map<String, double> variables) {
    _pos = 0; // 重置位置
    return _parseExpression(variables);
  }

  double _parseExpression(Map<String, double> variables) {
    double result = _parseTerm(variables);

    while (_pos < _expression.length) {
      if (_expression[_pos] == '+') {
        _pos++;
        result += _parseTerm(variables);
      } else if (_expression[_pos] == '-') {
        _pos++;
        result -= _parseTerm(variables);
      } else {
        break;
      }
    }
    return result;
  }

  double _parseTerm(Map<String, double> variables) {
    double result = _parseFactor(variables);

    while (_pos < _expression.length) {
      if (_expression[_pos] == '*') {
        _pos++;
        result *= _parseFactor(variables);
      } else if (_expression[_pos] == '/') {
        _pos++;
        result /= _parseFactor(variables);
      } else {
        break;
      }
    }
    return result;
  }

  double _parseFactor(Map<String, double> variables) {
    if (_pos >= _expression.length) {
      throw Exception('Unexpected end of expression');
    }

    // 处理函数
    if (_expression.startsWith('sin', _pos)) {
      _pos += 3;
      return sin(_parseParentheses(variables));
    } else if (_expression.startsWith('cos', _pos)) {
      _pos += 3;
      return cos(_parseParentheses(variables));
    } else if (_expression.startsWith('tan', _pos)) {
      _pos += 3;
      return tan(_parseParentheses(variables));
    } else if (_expression.startsWith('log', _pos)) {
      _pos += 3;
      return log(_parseParentheses(variables));
    } else if (_expression.startsWith('sqrt', _pos)) {
      _pos += 4;
      return sqrt(_parseParentheses(variables));
    } else if (_expression.startsWith('exp', _pos)) {
      _pos += 3;
      return exp(_parseParentheses(variables));
    }
    // 处理括号
    if (_expression[_pos] == '(') {
      _pos++; // 跳过左括号
      double result = _parseExpression(variables);
      if (_pos >= _expression.length || _expression[_pos] != ')') {
        throw Exception('Expected closing parenthesis');
      }
      _pos++; // 跳过右括号
      return result;
    }
    // 处理变量或数字
    if (_expression[_pos].contains(RegExp(r'[a-zA-Z]'))) {
      String varName = _expression[_pos++];
      return variables[varName] ?? 0.0;
    } else {
      StringBuffer buffer = StringBuffer();
      while (_pos < _expression.length &&
          (_expression[_pos].contains(RegExp(r'[0-9]')) ||
              _expression[_pos] == '.')) {
        buffer.write(_expression[_pos++]);
      }
      return double.parse(buffer.toString());
    }
  }

  double _parseParentheses(Map<String, double> variables) {
    if (_expression[_pos] == '(') {
      _pos++; // 跳过左括号
      double result = _parseExpression(variables);
      if (_expression[_pos] != ')') {
        throw Exception('Expected closing parenthesis');
      }
      _pos++; // 跳过右括号
      return result;
    } else {
      return _parseFactor(variables);
    }
  }
}
