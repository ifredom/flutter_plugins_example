class MyUtils {
//转化年龄工具类

  ///输入格式1999-01-31
  static int birthdayToAge(String dob) {
    dob = dob.replaceAll("-","");
    int selectYear = int.parse(dob.substring(0, 4));
    int selectMonth = int.parse(dob.substring(4, 6));
    int selectDay = int.parse(dob.substring(6, 8));
    DateTime now = DateTime.now();
    int yearNow = now.year;
    int monthNow = now.month;
    int dayNow = now.day;
    // 用当前年减去出生年，例如2019-1-22 ，出生年日月是2011年-6-1
    //当前值是8
    int yearMinus = yearNow - selectYear;
    //当前值是-5，monthMinus大于0的情况下，证明满8周岁。等于0需要判断dayMinus，小于0的时候age-1
    int monthMinus = monthNow - selectMonth;
    //当前值是21，monthMinus大于0的情况下，配合monthMinus等于0的情况下，age等于原值。否则age等于age-1
    int dayMinus = dayNow - selectDay;
    // 先大致赋值
    int age = yearMinus;
    if (age <= 0) {
      return 0;
    }
    if (monthMinus == 0) {
      if (dayMinus <= 0) {
        age = age - 1;
      }
    } else if (monthMinus < 0) {
      age = age - 1;
    }
    return age;
  }
}
