import 'package:dio/dio.dart';

class ResultData {
  dynamic data;
  bool isSuccess;
  int code;
  dynamic headers;

  ResultData(this.data, this.isSuccess, this.code, {this.headers});
}

///响应拦截器
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  ResultData onResponse(Response response, handler) {
    RequestOptions option = response.requestOptions;
    try {
      if (option.contentType != null && option.contentType == "text") {
        return ResultData(response.data, true, 200);
      }

      ///一般只需要处理200的情况，300、400、500保留错误信息
      if (response.statusCode == 200 || response.statusCode == 201) {
        int code = response.data["code"];
        if (code == 0) {
          return ResultData(response.data, true, 200,
              headers: response.headers);
        } else if (code == 100006 || code == 100007) {
        } else {
          // Fluttertoast.showToast(msg: response.data["msg"]);
          return ResultData(response.data, false, 200,
              headers: response.headers);
        }
      }
    } catch (e) {
      print(e.toString() + option.path);

      return ResultData(response.data, false, response.statusCode ?? 502,
          headers: response.headers);
    }

    return ResultData(response.data, false, response.statusCode ?? 502,
        headers: response.headers);
  }
}
