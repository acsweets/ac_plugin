// enum CacheControl {
//   noCache, //不使用缓存
//   onlyCache, //只用缓存
//   cacheFirstOrNetworkPut, //有缓存先用缓存，没有缓存进行网络请求再存入缓存
//   onlyNetworkPutCache, //只用网络请求，但是会存入缓存
// }
//
// //项目中只用到了Get Post 两种方式
// enum HttpMethod { GET, POST }
//
// ///Dio封装管理,网络请求引擎类
// class HttpProvider {
//   //具体的执行网络请求逻辑在引擎类中
//   final networkEngine = NetworkEngine();
//
//   /// 封装网络请求入口
//   Future<HttpResult> requestNetResult(
//       String url, {
//         HttpMethod method = HttpMethod.GET, //指明Get还是Post请求
//         Map<String, String>? headers, //请求头
//         Map<String, dynamic>? params, //请求参数，Get的Params,Post的Form
//         Map<String, String>? paths, //文件Flie
//         Map<String, Uint8List>? pathStreams, //文件流
//         CacheControl? cacheControl, // Get请求是否需要缓存
//         Duration? cacheExpiration, //缓存是否需要过期时间，过期时间为多长时间
//         ProgressCallback? send, // 上传进度监听
//         ProgressCallback? receive, // 下载监听
//         CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//         bool networkDebounce = false, // 当前网络请求是否需要网络防抖去重
//         bool isShowLoadingDialog = false, // 是否展示 Loading 弹框
//       }) async {
//     //尝试网络请求去重,内部逻辑判断发起真正的网络请求
//     if (networkDebounce) {
//       if (headers == null || headers.isEmpty) {
//         headers = <String, String>{};
//       }
//       headers['network_debounce'] = "true";
//     }
//
//     if (isShowLoadingDialog) {
//       if (headers == null || headers.isEmpty) {
//         headers = <String, String>{};
//       }
//       headers['is_show_loading_dialog'] = "true";
//     }
//
//     return _executeRequests(
//       url,
//       method,
//       headers,
//       params,
//       paths,
//       pathStreams,
//       cacheControl,
//       cacheExpiration,
//       send,
//       receive,
//       cancelToken,
//       networkDebounce,
//     );
//   }
//
//   /// 真正的执行请求，处理缓存与返回的结果
//   Future<HttpResult> _executeRequests(
//       String url, //请求地址
//       HttpMethod method, //请求方式
//       Map<String, String>? headers, //请求头
//       Map<String, dynamic>? params, //请求参数
//       Map<String, String>? paths, //文件
//       Map<String, Uint8List>? pathStreams, //文件流
//       CacheControl? cacheControl, //Get请求缓存控制
//       Duration? cacheExpiration, //缓存文件有效时间
//       ProgressCallback? send, // 上传进度监听
//       ProgressCallback? receive, // 下载监听
//       CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//       bool networkDebounce, // 当前网络请求是否需要网络防抖去重
//       ) async {
//     try {
//       //根据参数封装请求并开始请求
//       Response response;
//
//       // 定义一个局部函数，封装重复的请求逻辑
//       Future<Response> executeGenerateRequest() async {
//         return _generateRequest(
//           method,
//           params,
//           paths,
//           pathStreams,
//           url,
//           headers,
//           cacheControl,
//           cacheExpiration,
//           send,
//           receive,
//           cancelToken,
//         );
//       }
//
//       if (!AppConstant.inProduction) {
//         final startTime = DateTime.now();
//         response = await executeGenerateRequest();
//         final endTime = DateTime.now();
//         final duration = endTime.difference(startTime).inMilliseconds;
//         Log.d('网络请求耗时 $duration 毫秒,HttpCode:${response.statusCode} HttpMessage:${response.statusMessage} 响应内容 ${response.data}}');
//       } else {
//         response = await executeGenerateRequest();
//       }
//
//       //判断成功与失败, 200 成功  401 授权过期， 422 请求参数错误，429 请求校验不通过
//       if (response.statusCode == 200 || response.statusCode == 401 || response.statusCode == 422 || response.statusCode == 429) {
//         //网络请求完成之后获取正常的Json-Map
//         Map<String, dynamic> jsonMap = response.data;
//
//         //Http处理完了，现在处理 API 的 Code
//         if (jsonMap.containsKey('code')) {
//           int code = jsonMap['code'];
//
//           // 如果有 code，并且 code = 0 说明成功
//           if (code == 0) {
//             if (jsonMap['data'] is List<dynamic>) {
//               //成功->返回数组
//               return HttpResult(
//                 isSuccess: true,
//                 code: code,
//                 msg: jsonMap['msg'],
//                 listJson: jsonMap['data'], //赋值给的 listJson 字段
//               );
//             } else {
//               //成功->返回对象
//               return HttpResult(
//                 isSuccess: true,
//                 code: code,
//                 msg: jsonMap['msg'],
//                 dataJson: jsonMap['data'], //赋值给的 dataJson 字段
//               );
//             }
//
//             //如果code !=0 ,下面是错误的情况判断
//           } else {
//             if (jsonMap.containsKey('errors')) {
//               //拿到错误信息对象
//               return HttpResult(isSuccess: false, code: code, errorObj: jsonMap['errors'], errorMsg: jsonMap['message']);
//             } else if (jsonMap.containsKey('msg')) {
//               //如果有msg字符串优先返回msg字符串
//               return HttpResult(isSuccess: false, code: code, errorMsg: jsonMap['msg']);
//             } else {
//               //什么都没有就返回Http的错误字符串
//               return HttpResult(isSuccess: false, code: code, errorMsg: jsonMap['message']);
//             }
//           }
//         } else {
//           //没有code，说明有错误信息，判断错误信息
//           if (jsonMap.containsKey('errors')) {
//             //拿到错误信息对象
//             return HttpResult(isSuccess: false, errorObj: jsonMap['errors'], errorMsg: jsonMap['message']);
//           } else if (jsonMap.containsKey('msg')) {
//             //如果有msg字符串优先返回msg字符串
//             return HttpResult(isSuccess: false, errorMsg: jsonMap['msg']);
//           } else {
//             //什么都没有就返回Http的错误字符串
//             return HttpResult(isSuccess: false, errorMsg: jsonMap['message']);
//           }
//         }
//       } else {
//         //返回Http的错误,给 Http Response 的 statusMessage 值
//         return HttpResult(
//           isSuccess: false,
//           code: response.statusCode ?? ApiConstants.networkDebounceCode,
//           errorMsg: response.statusMessage,
//         );
//       }
//     } on DioException catch (e) {
//       Log.e("HttpProvider - DioException：$e  其他错误Error:${e.error.toString()}");
//       if (e.response != null) {
//         // 如果其他的Http网络请求的Code的处理
//         Log.d("网络请求错误，data：${e.response?.data}");
//         return HttpResult(isSuccess: false, errorMsg: "错误码：${e.response?.statusCode} 错误信息：${e.response?.statusMessage}");
//       } else if (e.type == DioExceptionType.connectionTimeout ||
//           e.type == DioExceptionType.sendTimeout ||
//           e.type == DioExceptionType.receiveTimeout) {
//         return HttpResult(isSuccess: false, errorMsg: "网络连接超时，请稍后再试");
//       } else if (e.type == DioExceptionType.cancel) {
//         return HttpResult(isSuccess: false, errorMsg: "网络请求已取消");
//       } else if (e.type == DioExceptionType.badCertificate) {
//         return HttpResult(isSuccess: false, errorMsg: "网络连接证书无效");
//       } else if (e.type == DioExceptionType.badResponse) {
//         return HttpResult(isSuccess: false, errorMsg: "网络响应错误，请稍后再试");
//       } else if (e.type == DioExceptionType.connectionError) {
//         return HttpResult(isSuccess: false, errorMsg: "网络连接错误，请检查网络连接");
//       } else if (e.type == DioExceptionType.unknown) {
//         //未知错误中尝试打印具体的错误信息
//         if (e.error != null) {
//           if (e.error.toString().contains("HandshakeException")) {
//             return HttpResult(isSuccess: false, errorMsg: "网络连接错误，请检查网络连接");
//           } else {
//             return HttpResult(isSuccess: false, errorMsg: e.error.toString()); //这里打印的就是英文错误了，没有格式化
//           }
//         } else {
//           return HttpResult(isSuccess: false, errorMsg: "网络请求出现未知错误");
//         }
//       } else {
//         //如果有response走Api错误
//         return HttpResult(isSuccess: false, errorMsg: e.message);
//       }
//     }
//   }
//
//   ///生成对应Get与Post的请求体，并封装对应的参数
//   Future<Response> _generateRequest(
//       HttpMethod? method,
//       Map<String, dynamic>? params,
//       Map<String, String>? paths, //文件
//       Map<String, Uint8List>? pathStreams, //文件流
//       String url,
//       Map<String, String>? headers,
//       CacheControl? cacheControl,
//       Duration? cacheExpiration,
//       ProgressCallback? send, // 上传进度监听
//       ProgressCallback? receive, // 下载监听
//       CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//       ) async {
//     if (method != null && method == HttpMethod.POST) {
//       //以 Post 请求 FromData 的方式上传
//       return networkEngine.executePost(
//         url: url,
//         params: params,
//         paths: paths,
//         pathStreams: pathStreams,
//         headers: headers,
//         send: send,
//         receive: receive,
//         cancelToken: cancelToken,
//       );
//     } else {
//       //默认 Get 请求，添加逻辑是否需要处理缓存策略，具体缓存逻辑见拦截器
//
//       if (cacheControl != null) {
//         if (headers == null || headers.isEmpty) {
//           headers = <String, String>{};
//         }
//         headers['cache_control'] = cacheControl.name;
//
//         if (cacheExpiration != null) {
//           headers['cache_expiration'] = cacheExpiration.inMilliseconds.toString();
//         }
//       }
//
//       return networkEngine.executeGet(
//         url: url,
//         params: params,
//         headers: headers,
//         cacheControl: cacheControl,
//         cacheExpiration: cacheExpiration,
//         receive: receive,
//         cancelToken: cancelToken,
//       );
//     }
//   }
// }
//
// /*
//  * 网络请求引擎封装，目前使用的是 Dio 框架
//  */
// class NetworkEngine {
//   late Dio dio;
//
//   NetworkEngine() {
//     /// 网络配置
//     final options = BaseOptions(
//         baseUrl: ApiConstants.baseUrl,  //不会想要我的域名吧？用你自己的域名吧
//         connectTimeout: const Duration(seconds: 30),
//         sendTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         validateStatus: (code) {
//           //指定这些HttpCode都算成功（再骂一下我们的后端，真尼玛坑）
//           if (code == 200 || code == 401 || code == 422 || code == 429) {
//             return true;
//           } else {
//             return false;
//           }
//         });
//
//     dio = Dio(options);
//
//     // 设置Dio的转换器
//     dio.transformer = BackgroundTransformer(); //Json后台线程处理优化（可选）
//
//     // 设置Dio的拦截器
//     dio.interceptors.add(NetworkDebounceInterceptor()); //处理网络请求去重逻辑
//     dio.interceptors.add(AuthDioInterceptors()); //处理请求之前的请求头（项目业务逻辑）
//     dio.interceptors.add(StatusCodeDioInterceptors()); //处理响应之后的状态码（项目业务逻辑）
//     dio.interceptors.add(CacheControlnterceptor()); //处理 Http Get 请求缓存策略
//     if (!AppConstant.inProduction) {
//       dio.interceptors.add(LogInterceptor(responseBody: false)); //默认的 Dio 的 Log 打印
//     }
//   }
//
//   /// 网络请求 Post 请求
//   Future<Response> executePost({
//     required String url,
//     Map<String, dynamic>? params,
//     Map<String, String>? paths, //文件
//     Map<String, Uint8List>? pathStreams, //文件流
//     Map<String, String>? headers,
//     ProgressCallback? send, // 上传进度监听
//     ProgressCallback? receive, // 下载监听
//     CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//   }) async {
//     var map = <String, dynamic>{};
//
//     if (params != null || paths != null || pathStreams != null) {
//       //只要有一个不为空，就可以封装参数
//
//       //默认的参数
//       if (params != null) {
//         map.addAll(params);
//       }
//
//       //Flie文件
//       if (paths != null && paths.isNotEmpty) {
//         for (final entry in paths.entries) {
//           final key = entry.key;
//           final value = entry.value;
//
//           if (value.isNotEmpty && RegCheckUtils.isLocalImagePath(value)) {
//             // 以文件的方式压缩，获取到流对象
//             Uint8List? stream = await FlutterImageCompress.compressWithFile(
//               value,
//               minWidth: 1000,
//               minHeight: 1000,
//               quality: 80,
//             );
//
//             //传入压缩之后的流对象
//             if (stream != null) {
//               map[key] = MultipartFile.fromBytes(stream, filename: "file");
//             }
//           }
//         }
//       }
//
//       //File文件流
//       if (pathStreams != null && pathStreams.isNotEmpty) {
//         for (final entry in pathStreams.entries) {
//           final key = entry.key;
//           final value = entry.value;
//
//           if (value.isNotEmpty) {
//             // 以流方式压缩，获取到流对象
//             Uint8List stream = await FlutterImageCompress.compressWithList(
//               value,
//               minWidth: 1000,
//               minHeight: 1000,
//               quality: 80,
//             );
//
//             //传入压缩之后的流对象
//             map[key] = MultipartFile.fromBytes(stream, filename: "file_stream");
//           }
//         }
//       }
//     }
//
//     final formData = FormData.fromMap(map);
//
//     if (!AppConstant.inProduction) {
//       print('单独打印 Post 请求 FromData 参数为：fields:${formData.fields.toString()} files:${formData.files.toString()}');
//     }
//
//     return dio.post(
//       url,
//       data: formData,
//       options: Options(headers: headers),
//       onSendProgress: send,
//       onReceiveProgress: receive,
//       cancelToken: cancelToken,
//     );
//   }
//
//   /// 网络请求 Get 请求
//   Future<Response> executeGet({
//     required String url,
//     Map<String, dynamic>? params,
//     Map<String, String>? headers,
//     CacheControl? cacheControl,
//     Duration? cacheExpiration,
//     ProgressCallback? receive, // 请求进度监听
//     CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//   }) {
//     return dio.get(
//       url,
//       queryParameters: params,
//       options: Options(headers: headers),
//       onReceiveProgress: receive,
//       cancelToken: cancelToken,
//     );
//   }
//
//   /// Dio 网络下载
//   Future<void> downloadFile({
//     required String url,
//     required String savePath,
//     ProgressCallback? receive, // 下载进度监听
//     CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
//     void Function(bool success, String path)? callback, // 下载完成回调函数
//   }) async {
//     try {
//       await dio.download(
//         url,
//         savePath,
//         onReceiveProgress: receive,
//         cancelToken: cancelToken,
//       );
//       // 下载成功
//       callback?.call(true, savePath);
//     } on DioException catch (e) {
//       Log.e("DioException：$e");
//       // 下载失败
//       callback?.call(false, savePath);
//     }
//   }
// }
