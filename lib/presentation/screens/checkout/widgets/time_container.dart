import 'package:drips_water/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TimeContainer extends StatefulWidget {
  final String time;
  const TimeContainer({super.key, required this.time});

  @override
  State<TimeContainer> createState() => _TimeContainerState();
}

class _TimeContainerState extends State<TimeContainer> {
  String selectedTime = "13:00";
  bool get isselected => selectedTime == widget.time;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = widget.time;
        });
      },
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: .all(Radius.circular(6)),
          color: isselected ? AppColors.primary : AppColors.white,
        ),
        child: Center(
          child: Text(
            widget.time,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: isselected ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
}
