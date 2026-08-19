import 'package:ai_study_manager/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:ai_study_manager/app/utils/ai_promt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';

class AiAssistantCard extends GetView<DashboardController> {
  const AiAssistantCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  'How can I help you with your studies today?',
                  style: TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: controller.aiTextController,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  minLines: 1,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Ask me anything about your studies...',
                    hintStyle: TextStyle(
                      color: AppColors.secondaryText,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: Color(0xFF07182A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFF122E49)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFF122E49)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Color(0xFF122E49)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
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
                GestureDetector(
                  onTap: () {
                    controller.studyWithAiController.promtTXT =
                        AiPrompt.explainThisConcept;
                    controller.studyWithAiController.isPromt.value =
                        'Explain this concept';
                    controller.aiTextController.text = "Content : ";
                  },
                  child: _aiButton('Explain this concept'),
                ),
                GestureDetector(
                  onTap: () {
                    controller.studyWithAiController.promtTXT =
                        AiPrompt.summerizeMyAssainment;
                    controller.studyWithAiController.isPromt.value =
                        'Summarize my assignments';
                    controller.aiTextController.text = "Content : ";
                  },
                  child: _aiButton('Summarize my assignments'),
                ),
                GestureDetector(
                  onTap: () {
                    controller.studyWithAiController.promtTXT =
                        AiPrompt.whatShouldIstudyToday;
                    controller.studyWithAiController.isPromt.value =
                        'What should I study today?';
                    controller.aiTextController.text = "Content : ";
                  },
                  child: _aiButton('What should I study today?'),
                ),
                GestureDetector(
                  onTap: () {
                    controller.studyWithAiController.promtTXT =
                        AiPrompt.createAstudyPlan;
                    controller.studyWithAiController.isPromt.value =
                        'Create a study plan';
                    controller.aiTextController.text = "Content : ";
                  },
                  child: _aiButton('Create a study plan'),
                ),
                GestureDetector(
                  onTap: () {
                    controller.studyWithAiController.promtTXT = AiPrompt.quizMe;
                    controller.studyWithAiController.isPromt.value = 'Quiz me';
                  },
                  child: _aiButton('Quiz me'),
                ),

                GestureDetector(
                  onTap: () {
                    controller.aiTextController.clear();
                    Get.toNamed(Routes.AI_CHAT);
                  },
                  child: _aiButton('•••'),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () {
              controller.studyWithAiController.textController.text =
                  controller.aiTextController.text;
              Get.toNamed(Routes.AI_CHAT);
              //controller.studyWithAiController.getResponse();
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------
// AI ASSISTANT
// ----------------------------------------------------------

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
      style: const TextStyle(color: Colors.white, fontSize: 14),
    ),
  );
}
