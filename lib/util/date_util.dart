
import 'log_util.dart';

class DateUtil {
  DateUtil._();

  ///日期转换为yyyy-MM-dd HH:mm:ss格式
  static String dateToStr(DateTime date) {
    return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
  }

  ///2021-10-21T08:50:55.000+00:00转换成2021-10-21 16:50:26格式
  static String dateFormat(String src) {
    String desc = '';
    if (src.isNotEmpty) {
      try {
        desc = src.split('.')[0].replaceAll('T', ' ');
      } catch (e) {
        LogUtil.e(e);
        desc = '';
      }
    }
    return desc;
  }

  ///2021-10-21T08:50:55.000+00:00转换成2021-10-21格式
  static String dateFormatYMD(String src) {
    String desc = '';
    if (src.isNotEmpty) {
      try {
        if (src.contains('T')) {
          desc = src.split('T')[0];
        } else if (src.contains(' ')) {
          desc = src.split(' ')[0];
        } else {
          desc = src;
        }
      } catch (e) {
        LogUtil.e(e);
        desc = '';
      }
    }
    return desc;
  }

  ///日期转换为yyyy-MM-dd格式
  static String dateToYMD(DateTime date) {
    return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  ///日期转换为yyyy-MM格式
  static String dateToYM(DateTime date) {
    return '${date.year.toString()}-${date.month.toString().padLeft(2, '0')}';
  }

  ///日期转换为yyyy年MM月dd日格式
  static String dateToYMDCN(DateTime date) {
    return '${date.year.toString()}年${date.month.toString().padLeft(2, '0')}月${date.day.toString().padLeft(2, '0')}日';
  }

  ///日期转换为yyyyMMdd格式
  static String dateToYMDNum(DateTime date) {
    return '${date.year.toString()}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
  }
}
