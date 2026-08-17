import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodoController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  final RxList<Map<String, dynamic>> todos = <Map<String, dynamic>>[].obs;

  final RxBool isLoading = false.obs;

  List<Map<String, dynamic>> get pendingTodos =>
      todos.where((todo) => todo['is_complete'] != true).toList();

  List<Map<String, dynamic>> get completedTodos =>
      todos.where((todo) => todo['is_complete'] == true).toList();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  // =========================
  // GET TODOS
  // =========================

  Future<void> loadTodos() async {
    try {
      isLoading.value = true;

      final user = supabase.auth.currentUser;

      if (user == null) {
        todos.clear();
        return;
      }

      final data = await supabase
          .from('todos')
          .select()
          .eq('user_id', user.id)
          .order('date', ascending: true);

      todos.assignAll(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load todos');
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // CREATE TODo
  // =========================

  Future<void> createTodo({
    required String text,
    required DateTime date,
  }) async {
    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      await supabase.from('todos').insert({
        'user_id': user.id,
        'text': text,
        'date': date.toIso8601String(),
        'is_complete': false,
      });

      await loadTodos();

      Get.back();

      Get.snackbar('Success', 'Todo created');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create todo');
    }
  }

  // =========================
  // COMPLETE / UNCOMPLETE
  // =========================

  Future<void> toggleTodo(Map<String, dynamic> todo) async {
    try {
      final id = todo['id'];
      final current = todo['is_complete'] == true;

      await supabase
          .from('todos')
          .update({'is_complete': !current})
          .eq('id', id)
          .eq('user_id', supabase.auth.currentUser!.id);

      await loadTodos();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update todo');
    }
  }

  // =========================
  // DELETE
  // =========================

  Future<void> deleteTodo(dynamic id) async {
    try {
      await supabase
          .from('todos')
          .delete()
          .eq('id', id)
          .eq('user_id', supabase.auth.currentUser!.id);

      await loadTodos();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete todo');
    }
  }
}
