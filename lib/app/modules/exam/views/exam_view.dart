import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (!controller.isLoading.value) return _summaryCards();
                return Center(child: CircularProgressIndicator(),);
              }),
              const SizedBox(height: 14),
              _examSchedule(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _summaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final cardWidth = width >= 900
            ? (width - 42) / 4
            : width >= 600
            ? (width - 14) / 2
            : width;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            SizedBox(
              width: cardWidth,
              child: _summaryCard(
                icon: Icons.calendar_month_outlined,
                title: 'Total Exams',
                value: controller.totalExams.toString().padLeft(2, '0'),
                subtitle: 'This Semester',
                color: AppColors.blue,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _summaryCard(
                icon: Icons.calendar_today_outlined,
                title: 'Upcoming',
                value: controller.upcomingExams.toString().padLeft(2, '0'),
                subtitle: controller.nextExamText,
                color: AppColors.orange,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _summaryCard(
                icon: Icons.access_time_rounded,
                title: 'Completed',
                value: controller.completedExams.toString().padLeft(2, '0'),
                subtitle: controller.examPeriod,
                color: AppColors.green,
              ),
            ),

            SizedBox(
              width: cardWidth,
              child: _summaryCard(
                icon: Icons.menu_book_outlined,
                title: 'Subjects',
                value: controller.totalSubjects.toString().padLeft(2, '0'),
                subtitle: 'In this routine',
                color: AppColors.purple,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(.08),
              border: Border.all(color: color.withOpacity(.9), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(.18),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 27),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
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

  // ============================================================
  // EXAM SCHEDULE
  // ============================================================

  Widget _examSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_scheduleHeader(), const SizedBox(height: 1), _examTable()],
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _scheduleHeader() {
    return Container(
      width: double.infinity,
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            color: AppColors.purple,
            size: 19,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Exam Schedule',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _filterButton(),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  Widget _filterButton() {
    return PopupMenuButton<String>(
      color: AppColors.card2,

      icon: const Icon(
        Icons.filter_alt_outlined,
        color: AppColors.secondaryText,
        size: 19,
      ),

      onSelected: controller.changeFilter,

      itemBuilder: (context) {
        return controller.filters.map((filter) {
          return PopupMenuItem<String>(
            value: filter,
            child: Obx(() {
              final selected = controller.selectedFilter.value == filter;

              return Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: selected ? AppColors.blue : AppColors.secondaryText,
                  ),

                  const SizedBox(width: 10),

                  Text(filter, style: const TextStyle(color: AppColors.text)),
                ],
              );
            }),
          );
        }).toList();
      },
    );
  }

  // ============================================================
  // EXAM TABLE
  // ============================================================

  Widget _examTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border.all(color: AppColors.border),
          ),
          child: Obx(() {
            if (controller.filteredExams.isEmpty) {
              return _emptyState();
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: constraints.maxWidth,
                child: DataTable(
                  // ------------------------------------------------
                  // DEFAULT DATATABLE
                  // ------------------------------------------------
                  headingRowColor: WidgetStateProperty.all(AppColors.card2),

                  // Make rows larger
                  dataRowMinHeight: 60,
                  dataRowMaxHeight: 60,

                  // Header
                  headingRowHeight: 48,

                  // Horizontal spacing
                  horizontalMargin: 16,
                  columnSpacing: 24,

                  // Border
                  border: const TableBorder(
                    horizontalInside: BorderSide(
                      color: AppColors.border,
                      width: .7,
                    ),
                  ),

                  // ------------------------------------------------
                  // COLUMNS
                  // ------------------------------------------------
                  columns: const [
                    DataColumn(label: Text('Date')),

                    DataColumn(label: Text('Day')),

                    DataColumn(label: Text('Time')),

                    DataColumn(label: Text('Subject')),

                    DataColumn(label: Text('Code')),

                    DataColumn(label: Text('Duration')),

                    DataColumn(label: Text('Venue')),

                    DataColumn(label: Text('Status')),
                  ],

                  // ------------------------------------------------
                  // ROWS
                  // ------------------------------------------------
                  rows: controller.filteredExams.map((exam) {
                    return DataRow(
                      cells: [
                        DataCell(
                          Text(controller.formatDate(exam["exam_date"])),
                        ),

                        DataCell(Text(controller.getDay(exam['exam_date']))),

                        DataCell(
                          Text(
                            controller.getExamTime(
                              exam['start_time'],
                              exam['end_time'],
                            ),
                          ),
                        ),

                        DataCell(
                          Text(
                            exam['subject'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),

                        DataCell(Text(exam['course_code'] ?? '')),

                        DataCell(Text(exam['duration'] ?? '')),

                        DataCell(Text(exam['venue'] ?? '')),

                        DataCell(
                          _statusBadge(
                            controller.getExamStatus(exam['exam_date']),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge(String status) {
    final bool isCompleted = status == 'Completed';

    final Color color = isCompleted ? AppColors.green : AppColors.blue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _emptyState() {
    return const SizedBox(
      width: double.infinity,
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            color: AppColors.secondaryText,
            size: 35,
          ),

          SizedBox(height: 10),

          Text(
            'No exams found',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
