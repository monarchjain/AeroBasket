String formatTime12Hour(String time24) {
  if (time24.isEmpty) return time24;
  final parts = time24.split(':');
  if (parts.length != 2) return time24;

  final hour = int.tryParse(parts[0]);
  final minute = parts[1];
  if (hour == null) return time24;

  final period = hour >= 12 ? 'PM' : 'AM';
  int hour12 = hour % 12;
  if (hour12 == 0) hour12 = 12;

  return '$hour12:$minute $period';
}