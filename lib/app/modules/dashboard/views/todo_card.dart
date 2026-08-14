import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import '../../todo/controllers/todo_controller.dart';

class DashboardTodoCard extends StatelessWidget {
  const DashboardTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>();

    return Obx(() {
      final today = DateTime.now();

      final todos = todoController.todos
          .where((todo) {
            final date = DateTime.tryParse(todo['date']?.toString() ?? '');

            return date != null &&
                date.year == today.year &&
                date.month == today.month &&
                date.day == today.day &&
                todo['is_complete'] != true;
          })
          .take(3)
          .toList();

      return _panel(
        title: "Today's To Do",
        action: 'View All',
        child: todos.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'No pending tasks for today',
                    style: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  for (int i = 0; i < todos.length; i++)
                    _todoItem(todoController: todoController, todo: todos[i]),
                ],
              ),
      );
    });
  }

  Widget _todoItem({
    required TodoController todoController,
    required Map<String, dynamic> todo,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF07182B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              final index = todoController.todos.indexOf(todo);

              if (index != -1) {
                todoController.todos[index]['is_complete'] = true;
                todoController.todos.refresh();
              }
            },
            borderRadius: BorderRadius.circular(5),
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondaryText),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              todo['text']?.toString() ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            _formatTime(todo['date']),
            style: const TextStyle(color: AppColors.cyan, fontSize: 11),
          ),
        ],
      ),
    );
  }

  String _formatTime(dynamic value) {
    final date = DateTime.tryParse(value?.toString() ?? '');

    if (date == null) return '';

    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
              TextButton(
                onPressed: () {
                  Get.toNamed(Routes.TODO);
                },
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
}
