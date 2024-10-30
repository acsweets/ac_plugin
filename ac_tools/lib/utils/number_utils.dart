class NumberUtils {
  /// 划分数字 input[1000] display[1.000]
  static String formatWithDots(int number) {
    String numberStr = number.toString();
    RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    String formattedStr = numberStr.replaceAllMapped(regExp, (match) => '.');

    return formattedStr;
  }
}
