import 'package:drips_water/core/constants/app_colors.dart';
import 'package:drips_water/presentation/screens/checkout/widgets/time_container.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CheckoutCalendar extends StatefulWidget {
  const CheckoutCalendar({super.key});

  @override
  State<CheckoutCalendar> createState() => _CheckoutCalendarState();
}

class _CheckoutCalendarState extends State<CheckoutCalendar> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  String selectedTime = "13:00";
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
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          onDaySelected: _onDaySelected,
          focusedDay: today,
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime(2030, 10, 16),
        ),
        const SizedBox(height: 20),
        Text("Time", style: textTheme.bodyMedium?.copyWith(fontWeight: .w700)),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const TimeContainer(time: "13:00"),
              const SizedBox(width: 10),
              const TimeContainer(time: "15:45"),
              const SizedBox(width: 10),
              const TimeContainer(time: "13:15"),
              const SizedBox(width: 10),
              const TimeContainer(time: "17:35"),
              const SizedBox(width: 10),
              const TimeContainer(time: "18:50"),
            ],
          ),
        ),
      ],
    );
  }
}
