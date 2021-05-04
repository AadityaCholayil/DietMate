
String convertTo12Hr(DateTime time){
  String timeStr = '';
  String hour = '';
  String min = '';

  //for hour greater than 12
  if(time.hour>12){
    hour = (time.hour - 12).toString();

    if((int.tryParse(hour)??0)<10){
      hour = '0' + hour;
    }
  }

  //for hour less than 12
  else{
    hour = time.hour.toString();
    if((int.tryParse(hour)??0)<10){
      hour = '0' + hour;
    }
  }

  //for min smaller than 10
  min = time.minute.toString();
  if((int.tryParse(min)??0)<10){
    min = '0'+ min;
  }


  //for AM/PM
  if(time.hour>12){
    timeStr= hour +':'+ min + ' PM' ;
  }
  else{
    timeStr= hour +':'+ min + ' AM';
  }

  //for noon & night
  if((int.tryParse(hour)??0)==12){
    timeStr= hour +':'+ min + ' PM' ;
  }
  if((int.tryParse(hour)??0)==0){
    hour = '12';
    timeStr= hour +':'+ min + ' AM' ;
  }

  return timeStr;
}

String dateToString (DateTime date) {
  String day = date.day<10?'0${date.day}':'${date.day}';
  String month = date.month<10?'0${date.month}':'${date.month}';
  return '$day-$month-${date.year}';
}

DateTime stringToDate (String date) {
  int day = int.tryParse(date.substring(0,2));
  int month = int.tryParse(date.substring(3,5));
  int year = int.tryParse(date.substring(6,10));
  return DateTime(year, month, day);
}

