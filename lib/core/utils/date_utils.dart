import 'package:intl/intl.dart';

class CustomDateUtils {
  static DateTime parseToKoreanTime(String dateTimeStr) {
    // UTC 시간을 파싱
    DateTime utcTime = DateTime.parse(dateTimeStr);
    
    // 한국 시간대 설정
    final koreaTimeZone = DateTime.now().timeZoneOffset;
    return utcTime.add(koreaTimeZone);
  }
  
  static String formatKoreanTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy-MM-dd HH:mm', 'ko_KR');
    return formatter.format(dateTime);
  }
} 