import 'package:dio/dio.dart';

///日志拦截器    //判断成功与失败, 200 成功  401 授权过期， 422 请求参数错误，429 请求校验不通过
class DioLogInterceptor extends Interceptor {
  @override
  void onRequest(options, handler) {
    String requestStr = "\n==================== REQUEST ====================\n"
        "- URL:\n${options.baseUrl + options.path}\n"
        "- METHOD: ${options.method}\n";

    requestStr += "- HEADER:\n${options.headers.mapToStructureString()}\n";

    final data = options.data;
    if (data != null) {
      if (data is Map) {
        requestStr += "- BODY:\n${data.mapToStructureString()}\n";
      } else if (data is FormData) {
        final formDataMap = {}
          ..addEntries(data.fields)
          ..addEntries(data.files);
        requestStr += "- BODY:\n${formDataMap.mapToStructureString()}\n";
      } else {
        requestStr += "- BODY:\n${data.toString()}\n";
      }
    }
    handler.next(options);
    print(requestStr);
  }

  @override
  void onError(DioException err, handler) async {
    String errorStr = "\n==================== RESPONSE ====================\n"
        "- URL:\n${err.requestOptions.baseUrl + err.requestOptions.path}\n"
        "- METHOD: ${err.requestOptions.method}\n";

    errorStr += "- HEADER:\n${err.requestOptions.headers.map.toString()}\n";
    if (err.response != null && err.response?.data != null) {
      print('╔ ${err.type.toString()}');
      errorStr += "- ERROR:\n${_parseResponse(err.response!)}\n";
    } else {
      errorStr += "- ERRORTYPE: ${err.type}\n";
      errorStr += "- MSG: ${err.message}\n";
    }
    print(errorStr);
    handler.next(err);
  }

  @override
  void onResponse(response, handler) async {
    String responseStr =
        "\n==================== RESPONSE ====================\n"
        "- URL:\n${response.requestOptions.uri}\n";
    responseStr += "- HEADER:\n{";
    response.headers.forEach(
        (key, list) => responseStr += "\n  " + "\"$key\" : \"$list\",");
    responseStr += "\n}\n";
    responseStr += "- STATUS: ${response.statusCode}\n";

    if (response.data != null) {
      responseStr += "- BODY:\n ${_parseResponse(response)}";
    }
    printWrapped(responseStr);
    handler.next(response);
  }

  void printWrapped(String text) {
    final pattern =  RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  String _parseResponse(Response response) {
    String responseStr = "";
    var data = response.data;
    if (data is Map) {
      responseStr += data.mapToStructureString();
    } else if (data is List) {
      responseStr += data.listToStructureString();
    } else {
      responseStr += response.data.toString();
    }

    return responseStr;
  }
}

extension Map2StringEx on Map {
  String mapToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "{";
      this.forEach((key, value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$key\" : $temp,";
        } else if (value is List) {
          result += "\n$indentationStr" +
              "\"$key\" : ${value.listToStructureString(indentation: indentation + 2)},";
        } else {
          result += "\n$indentationStr" + "\"$key\" : \"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += indentation == 2 ? "\n}" : "\n${" " * (indentation - 1)}}";
    }

    return result;
  }
}

extension List2StringEx on List {
  String listToStructureString({int indentation = 2}) {
    String result = "";
    String indentationStr = " " * indentation;
    if (true) {
      result += "$indentationStr[";
      forEach((value) {
        if (value is Map) {
          var temp = value.mapToStructureString(indentation: indentation + 2);
          result += "\n$indentationStr" + "\"$temp\",";
        } else if (value is List) {
          result += value.listToStructureString(indentation: indentation + 2);
        } else {
          result += "\n$indentationStr" + "\"$value\",";
        }
      });
      result = result.substring(0, result.length - 1);
      result += "\n$indentationStr]";
    }

    return result;
  }
}
