import 'package:ai_study_manager/app/models/notice_model.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';

class NoticeSection extends StatelessWidget {
  final String title;
  final List<NoticeModel> notices;

  const NoticeSection({super.key, required this.title, required this.notices});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          
          child: Text(
            title,

            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        ...notices.map((notice) => _noticeCard(notice)),
      ],
    );
  }

  Widget _noticeCard(NoticeModel notice) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Expanded(
                child: Text(
                  notice.title,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                _formatDate(notice.createdAt),

                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            notice.description,

            style: const TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
            ),
          ),
          if (notice.imageUrls.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notice.imageUrls.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      notice.imageUrls[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.secondaryText,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          if (notice.links.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Related Links',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                ...notice.links.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        // launchUrl(Uri.parse(item.link));
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link_rounded, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.open_in_new_rounded, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
