class StringUtils {

  ///格式化url,将post和get请求以get链接输出
  static String formattedUrl(params) {
    var urlParamsStr = "";
    if (params?.isNotEmpty ?? false) {
      var tempArr = [];
      params.forEach((k, v) {
        tempArr.add(k + '=' + v.toString());
      });
      urlParamsStr = tempArr.join('&');
    }
    return urlParamsStr;
  }


  /// 划分数字 input[1000] display[1.000]
  static String formatWithDots(int number) {
    String numberStr = number.toString();
    RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    String formattedStr = numberStr.replaceAllMapped(regExp, (match) => '.');

    return formattedStr;
  }
}
