import 'package:ai_study_manager/app/models/notice_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoticeController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  final RxList<NoticeModel> notices = <NoticeModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotices();
  }

  Future<void> loadNotices() async {
    try {
      isLoading.value = true;
      error.value = '';

      final data = await _supabase
          .from('notices')
          .select()
          .order('created_at', ascending: false);

      notices.assignAll(data.map((e) => NoticeModel.fromJson(e)).toList());
    } catch (e) {
      error.value = e.toString();
      print('Notice error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<NoticeModel> get today {
    final now = DateTime.now();

    return notices.where((notice) {
      final date = notice.createdAt;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  List<NoticeModel> get yesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return notices.where((notice) {
      final date = notice.createdAt;

      return date.year == yesterday.year &&
          date.month == yesterday.month &&
          date.day == yesterday.day;
    }).toList();
  }

  List<NoticeModel> get past {
    final todayStart = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    final yesterdayStart = todayStart.subtract(const Duration(days: 1));

    return notices.where((notice) {
      return notice.createdAt.isBefore(yesterdayStart);
    }).toList();
  }
}
