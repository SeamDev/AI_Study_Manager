import 'package:ai_study_manager/app/routes/app_pages.dart';
import 'package:ai_study_manager/app/utils/ai_promt.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/theme.dart';
import '../controllers/study_with_ai_controller.dart';

class StudyWithAiView extends GetView<StudyWithAiController> {
  const StudyWithAiView({super.key});

  void promtExplain() {
    controller.isPromt.value = "Explain this concept";
    controller.promtTXT = AiPrompt.explainThisConcept;
    Get.toNamed(Routes.AI_CHAT);
  }

  void promtSummerize() {
    controller.isPromt.value = "Summarize my assignments";
    controller.promtTXT = AiPrompt.summerizeMyAssainment;
    Get.toNamed(Routes.AI_CHAT);
  }

  void promtWhatShould() {
    controller.isPromt.value = "What should I study today?";
    controller.promtTXT = AiPrompt.whatShouldIstudyToday;
    Get.toNamed(Routes.AI_CHAT);
  }

  void promtStudy() {
    controller.isPromt.value = "Create a study plan";
    controller.promtTXT = AiPrompt.createAstudyPlan;
    Get.toNamed(Routes.AI_CHAT);
  }

  void promtQuiz() {
    controller.isPromt.value = "Quiz me";
    controller.promtTXT = AiPrompt.quizMe;
    Get.toNamed(Routes.AI_CHAT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _header(context),

                  const SizedBox(height: 18),

                  _popularPrompt(context),

                  const SizedBox(height: 18),

                  _studyContext(context),
                ],
              ),
            ),
          ),

          _chatBox(),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),

        gradient: const LinearGradient(
          colors: [Color(0xff061426), Color(0xff081B35)],
        ),

        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 110,

                height: 110,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  gradient: const LinearGradient(
                    colors: [AppColors.cyan, AppColors.purple],
                  ),
                ),

                child: const Icon(
                  Icons.smart_toy,

                  size: 60,

                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 25),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Your AI Study Assistant ✨",

                      style: TextStyle(
                        color: AppColors.text,

                        fontSize: 28,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Ask anything about your studies, get explanations,\nsummaries, study plans, and more.",

                      style: TextStyle(
                        color: AppColors.secondaryText,

                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 180,

                height: 100,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  gradient: LinearGradient(
                    colors: [
                      AppColors.purple.withValues(alpha: .3),

                      AppColors.blue.withValues(alpha: .3),
                    ],
                  ),
                ),

                child: const Icon(
                  Icons.computer,

                  color: AppColors.cyan,

                  size: 60,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Wrap(
            spacing: 12,

            runSpacing: 12,

            children: [
              GestureDetector(
                onTap: promtExplain,
                child: _action(
                  Icons.lightbulb,
                  "Explain Concepts",
                  AppColors.purple,
                ),
              ),

              GestureDetector(
                onTap: promtSummerize,
                child: _action(Icons.summarize, "Summarize", AppColors.cyan),
              ),

              GestureDetector(
                onTap: promtStudy,
                child: _action(
                  Icons.calendar_month,
                  "Study Plan",
                  AppColors.yellow,
                ),
              ),

              GestureDetector(
                onTap: promtQuiz,
                child: _action(Icons.quiz, "Quiz Me", AppColors.green),
              ),

              GestureDetector(
                onTap: promtWhatShould,
                child: _action(Icons.help, "What to Study?", AppColors.purple),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

      decoration: BoxDecoration(
        color: AppColors.card2,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.border),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(icon, color: color, size: 18),

          const SizedBox(width: 8),

          Text(text, style: const TextStyle(color: AppColors.text)),
        ],
      ),
    );
  }

  Widget _popularPrompt(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        const Row(
          children: [
            Icon(Icons.bolt, color: AppColors.purple),

            SizedBox(width: 8),

            Text(
              "Popular AI Prompts",

              style: TextStyle(
                color: AppColors.text,

                fontSize: 18,

                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        GridView.count(
          crossAxisCount: 5,

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          crossAxisSpacing: 14,

          mainAxisSpacing: 14,

          childAspectRatio: 1.2,

          children: [
            GestureDetector(
              onTap: promtExplain,
              child: _promptCard(
                Icons.question_mark,
                "Explain This Concept",
                "Get simple explanations for any topic.",
                AppColors.purple,
              ),
            ),

            GestureDetector(
              onTap: promtSummerize,
              child: _promptCard(
                Icons.description,
                "Summarize My Assignments",
                "Get a summary of your assignments.",
                AppColors.blue,
              ),
            ),

            GestureDetector(
              onTap: promtWhatShould,
              child: _promptCard(
                Icons.calendar_month,
                "What Should I Study Today?",
                "Get personalized recommendations.",
                AppColors.green,
              ),
            ),

            GestureDetector(
              onTap: promtStudy,
              child: _promptCard(
                Icons.track_changes,
                "Create a Study Plan",
                "Generate plan based on exams.",
                AppColors.orange,
              ),
            ),

            GestureDetector(
              onTap: promtQuiz,
              child: _promptCard(
                Icons.psychology,
                "Quiz Me",
                "Test your knowledge with AI.",
                AppColors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _promptCard(IconData icon, String title, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            AppColors.card.withValues(alpha: 0.2),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.45, 1.0],
        ),

        borderRadius: BorderRadius.circular(15),

        border: Border.all(color: color.withValues(alpha: .6)),

        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .12),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),

              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: color, size: 40),
          ),

          const SizedBox(height: 18),

          Text(
            title,

            maxLines: 2,

            style: const TextStyle(
              color: AppColors.text,

              fontWeight: FontWeight.bold,

              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            desc,

            maxLines: 3,

            style: const TextStyle(
              color: AppColors.secondaryText,

              fontSize: 12,
            ),
          ),

          const Spacer(),

          Align(
            alignment: Alignment.bottomRight,

            child: Container(
              padding: const EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: AppColors.card2,

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.arrow_forward,

                size: 25,

                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _studyContext(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: AppColors.card,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: AppColors.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Row(
            children: [
              Icon(Icons.school, color: AppColors.cyan),

              SizedBox(width: 8),

              Text(
                "Your Study Context",

                style: TextStyle(
                  color: AppColors.text,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 5,

            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            crossAxisSpacing: 12,
            childAspectRatio: 2,

            children: [
              _contextCard(
                Icons.menu_book,
                "6",
                "Subjects",
                "Subtitle",
                AppColors.blue,
              ),

              _contextCard(
                Icons.assignment,
                "4",
                "Homework",
                "Sub Title",
                AppColors.orange,
              ),

              _contextCard(
                Icons.school,
                "2",
                "Exams",
                "Sub Title",
                AppColors.purple,
              ),

              _contextCard(
                Icons.style,
                "145",
                "AI Flashcards",
                "Sub Title",
                AppColors.cyan,
              ),

              _focusCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contextCard(
    IconData icon,
    String count,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.background,
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            AppColors.card.withValues(alpha: 0.2),
            AppColors.background,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.45, 1.0],
        ),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: color.withValues(alpha: .4)),
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 40),

              const SizedBox(width: 10),

              Text(
                count,

                style: const TextStyle(
                  color: AppColors.text,

                  fontSize: 30,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            title,

            style: const TextStyle(
              color: AppColors.secondaryText,

              fontSize: 18,
            ),
          ),
          Text(
            subtitle,

            style: const TextStyle(
              color: AppColors.secondaryText,

              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _focusCard() {
    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: .08),

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: AppColors.red.withValues(alpha: .4)),
      ),

      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.timer, color: AppColors.red),

          SizedBox(height: 8),

          Text(
            "25:00",

            style: TextStyle(
              color: AppColors.text,

              fontSize: 25,

              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            "Focus Session",

            style: TextStyle(color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _chatBox() {
    return Container(
      padding: const EdgeInsets.all(12),

      decoration: const BoxDecoration(
        color: AppColors.background,

        border: Border(top: BorderSide(color: AppColors.border)),
      ),

      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.card,

            child: Icon(Icons.smart_toy, color: AppColors.cyan),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: controller.textController,
              style: const TextStyle(color: AppColors.text),
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Ask me anything about your studies...",

                hintStyle: const TextStyle(color: AppColors.secondaryText),

                filled: true,

                fillColor: AppColors.card,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),

                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: const BoxDecoration(
              color: AppColors.purple,

              shape: BoxShape.circle,
            ),

            child: IconButton(
              onPressed: () {
                Get.toNamed(Routes.AI_CHAT);
              },

              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
