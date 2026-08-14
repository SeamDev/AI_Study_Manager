import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../controllers/bus_schedule_controller.dart';

class BusScheduleView extends GetView<BusScheduleController> {
  const BusScheduleView({super.key});

  static const List<Map<String, dynamic>> buses = [
    {
      'name': 'Green Line',
      'destinations': ['Campus → Court Station', 'Campus → City'],
      'startTimes': [
        '08:00 AM',
        '10:00 AM',
        '01:00 PM',
        '03:00 PM',
        '05:00 PM',
      ],
      'week': ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),

                for (final bus in buses) ...[
                  _buildBusCard(bus),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFF104D18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: AppColors.green,
              size: 30,
            ),
          ),

          const SizedBox(width: 16),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'University Bus Schedule',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 5),
                Text(
                  'View all university bus routes and departure times.',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          _todayBadge(),
        ],
      ),
    );
  }

  Widget _todayBadge() {
    final day = _dayName(DateTime.now().weekday);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF06284A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Today · $day',
        style: const TextStyle(
          color: AppColors.cyan,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildBusCard(Map<String, dynamic> bus) {
    final destinations = List<String>.from(bus['destinations'] ?? []);

    final times = List<String>.from(bus['startTimes'] ?? []);

    final week = List<String>.from(bus['week'] ?? []);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Bus information
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF104D18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.directions_bus_rounded,
                    color: AppColors.green,
                    size: 32,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bus['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 7),

                      for (final destination in destinations)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            destination,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 13,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                _buildRunningDays(week),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.border),

          // Schedule title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
            child: Row(
              children: [
                const Text(
                  'Departure Schedule',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${times.length} departures',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // Times
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final time in times) _ScheduleTimeItem(time: time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunningDays(List<String> week) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Wrap(
        spacing: 5,
        runSpacing: 5,
        alignment: WrapAlignment.end,
        children: [
          for (final day in week)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF07182A),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                day.substring(0, 3),
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _dayName(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[weekday - 1];
  }
}

/// Individual departure time
class _ScheduleTimeItem extends StatefulWidget {
  final String time;

  const _ScheduleTimeItem({required this.time});

  @override
  State<_ScheduleTimeItem> createState() => _ScheduleTimeItemState();
}

class _ScheduleTimeItemState extends State<_ScheduleTimeItem> {
  Timer? timer;

  late DateTime departure;

  @override
  void initState() {
    super.initState();

    _calculateDeparture();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _calculateDeparture() {
    final now = DateTime.now();
    final parsed = _parseTime(widget.time);

    departure = DateTime(
      now.year,
      now.month,
      now.day,
      parsed.hour,
      parsed.minute,
    );
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.trim().split(' ');
    final time = parts[0].split(':');

    int hour = int.parse(time[0]);
    final minute = int.parse(time[1]);

    final period = parts[1].toUpperCase();

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final difference = departure.difference(now);

    final passed = difference.isNegative;

    return Container(
      width: 170,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF07182A),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: passed ? AppColors.border : const Color(0xFF123C56),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: passed ? AppColors.secondaryText : AppColors.green,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.time,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: passed ? AppColors.secondaryText : Colors.white,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  passed ? 'Departed' : _remaining(difference),
                  style: TextStyle(
                    color: passed ? AppColors.secondaryText : AppColors.green,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _remaining(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return 'Leaves in ${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return 'Leaves in ${minutes}m ${seconds}s';
    }

    return 'Leaves in ${seconds}s';
  }
}
