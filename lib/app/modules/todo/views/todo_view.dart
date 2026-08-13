import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  const TodoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TodoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
