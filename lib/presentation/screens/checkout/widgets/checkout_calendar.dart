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
  String defaultTime = "13:00";

  final List<String> timeSlots = ["13:00", "15:45", "13:15", "17:35", "18:50"];

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _onTimeSelected(String time) {
    setState(() {
      defaultTime = time;
    });
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
          child: ListView.separated(
            scrollDirection: .horizontal,
            itemCount: timeSlots.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final time = timeSlots[index];
              return TimeContainer(
                time: time,
                isSelected: defaultTime == time,
                onTap: () => _onTimeSelected(time),
              );
            },
          ),
        ),
      ],
    );
  }
}
