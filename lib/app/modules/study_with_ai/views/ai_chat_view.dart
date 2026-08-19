import 'dart:typed_data';

import 'package:ai_study_manager/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/study_with_ai_controller.dart';

class AiChatView extends GetView<StudyWithAiController> {
  const AiChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.messages.length,
                  controller: controller.scrollController,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];

                    return msg.isUser
                        ? _userMessage(msg.text)
                        : _aiMessage(msg.text);
                  },
                ),
              ),
            ),
            Obx(() {
              final image = controller.selectedImage.value;

              if (image == null) {
                return const SizedBox.shrink();
              }

              return Align(
                alignment: Alignment.centerLeft,
                child: FutureBuilder<Uint8List>(
                  future: image.readAsBytes(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox(
                        width: 80,
                        height: 80,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            snapshot.data!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 4),

                        IconButton(
                          onPressed: controller.removeSelectedImage,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),
            Obx(() {
              if (controller.isPromt.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(controller.isPromt.value),
                    ),

                    const SizedBox(width: 4),

                    IconButton(
                      onPressed: ()=> controller.isPromt.value = "",
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              );
            }),

            _inputBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

      decoration: const BoxDecoration(
        color: AppColors.card,

        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),

      child: Row(
        children: [
          Container(
            width: 45,

            height: 45,

            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              gradient: LinearGradient(
                colors: [AppColors.cyan, AppColors.purple],
              ),
            ),

            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),

          const SizedBox(width: 12),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "AI Study Assistant",

                style: TextStyle(
                  color: AppColors.text,

                  fontSize: 18,

                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "Online • Ready to help",

                style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _aiMessage(String message) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(15),

        constraints: const BoxConstraints(maxWidth: 600),

        decoration: BoxDecoration(
          color: AppColors.card,

          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: AppColors.border),
        ),

        child: Text(
          message,
          style: const TextStyle(color: AppColors.text, fontSize: 15),
        ),
      ),
    );
  }

  Widget _userMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(15),

        constraints: const BoxConstraints(maxWidth: 600),

        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.purple, Color(0xff4B1FA8)],
          ),

          borderRadius: BorderRadius.circular(16),
        ),

        child: Text(
          message,

          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _inputBox() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        color: AppColors.background,

        border: Border(top: BorderSide(color: AppColors.border)),
      ),

      child: Row(
        children: [
          IconButton(
            onPressed: controller.pickImage,
            icon: const Icon(Icons.image_outlined),
          ),

          // =============================================
          // CAMERA BUTTON
          // =============================================
          IconButton(
            onPressed: controller.takePicture,
            icon: const Icon(Icons.camera_alt_outlined),
          ),
          Expanded(
            child: TextField(
              controller: controller.textController,

              style: const TextStyle(color: AppColors.text),

              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.getResponse();
                }
              },

              textInputAction: TextInputAction.send,

              decoration: InputDecoration(
                hintText: "Ask anything about your studies...",

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

          const SizedBox(width: 12),

          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,

              gradient: LinearGradient(
                colors: [AppColors.cyan, AppColors.purple],
              ),
            ),

            child: IconButton(
              onPressed: () {
                controller.getResponse();
              },

              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
