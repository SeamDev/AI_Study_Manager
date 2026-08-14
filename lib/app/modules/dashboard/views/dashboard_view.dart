import 'package:ai_study_manager/app/modules/dashboard/views/deadline_card.dart';
import 'package:ai_study_manager/app/modules/dashboard/views/schedule_card.dart';
import 'package:ai_study_manager/app/modules/dashboard/views/summery_card.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(controller, context),

          const SizedBox(height: 18),

          // Summary cards
          SummeryCard(),

          const SizedBox(height: 16),

          // Schedule + deadlines
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: ScheduleCard()),
              const SizedBox(width: 14),
              Expanded(flex: 4, child: DeadlineCard()),
            ],
          ),

          const SizedBox(height: 16),

          // Bus + Todo + Progress
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildBusCard()),
              const SizedBox(width: 14),
              Expanded(flex: 4, child: _buildTodoCard()),
              const SizedBox(width: 14),
              SizedBox(width: 175, child: _buildProgressCard()),
            ],
          ),

          const SizedBox(height: 16),

          _buildAIAssistant(controller),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'AI responses may not always be accurate. Please verify important information.  ⓘ',
              style: TextStyle(color: Color(0xFF7C8999), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------
// TOP BAR
// ----------------------------------------------------------

Widget _buildTopBar(DashboardController controller, BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'Good morning, ${controller.fullName.value}! 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Let's make today productive.",
              style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
            ),
          ],
        ),
      ),

      const SizedBox(width: 25),

      _buildNotificationButton(context),

      const SizedBox(width: 20),

      Obx(
        () => Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan),
          ),
          child: Center(
            child: Text(
              controller.initials.value,
              style: const TextStyle(
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

// ----------------------------------------------------------
// BUS
// ----------------------------------------------------------

Widget _buildBusCard() {
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
              color: AppColors.green,
              size: 35,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Green Line',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 5),
                Text(
                  'Campus → City',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
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
            child: const Column(
              children: [
                Text('08:00 AM', style: TextStyle(fontSize: 20)),
                SizedBox(height: 3),
                Text(
                  'Leaves in 28 min',
                  style: TextStyle(color: AppColors.green, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ----------------------------------------------------------
// TODO
// ----------------------------------------------------------

Widget _buildTodoCard() {
  return _panel(
    title: "Today's To Do",
    action: 'View All',
    child: Column(
      children: [
        _todoItem('Finish DSA Assignment', '11:59 PM', AppColors.red),
        _todoItem('Review OS Lecture Notes', '5:00 PM', AppColors.yellow),
        _todoItem(
          'Read Computer Networks Chapter 3',
          '8:00 PM',
          AppColors.blue,
        ),
      ],
    ),
  );
}

Widget _todoItem(String title, String time, Color color) {
  return SizedBox(
    height: 38,
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.secondaryText),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(time, style: TextStyle(color: color, fontSize: 10)),
        ),
      ],
    ),
  );
}

// ----------------------------------------------------------
// PROGRESS
// ----------------------------------------------------------

Widget _buildProgressCard() {
  return Container(
    height: 145,
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: AppColors.border),
    ),
    child: Center(
      child: SizedBox(
        width: 105,
        height: 105,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                value: .4,
                strokeWidth: 7,
                backgroundColor: const Color(0xFF122840),
                valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('2/5', style: TextStyle(fontSize: 23)),
                Text(
                  'Completed',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ----------------------------------------------------------
// AI ASSISTANT
// ----------------------------------------------------------

Widget _buildAIAssistant(DashboardController controller) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF051426),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF102E4D)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // AI icon
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.blue, width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x554A00FF), blurRadius: 18),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF15144C),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Study Assistant',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 2),

              Obx(
                () => Text(
                  'Hi ${controller.fullName.value}! 👋',
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              const Text(
                'How can I help you with your studies today?',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 11),
              ),

              const SizedBox(height: 10),

              Container(
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF07182A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF122E49)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 13),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Ask me anything about your studies...',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          flex: 3,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _aiButton('Explain this concept'),
              _aiButton('Summarize my assignments'),
              _aiButton('What should I study today?'),
              _aiButton('Create a study plan'),
              _aiButton('Quiz me'),
              _aiButton('•••'),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF08304A),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.send_rounded,
            color: AppColors.cyan,
            size: 27,
          ),
        ),
      ],
    ),
  );
}

Widget _aiButton(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFF071C35),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: const Color(0xFF103456)),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 11),
    ),
  );
}

// ----------------------------------------------------------
// COMMON PANEL
// ----------------------------------------------------------

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
            Text(
              action,
              style: const TextStyle(color: AppColors.cyan, fontSize: 12),
            ),
          ],
        ),

        const SizedBox(height: 8),

        child,
      ],
    ),
  );
}

// ----------------------------------------------------------
// Notifiation
// ----------------------------------------------------------

Widget _buildNotificationButton(BuildContext context) {
  return PopupMenuButton(
    offset: const Offset(0, 25),
    color: Colors.transparent,
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: SizedBox(width: 330, child: _buildNotificationTab()),
        ),
      ];
    },
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_none_rounded, size: 31),

        Positioned(
          right: -3,
          top: -7,
          child: Container(
            width: 21,
            height: 21,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '3',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildNotificationTab() {
  return Container(
    width: 340,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),

            const Spacer(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '3 New',
                style: TextStyle(
                  color: AppColors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.secondaryText,
              size: 20,
            ),
          ],
        ),

        const SizedBox(height: 12),

        _notificationItem(
          icon: Icons.assignment_rounded,
          color: AppColors.orange,
          title: 'DSA Assignment Due',
          message: 'Assignment is due today at 11:59 PM.',
          time: '10 min ago',
          unread: true,
        ),

        _notificationItem(
          icon: Icons.notifications_active_rounded,
          color: AppColors.cyan,
          title: 'Class Starting Soon',
          message: 'Database Systems starts in 25 minutes.',
          time: '35 min ago',
          unread: true,
        ),

        _notificationItem(
          icon: Icons.directions_bus_rounded,
          color: AppColors.green,
          title: 'Bus Schedule Updated',
          message: 'Green Line departure time has changed.',
          time: '1 hour ago',
          unread: true,
        ),

        _notificationItem(
          icon: Icons.school_rounded,
          color: AppColors.purple,
          title: 'Exam Announcement',
          message: 'Database Midterm schedule has been posted.',
          time: '3 hours ago',
          unread: false,
        ),

        _notificationItem(
          icon: Icons.auto_awesome_rounded,
          color: AppColors.blue,
          title: 'AI Study Suggestion',
          message: 'You have a free 2-hour study slot today.',
          time: 'Yesterday',
          unread: false,
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.cyan,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: const Text(
              'View All Notifications',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _notificationItem({
  required IconData icon,
  required Color color,
  required String title,
  required String message,
  required String time,
  required bool unread,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 6),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: unread ? const Color(0xFF07182C) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: unread ? Border.all(color: AppColors.border) : null,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 19),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: unread ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),

                  if (unread)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 3),

              Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 10,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                time,
                style: const TextStyle(color: Color(0xFF718096), fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
