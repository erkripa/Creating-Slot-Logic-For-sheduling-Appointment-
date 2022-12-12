import 'package:intl/intl.dart';
import 'dart:developer';
import 'dart:math';

void main() {
  DateTime now = DateTime.now();
  DateTime startTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
  DateTime endTime = DateTime(
      now.year, now.month, Duration(days: now.day + 1).inDays, 17, 0, 0);

  int difffTime = endTime.difference(startTime).inHours;
  print(difffTime / 24);
  Duration step = Duration(minutes: 30);

  List<DateTime> dates = getDaysInBetween(startTime, endTime);
  print(dates);

  List<String> timeSlots = [];

  while (startTime.hour < endTime.hour) {
    DateTime timeIncrement = startTime.add(step);
    timeSlots.add(DateFormat.Hm().format(timeIncrement));
    startTime = timeIncrement;
  }

//   print(timeSlots.toString());

  Map<String, dynamic> data = {
    "data": List.generate(
      dates.length,
      (index) => {
        "id": Random().nextInt(100).toString(),
        "date": dates[index].toIso8601String(),
        "slots": List.generate(
          timeSlots.length,
          (index) => {
            "slot_id": Random().nextInt(1000).toString(),
            "time": timeSlots[index].toString(),
            "price": Random().nextInt(100).toString(),
          },
        ),
      },
    ),
  };

//   print(data);
  final model = DateTimeSlotModel.fromJson(data);
  print(model.toJson());
  
  
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}

class DateTimeSlotModel {
  DateTimeSlotModel({
    this.data,
  });

  List<DateTimeSlot>? data;

  factory DateTimeSlotModel.fromJson(Map<String, dynamic> json) =>
      DateTimeSlotModel(
        data: List<DateTimeSlot>.from(
            json["data"].map((x) => DateTimeSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DateTimeSlot {
  DateTimeSlot({
    this.id,
    this.date,
    this.slots,
  });

  String? id;
  DateTime? date;
  List<TimeSlot>? slots;

  factory DateTimeSlot.fromJson(Map<String, dynamic> json) => DateTimeSlot(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        slots:
            List<TimeSlot>.from(json["slots"].map((x) => TimeSlot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date": date!.toIso8601String(),
        "slots": List<dynamic>.from(slots!.map((x) => x.toJson())),
      };
}

class TimeSlot {
  TimeSlot({this.time, this.slotId, this.price});

  String? slotId;
  String? time;
  String? price;

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
        time:  json["time"].toString(),
        slotId: json["slot_id"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "time": time,
        "slot_id": slotId,
        "price": price,
      };
}
