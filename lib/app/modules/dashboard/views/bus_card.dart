import 'dart:async';
import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';

import '../../../utils/theme.dart';

class DashboardBusCard extends StatefulWidget {
  const DashboardBusCard({super.key});

  @override
  State<DashboardBusCard> createState() => _DashboardBusCardState();
}

class _DashboardBusCardState extends State<DashboardBusCard> {
  final Map<String, dynamic> bus = {
    'name': 'Green Line',
    'destinations': ['Campus → Court Station', 'Campus → City'],

    'startTimes': ['08:00 AM', '10:00 AM', '01:00 PM', '03:00 PM', '05:00 PM'],

    'week': [
      'Monday',
      'Saturday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
    ],
  };
  Timer? _timer;
  DateTime? _nextBusTime;

  @override
  void initState() {
    super.initState();

    _updateNextBus();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateNextBus(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateNextBus() {
    final now = DateTime.now();

    final week = List<String>.from(bus['week'] ?? []);

    final today = _dayName(now.weekday);

    // Bus does not run today
    if (!week.contains(today)) {
      if (mounted) {
        setState(() {
          _nextBusTime = null;
        });
      }
      return;
    }

    final startTimes = List<String>.from(bus['startTimes'] ?? []);

    DateTime? next;

    for (final time in startTimes) {
      final parsed = _parseTime(time);

      final busTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsed.hour,
        parsed.minute,
      );

      if (busTime.isAfter(now)) {
        if (next == null || busTime.isBefore(next)) {
          next = busTime;
        }
      }
    }

    if (mounted) {
      setState(() {
        _nextBusTime = next;
      });
    }
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

  String _remainingTime() {
    if (_nextBusTime == null) {
      return '';
    }

    final difference = _nextBusTime!.difference(DateTime.now());

    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    if (hours > 0) {
      return 'Leaves in ${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return 'Leaves in ${minutes}m ${seconds}s';
    }

    return 'Leaves in ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final destinations = List<String>.from(bus['destinations'] ?? []);

    return _panel(
      title: 'Next University Bus',
      action: 'View Schedule',
      child: SizedBox(
        height: 88,
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF104D18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_bus_rounded,
                color: Color(0xFF32E875),
                size: 35,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bus['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 5),

                  if (destinations.isNotEmpty)
                    Text(destinations[0], style: const TextStyle(fontSize: 13)),

                  if (destinations.length > 1) ...[
                    const SizedBox(height: 5),
                    Text(destinations[1], style: const TextStyle(fontSize: 13)),
                  ],
                ],
              ),
            ),

            Container(
              width: 145,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF07182A),
                borderRadius: BorderRadius.circular(9),
              ),
              child: _nextBusTime == null
                  ? const Center(
                      child: Text(
                        'No bus for today',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          _formatTime(_nextBusTime!),
                          style: const TextStyle(fontSize: 20),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          _remainingTime(),
                          style: const TextStyle(
                            color: Color(0xFF32E875),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}

Widget _panel({
  required String title,
  required String action,
  required Widget child,
}) {
  return Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.BUS_SCHEDULE),
              child: Text(
                action,
                style: const TextStyle(color: AppColors.cyan, fontSize: 12),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        child,
      ],
    ),
  );
}
