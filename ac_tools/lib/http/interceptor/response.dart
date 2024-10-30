import 'package:ac_tools/ac_tools.dart';
import 'package:dio/dio.dart';

///响应拦截器
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(Response response, handler) {
    RequestOptions option = response.requestOptions;
    try {
      // if (option.contentType != null && option.contentType == "text") {}
      if (response.statusCode == 200 || response.statusCode == 201) {
        ///一般只需要处理200的情况，300、400、500保留错误信息
        Log.d('${response.statusCode} ${response.data.toString()}');
      }
    } catch (e) {
      Log.e('$e 错误API： ${option.path}  ${response.statusCode}');
    }
    closeLoading();
    handler.next(response);
  }
}
