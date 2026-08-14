import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020B1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================
              // HEADER
              // =========================
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Todos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Manage your tasks and deadlines',
                        style: TextStyle(
                          color: Color(0xFF7F94AA),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateTodoDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Todo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D9FF),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // =========================
              // TODO CONTENT
              // =========================
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _todoSection(
                          title: 'Not Completed',
                          icon: Icons.radio_button_unchecked,
                          todos: controller.pendingTodos,
                          completed: false,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: _todoSection(
                          title: 'Completed',
                          icon: Icons.check_circle_outline,
                          todos: controller.completedTodos,
                          completed: true,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // TODO SECTION
  // =========================

  Widget _todoSection({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> todos,
    required bool completed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF071525),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF17304A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF00D9FF), size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C263D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${todos.length}',
                    style: const TextStyle(
                      color: Color(0xFF8EA7BD),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFF17304A)),

          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      'No todos',
                      style: TextStyle(color: Color(0xFF64798C), fontSize: 13),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: todos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _todoItem(todos[index], completed);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // =========================
  // TODO ITEM
  // =========================

  Widget _todoItem(Map<String, dynamic> todo, bool completed) {
    final date = DateTime.tryParse(todo['date']?.toString() ?? '');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1C2E),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFF17304A)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              controller.toggleTodo(todo);
            },
            child: Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: completed
                  ? const Color(0xFF22C55E)
                  : const Color(0xFF00D9FF),
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo['text'] ?? '',
                  style: TextStyle(
                    color: completed ? const Color(0xFF718496) : Colors.white,
                    fontSize: 14,
                    decoration: completed ? TextDecoration.lineThrough : null,
                  ),
                ),

                if (date != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Color(0xFF718496),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _formatDate(date),
                        style: const TextStyle(
                          color: Color(0xFF718496),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              controller.deleteTodo(todo['id']);
            },
            icon: const Icon(
              Icons.delete_outline,
              size: 19,
              color: Color(0xFF718496),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // CREATE DIALOG
  // =========================

  void _showCreateTodoDialog(BuildContext context) {
    final textController = TextEditingController();

    DateTime selectedDate = DateTime.now();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF071525),
            title: const Text(
              'Create Todo',
              style: TextStyle(color: Colors.white),
            ),
            content: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'What do you need to do?',
                      hintStyle: const TextStyle(color: Color(0xFF718496)),
                      filled: true,
                      fillColor: const Color(0xFF0A1C2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );

                      if (date == null) return;

                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedDate),
                      );

                      if (time == null) return;

                      setState(() {
                        selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1C2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_month_outlined,
                            color: Color(0xFF00D9FF),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.trim().isEmpty) {
                    return;
                  }

                  controller.createTodo(
                    text: textController.text.trim(),
                    date: selectedDate,
                  );
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}
