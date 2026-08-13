import 'package:flutter/material.dart';



// ------------------------------------------------------------
// COLORS
// ------------------------------------------------------------

class AppColors {
  static const background = Color(0xFF020B1A);
  static const sidebar = Color(0xFF020A17);
  static const card = Color(0xFF061426);
  static const card2 = Color(0xFF07182C);
  static const border = Color(0xFF102C49);

  static const blue = Color(0xFF079BFF);
  static const cyan = Color(0xFF00E5FF);
  static const purple = Color(0xFF8A2BE2);
  static const green = Color(0xFF32E875);
  static const orange = Color(0xFFFF9D00);
  static const red = Color(0xFFFF2635);
  static const yellow = Color(0xFFFFC400);

  static const text = Color(0xFFF3F7FF);
  static const secondaryText = Color(0xFFAEB9C8);
}

// ------------------------------------------------------------
// DASHBOARD
// ------------------------------------------------------------

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedMenu = 0;

  final List<String> menuItems = [
    'Dashboard',
    'Study With AI',
    'Notice',
    'Academic Routine',
    'Assessments',
    'To Do',
    'Exams',
  ];

  final List<IconData> menuIcons = [
    Icons.home_rounded,
    Icons.auto_awesome,
    Icons.campaign_rounded,
    Icons.calendar_month_rounded,
    Icons.assignment_rounded,
    Icons.check_box_rounded,
    Icons.school_rounded,
  ];

  final List<Color> menuColors = [
    AppColors.blue,
    AppColors.purple,
    AppColors.orange,
    AppColors.green,
    Colors.deepOrange,
    Colors.blue,
    AppColors.red,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth >= 900)
                SizedBox(
                  width: 305,
                  child: _buildSidebar(),
                ),

              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF030D1D),
                        Color(0xFF020A18),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: _buildMainContent(constraints),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // SIDEBAR
  // ----------------------------------------------------------

  Widget _buildSidebar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(
          right: BorderSide(
            color: Color(0xFF10253E),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.purple,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x552B00FF),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.rocket_launch_rounded,
                    size: 34,
                    color: AppColors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Study With AI',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Smart Today, Better Tomorrow',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final selected = selectedMenu == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMenu = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 65,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selected
                            ? const Color(0xFF06264B)
                            : Colors.transparent,
                        border: selected
                            ? Border.all(
                                color: const Color(0xFF0878D7),
                              )
                            : null,
                        boxShadow: selected
                            ? const [
                                BoxShadow(
                                  color: Color(0x330078FF),
                                  blurRadius: 15,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: menuColors[index].withOpacity(.95),
                            ),
                            child: Icon(
                              menuIcons[index],
                              color: Colors.white,
                              size: 27,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Text(
                              menuItems[index],
                              style: TextStyle(
                                fontSize: 18,
                                color: selected
                                    ? Colors.white
                                    : const Color(0xFFE8EDF5),
                                fontWeight: selected
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                              ),
                            ),
                          ),

                          if (index == 1)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF5A00FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // User card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF061426),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.cyan,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'SS',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOUROV SORKAR',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'sourov@example.com',
                        style: TextStyle(
                          color: AppColors.secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.secondaryText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MAIN CONTENT
  // ----------------------------------------------------------

  Widget _buildMainContent(BoxConstraints constraints) {
    final bool compact = constraints.maxWidth < 1200;

    return SingleChildScrollView(
      padding: EdgeInsets.all(
        compact ? 18 : 22,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(),

          const SizedBox(height: 18),

          // Summary cards
          if (compact)
            Column(
              children: [
                _summaryCards(),
              ],
            )
          else
            _summaryCards(),

          const SizedBox(height: 16),

          // Schedule + deadlines
          if (constraints.maxWidth < 1000)
            Column(
              children: [
                _buildScheduleCard(),
                const SizedBox(height: 16),
                _buildDeadlinesCard(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildScheduleCard(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: _buildDeadlinesCard(),
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Bus + Todo + Progress
          if (constraints.maxWidth < 1000)
            Column(
              children: [
                _buildBusCard(),
                const SizedBox(height: 16),
                _buildTodoCard(),
                const SizedBox(height: 16),
                _buildProgressCard(),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: _buildBusCard(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 4,
                  child: _buildTodoCard(),
                ),
                const SizedBox(width: 14),
                SizedBox(
                  width: 175,
                  child: _buildProgressCard(),
                ),
              ],
            ),

          const SizedBox(height: 16),

          _buildAIAssistant(),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'AI responses may not always be accurate. Please verify important information.  ⓘ',
              style: TextStyle(
                color: Color(0xFF7C8999),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TOP BAR
  // ----------------------------------------------------------

  Widget _buildTopBar() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Sourov! 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Let's make today productive.",
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 450,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF051225),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: const Color(0xFF0B2948),
            ),
          ),
          child: const Row(
            children: [
              SizedBox(width: 15),
              Icon(
                Icons.search_rounded,
                color: AppColors.secondaryText,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search anything (subjects, homework, exams, tasks...)',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '⌘ K',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              SizedBox(width: 14),
            ],
          ),
        ),

        const SizedBox(width: 25),

        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 31,
            ),
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
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 20),

        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.cyan,
            ),
          ),
          child: const Center(
            child: Text(
              'SS',
              style: TextStyle(
                color: AppColors.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // SUMMARY CARDS
  // ----------------------------------------------------------

  Widget _summaryCards() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon: Icons.menu_book_rounded,
            color: AppColors.blue,
            title: 'Classes Today',
            number: '3',
            subtitle: 'Next: 10:00 AM',
            label: 'Database Systems',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _summaryCard(
            icon: Icons.assignment_rounded,
            color: AppColors.orange,
            title: 'Homework Due',
            number: '4',
            subtitle: 'Next: Tomorrow',
            label: 'DSA Assignment',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _summaryCard(
            icon: Icons.school_rounded,
            color: AppColors.purple,
            title: 'Exams Upcoming',
            number: '2',
            subtitle: 'Next: In 5d 8h',
            label: 'Database Midterm',
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required Color color,
    required String title,
    required String number,
    required String subtitle,
    required String label,
  }) {
    return Container(
      height: 162,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(.25),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 31,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondaryText,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SCHEDULE
  // ----------------------------------------------------------

  Widget _buildScheduleCard() {
    final schedules = [
      ['08:00 AM', 'Data Structures', 'CSE 201', 'Room 402', '1h 25m'],
      ['10:00 AM', 'Database Systems', 'CSE 204', 'Lab 1', '3h 25m'],
      ['01:00 PM', 'Discrete Mathematics', 'MATH 203', 'Room 305', '6h 25m'],
      ['03:00 PM', 'Operating Systems', 'CSE 205', 'Room 401', '8h 25m'],
      ['05:00 PM', 'Computer Networks', 'CSE 206', 'Room 404', '10h 25m'],
    ];

    return _panel(
      title: "Today's Schedule",
      action: 'View Full',
      child: Column(
        children: [
          for (int i = 0; i < schedules.length; i++)
            _scheduleItem(
              time: schedules[i][0],
              title: schedules[i][1],
              code: schedules[i][2],
              room: schedules[i][3],
              starts: schedules[i][4],
              last: i == schedules.length - 1,
            ),
        ],
      ),
    );
  }

  Widget _scheduleItem({
    required String time,
    required String title,
    required String code,
    required String room,
    required String starts,
    required bool last,
  }) {
    return SizedBox(
      height: 65,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                time,
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 20,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                if (!last)
                  Positioned(
                    top: 15,
                    bottom: 0,
                    child: Container(
                      width: 1,
                      color: const Color(0xFF17405B),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.cyan,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF07182B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          code,
                          style: const TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF06284A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      room,
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontSize: 10,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  SizedBox(
                    width: 60,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Starts in',
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          starts,
                          style: const TextStyle(
                            color: AppColors.cyan,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DEADLINES
  // ----------------------------------------------------------

  Widget _buildDeadlinesCard() {
    return _panel(
      title: 'Upcoming Deadlines',
      action: 'View All',
      child: Column(
        children: [
          _deadline(
            title: 'Database Systems Midterm',
            code: 'CSE 204',
            priority: 'High',
            date: 'May 18, 2025',
            remaining: 'In 5 days',
            color: AppColors.red,
          ),
          _deadline(
            title: 'Discrete Math Midterm',
            code: 'MATH 203',
            priority: 'Medium',
            date: 'May 19, 2025',
            remaining: 'In 8 days',
            color: AppColors.yellow,
          ),
          _deadline(
            title: 'Operating Systems Assignment',
            code: 'CSE 205',
            priority: 'Medium',
            date: 'May 23, 2025',
            remaining: 'In 6 days',
            color: AppColors.blue,
          ),
          _deadline(
            title: 'Computer Networks Quiz',
            code: 'CSE 206',
            priority: 'Low',
            date: 'May 23, 2025',
            remaining: 'In 10 days',
            color: AppColors.cyan,
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '✦ Click the circle when you finish the work to remove it from the list.',
              style: TextStyle(
                color: AppColors.secondaryText,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deadline({
    required String title,
    required String code,
    required String priority,
    required String date,
    required String remaining,
    required Color color,
  }) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(bottom: 3),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: color,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondaryText,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Icon(
            Icons.calendar_month_rounded,
            color: color,
            size: 23,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  code,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              priority,
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            width: 78,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  remaining,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
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
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
                  Text(
                    '08:00 AM',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Leaves in 28 min',
                    style: TextStyle(
                      color: AppColors.green,
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

  // ----------------------------------------------------------
  // TODO
  // ----------------------------------------------------------

  Widget _buildTodoCard() {
    return _panel(
      title: "Today's To Do",
      action: 'View All',
      child: Column(
        children: [
          _todoItem(
            'Finish DSA Assignment',
            '11:59 PM',
            AppColors.red,
          ),
          _todoItem(
            'Review OS Lecture Notes',
            '5:00 PM',
            AppColors.yellow,
          ),
          _todoItem(
            'Read Computer Networks Chapter 3',
            '8:00 PM',
            AppColors.blue,
          ),
        ],
      ),
    );
  }

  Widget _todoItem(
    String title,
    String time,
    Color color,
  ) {
    return SizedBox(
      height: 38,
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.secondaryText,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: color,
                fontSize: 10,
              ),
            ),
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
        border: Border.all(
          color: AppColors.border,
        ),
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
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.cyan,
                  ),
                ),
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '2/5',
                    style: TextStyle(
                      fontSize: 23,
                    ),
                  ),
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

  Widget _buildAIAssistant() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF051426),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF102E4D),
        ),
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
              border: Border.all(
                color: AppColors.blue,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x554A00FF),
                  blurRadius: 18,
                ),
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
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'Hi Sourov! 👋',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'How can I help you with your studies today?',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF07182A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF122E49),
                    ),
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF071C35),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xFF103456),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
        ),
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
      padding: const EdgeInsets.fromLTRB(
        14,
        12,
        14,
        10,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                action,
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontSize: 12,
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
}