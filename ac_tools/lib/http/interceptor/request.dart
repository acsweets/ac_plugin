//Option拦截器可以用来统一处理Option信息 可以在这里添加
import 'package:dio/dio.dart';

import '../../ac_tools.dart';

class OptionInterceptor extends InterceptorsWrapper {
  final Map<String, dynamic>? headers;
  OptionInterceptor({this.headers});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    showLoading();
    //在请求发起前修改头部
    // options.headers["token"] = "11111";
    ///请求的Content-Type，默认值是"application/json; charset=utf-8".
    /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
    options.contentType = Headers.formUrlEncodedContentType;

    ///如果你的headers是固定的你可以在BaseOption中设置,如果不固定可以在这里进行根据条件设置
    if (headers != null) options.headers.addAll(headers!);
    //开发阶段可以把地址带参数打印出来方便校验结果
    Log.d(
        "request:${options.method}\t url-->${options.baseUrl}${options.path}?${options.queryParameters}");
    if (options.queryParameters["hideLoading"] != true) {
      // EasyLoading.show();
    }
// 一定要加上这句话 否则进入不了下一步
    return handler.next(options);
  }
}
