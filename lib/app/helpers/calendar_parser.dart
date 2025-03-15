
String getWeekdayName({required int weekday, bool isShort = false}) {
  var result = '???';
  switch (weekday) {
    case 1:
      result = 'Monday';
    case 2:
      result = 'Tuesday';
    case 3:
      result = 'Wednesday';
    case 4:
      result = 'Thursday';
    case 5:
      result = 'Friday';
    case 6:
      result = 'Saturday';
    case 7:
      result = 'Sunday';
  }
  
  result = isShort ? result.substring(0, 3) : result;
  
  return result;
}

String getMonthName({required int month, bool isShort = false}) {
  var result = '???';
  switch (month) {
    case 1:
      result = 'January';
    case 2:
      result = 'February';
    case 3:
      result = 'March';
    case 4:
      result = 'April';
    case 5:
      result = 'May';
    case 6:
      result = 'June';
    case 7:
      result = 'July';
    case 8:
      result = 'August';
    case 9:
      result = 'September';
    case 10:
      result = 'October';
    case 11:
      result = 'November';
    case 12:
      result = 'December';
  }

  result = isShort ? result.substring(0, 3) : result;

  return result;
}