// /*
//  * Http的缓存策略与处理
//  */
// enum CacheControl {
//   noCache, //不使用缓存
//   onlyCache, //只用缓存
//   cacheFirstOrNetworkPut, //有缓存先用缓存，没有缓存进行网络请求再存入缓存
//   onlyNetworkPutCache, //只用网络请求，但是会存入缓存
// }
// import 'package:dio/dio.dart';
//
// import '../enum.dart';
//
// class CacheInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
//     Map<String, dynamic> headers = options.headers;
//     final String cacheControlName = headers['cache_control'] ?? "";
//
//     //只缓存
//     if (cacheControlName == CacheControl.onlyCache.name) {
//       final key = options.uri.toString();
//       //直接返回缓存
//       final json = await FileCacheManager().getJsonByKey(key);
//       if (json != null) {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取缓存成功',
//           requestOptions: RequestOptions(),
//         ));
//       } else {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取网络缓存数据失败',
//           requestOptions: RequestOptions(),
//         ));
//       }
//
//       //有缓存用缓存，没缓存用网络请求的数据并存入缓存
//     } else if (cacheControlName == CacheControl.cacheFirstOrNetworkPut.name) {
//       final key = options.uri.toString();
//       final json = await FileCacheManager().getJsonByKey(key);
//       if (json != null) {
//         handler.resolve(Response(
//           statusCode: 200,
//           data: json,
//           statusMessage: '获取缓存成功',
//           requestOptions: RequestOptions(),
//         ));
//       } else {
//         //处理数据缓存需要的请求头
//         headers['cache_key'] = key;
//         options.headers = headers;
//         //继续转发，走正常的请求
//         handler.next(options);
//       }
//
//       //用网络请求的数据并存入缓存
//     } else if (cacheControlName == CacheControl.onlyNetworkPutCache.name) {
//       final key = options.uri.toString();
//       //处理数据缓存需要的请求头
//       headers['cache_key'] = key;
//       options.headers = headers;
//       //继续转发，走正常的请求
//       handler.next(options);
//
//       //不满足条件不需要拦截
//     } else {
//       handler.next(options);
//     }
//   }
//
//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     if (response.statusCode == 200) {
//       //成功的时候设置缓存数据放入 headers 中
//       //响应体中请求体的请求头数据
//       final Map<String, dynamic> requestHeaders = response.requestOptions.headers;
//
//       if (requestHeaders['cache_control'] != null) {
//         final cacheKey = requestHeaders['cache_key'];
//         final cacheControlName = requestHeaders['cache_control'];
//         final cacheExpiration = requestHeaders['cache_expiration'];
//
//         //网络请求完成之后获取正常的Json-Map
//         Map<String, dynamic> jsonMap = response.data;
//
//         Log.d('response 中携带缓存处理逻辑 cacheControl ==== > $cacheControlName '
//             'cacheKey ==== > $cacheKey cacheExpiration ==== > $cacheExpiration');
//
//         Duration? duration;
//         if (cacheExpiration != null) {
//           duration = Duration(milliseconds: int.parse(cacheExpiration));
//         }
//
//         //直接存入Json数据到本地File
//         fileCache.putJsonByKey(
//           cacheKey ?? 'unknow',
//           jsonMap,
//           expiration: duration,
//         );
//       }
//     }
//
//     super.onResponse(response, handler);
//   }
//
//   @override
//   Future onError(DioException err, ErrorInterceptorHandler handler) async {
//     super.onError(err, handler);
//   }
// }
//
