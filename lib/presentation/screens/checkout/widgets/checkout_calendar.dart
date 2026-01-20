import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/time_container.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckoutCalendar extends StatefulWidget {
  final Function(DateTime) onDateTimeChanged;
  final DateTime? initialDate;
  const CheckoutCalendar({
    super.key,
    required this.onDateTimeChanged,
    this.initialDate,
  });

  @override
  State<CheckoutCalendar> createState() => _CheckoutCalendarState();
}

class _CheckoutCalendarState extends State<CheckoutCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedTime = "13:00";

  final List<String> timeSlots = ["13:00", "15:45", "13:15", "17:35", "18:50"];

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDate ?? DateTime.now();
    if (widget.initialDate != null) {
      String hour = widget.initialDate!.hour.toString().padLeft(2, '0');
      String minute = widget.initialDate!.minute.toString().padLeft(2, '0');
      String initialTimeString = "$hour:$minute";

      if (timeSlots.contains(initialTimeString)) {
        _selectedTime = initialTimeString;
      }
    }
  }

  void _updateDateTime() {
    if (_selectedDay == null) return;

    final parts = _selectedTime.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);

    final combinedDate = DateTime(
      _selectedDay!.year,
      _selectedDay!.month,
      _selectedDay!.day,
      hour,
      minute,
    );

    widget.onDateTimeChanged(combinedDate);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Date", style: textTheme.bodyMedium?.copyWith(fontWeight: .w700)),
        TableCalendar(
          locale: "en_US",
          rowHeight: 40,
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xffE3F2FD),
              shape: .circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primary,
              shape: .circle,
            ),
            todayTextStyle: TextStyle(
              color: AppColors.primary,
              fontWeight: .bold,
            ),
            selectedTextStyle: TextStyle(
              color: AppColors.textDark,
              fontWeight: .bold,
            ),
            defaultTextStyle: TextStyle(color: AppColors.textLight),
            weekendTextStyle: TextStyle(color: AppColors.red),
            outsideTextStyle: TextStyle(color: AppColors.secondaryText),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontWeight: .bold,
              color: AppColors.textLight,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.icon),
            rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.icon),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekendStyle: TextStyle(color: AppColors.red, fontWeight: .w500),
            weekdayStyle: TextStyle(
              color: AppColors.textLight,
              fontWeight: .w500,
            ),
          ),
          availableGestures: .all,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            _updateDateTime();
          },
          focusedDay: _focusedDay,
          currentDay: DateTime.now(),
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(const Duration(days: 30)),
        ),
        const SizedBox(height: 20),
        Text("Time", style: textTheme.bodyMedium?.copyWith(fontWeight: .w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: timeSlots.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final time = timeSlots[index];
              return TimeContainer(
                time: time,
                isSelected: _selectedTime == time,
                onTap: () {
                  setState(() {
                    _selectedTime = time;
                  });
                  _updateDateTime();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
