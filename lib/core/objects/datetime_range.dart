class DateTimeRange {
  DateTime? start;
  DateTime? end;

  DateTimeRange({this.start, this.end});

  int? get diffInDays {
    if (start == null || end == null) return null;
    return end!.difference(start!).inDays;
  }
}
