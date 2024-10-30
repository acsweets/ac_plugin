// 先确定需求
// 我希望我的有哪些功能  能统一设置baseurl  容易切换请求类型 请求头
// 请求拦截器（显示请求的内容）  错误拦截器（显示错误的内容）日子拦截器（显示回来的内容）
// 易插拔，上层感知不到底层的操作，可以随时替换网络请求框架
// 请求头拦截器里添加请求头
//什么是使用者不关注的
import 'package:dio/dio.dart';

enum RequestType {
  post,
  get,
  put,
  delete,
  download,
}

class HttpManger {
  static HttpManger get instance => _instance ??= HttpManger._();
  static HttpManger? _instance;
  Duration timeout = const Duration(seconds: 30);

  // 超时时间
  //
  HttpManger._();

  late Dio _dio;

  void init(
    String baseUrl, {
    List<Interceptor>? interceptors,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? timeout,
      receiveTimeout: receiveTimeout ?? timeout,
      sendTimeout: sendTimeout ?? timeout,
    ))
      ..interceptors.addAll(interceptors ??= []);
  }

  //  Future<void> testPost() async {
  //     // 获得当前毫秒时间戳
  //     curPage = 0;
  //     var response = await Dio().post('https://mock.apifox.com/m1/4081539-3719383-default/flutter_article/testPost',
  //         data: {'page': curPage, "keyword": "${DateTime.now().millisecondsSinceEpoch}"});
  //     setState(() {
  //       testPostResponse = "${response.data}";
  //       curPage++;
  //     });
  //   }

  /// 执行GET请求
  ///
  /// [endpoint] 接口地址 例如：/api/v1/user
  /// [queryParameters] 请求参数
  /// [options] 请求配置
  /// [cancelToken] 取消请求的token

  Future<Response<T>> get<T>(String endpoint,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.get(endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }

  Future<Response<T>> post<T>(String endpoint,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) {
    return _dio.post<T>(endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken);
  }

  //
  // Future<void> downloadFile(String url, String savePath) async {
  //   Dio dio = Dio();
  //
  //   try {
  //     Response response = await dio.download(
  //       url,
  //       savePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           print("Download progress: ${(received / total * 100).toStringAsFixed(0)}%");
  //         }
  //       },
  //     );
  //     if (response.statusCode == 200) {
  //       print("File downloaded successfully to $savePath");
  //     } else {
  //       print("Failed to download file. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error occurred while downloading file: $e");
  //   }
  // }
  //
  // void main() async {
  //   String url = "https://www.example.com/file.zip";
  //   String savePath = "/path/to/save/file.zip"; // 使用系统相关的存储路径
  //
  //   await downloadFile(url, savePath);
  // }
  Future<void> downloadFile({
    ///下载的url
    required String url,

    /// 保存的路劲
    required String savePath,
    ProgressCallback? receive, // 下载进度监听
    CancelToken? cancelToken, // 用于取消的 token，可以多个请求绑定一个 token
    void Function(bool success, String path)? callback, // 下载完成回调函数
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: receive,
        cancelToken: cancelToken,
      );
      // 下载成功
      callback?.call(true, savePath);
    } on DioException catch (e) {
      print("DioException：$e");
      // 下载失败
      callback?.call(false, savePath);
    }
  }
}
