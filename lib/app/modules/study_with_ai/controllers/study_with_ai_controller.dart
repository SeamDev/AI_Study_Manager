import 'package:ai_study_manager/app/utils/app_cinfig.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String? imagePath;

  ChatMessage({required this.text, required this.isUser, this.imagePath});

  Map<String, dynamic> toMap() {
    return {"text": text, "isUser": isUser, "imagePath": imagePath};
  }

  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(
      text: data["text"]?.toString() ?? "",
      isUser: data["isUser"] == true,
      imagePath: data["imagePath"]?.toString(),
    );
  }
}

class StudyWithAiController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final messages = <ChatMessage>[].obs;

  final ImagePicker _imagePicker = ImagePicker();

  final Rxn<XFile> selectedImage = Rxn<XFile>();

  final RxString isPromt = "".obs;
  String promtTXT = "";

  late Box chatBox;

  static const String chatBoxName = "chatBox";
  static const String messagesKey = "messages";
  static const String memoryKey = "studentMemory";

  late GoogleAIClient _client;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    chatBox = Hive.box(chatBoxName);

    _client = GoogleAIClient(
      config: GoogleAIConfig(
        authProvider: ApiKeyProvider(AppConfig.geminiApiKey),
      ),
    );

    loadMessages();

    if (messages.isEmpty) {
      addMessage(
        ChatMessage(
          text:
              "Hello 👋\n"
              "I am your AI Study Assistant.\n"
              "How can I help you today?",
          isUser: false,
        ),
      );
    }

    messages.listen((_) {
      scrollToBottom();
    });
  }

  void loadMessages() {
    final data = chatBox.get(messagesKey, defaultValue: <dynamic>[]);

    if (data is List) {
      messages.value = data
          .whereType<Map>()
          .map((e) => ChatMessage.fromMap(e))
          .toList();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom(animated: false);
    });
  }

  void saveMessages() {
    chatBox.put(
      messagesKey,
      messages.map((message) => message.toMap()).toList(),
    );
  }

  void addMessage(ChatMessage message) {
    messages.add(message);
    saveMessages();
    scrollToBottom();
  }

  void scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      final position = scrollController.position.maxScrollExtent;

      if (animated) {
        scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        scrollController.jumpTo(position);
      }
    });
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      selectedImage.value = image;
    } catch (e) {
      debugPrint("Image picker error: $e");

      Get.snackbar("Error", "Unable to select image.");
    }
  }

  Future<void> takePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      selectedImage.value = image;
    } catch (e) {
      debugPrint("Camera error: $e");

      Get.snackbar("Error", "Unable to take picture.");
    }
  }

  void removeSelectedImage() {
    selectedImage.value = null;
  }

  String get studentMemory {
    final value = chatBox.get(memoryKey, defaultValue: "");

    return value?.toString() ?? "";
  }

  void saveStudentMemory(String memory) {
    chatBox.put(memoryKey, memory);
  }

  String buildSystemInstruction() {
    return """
You are a personal AI Study Assistant.

Your job is to help the student:

- Understand academic topics.
- Prepare for exams.
- Solve problems.
- Learn programming.
- Revise lessons.
- Create study plans.
- Practice questions.
- Understand difficult concepts.

IMPORTANT BEHAVIOR:

1. Explain difficult concepts in simple language.

2. Use examples whenever useful.

3. For mathematics, programming, science and technical subjects,
   provide step-by-step explanations.

4. Do not unnecessarily make answers complicated.

5. If the student is confused, explain the concept differently.

6. Adapt explanations to the student's knowledge level.

7. Maintain continuity with the conversation provided.

8. Use student memory when it is relevant.

9. Never invent information about the student.

10. Never claim to remember information that is not present
    in the provided conversation or memory.

11. Focus primarily on teaching and understanding.

12. When analyzing an image, carefully inspect the image and
    explain what is relevant to the student's question.

STUDENT INFORMATION:

Name: Student
Semester: Unknown
Section: Unknown
Department: Unknown

LONG-TERM STUDENT MEMORY:

$studentMemory

STUDY PREFERENCES:

- Clear explanations
- Simple language
- Practical examples
- Step-by-step solutions
- Concise answers when possible
- Detailed explanations when necessary
""";
  }

  List<Content> buildConversationHistory() {
    const int maxMessages = 20;

    final startIndex = messages.length > maxMessages
        ? messages.length - maxMessages
        : 0;

    final recentMessages = messages.sublist(startIndex);

    final history = <Content>[];

    for (final message in recentMessages) {
      if (message.text == "AI is typing...") {
        continue;
      }

      history.add(
        Content(
          role: message.isUser ? "user" : "model",
          parts: [Part.text(message.text)],
        ),
      );
    }

    return history;
  }

  Future<Part?> createImagePart(XFile image) async {
    try {
      final bytes = await image.readAsBytes();

      if (bytes.isEmpty) {
        return null;
      }

      String mimeType = "image/jpeg";

      final name = image.name.toLowerCase();

      if (name.endsWith(".png")) {
        mimeType = "image/png";
      } else if (name.endsWith(".webp")) {
        mimeType = "image/webp";
      } else if (name.endsWith(".gif")) {
        mimeType = "image/gif";
      } else if (name.endsWith(".jpg") || name.endsWith(".jpeg")) {
        mimeType = "image/jpeg";
      }

      return Part.bytes(bytes, mimeType);
    } catch (e) {
      debugPrint("Image conversion error: $e");

      return null;
    }
  }

  Future<void> getResponse() async {
    final question = textController.text.trim();

    final image = selectedImage.value;

    if (question.isEmpty && image == null) {
      return;
    }

    if (isLoading.value) {
      return;
    }

    final displayText = question.isEmpty
        ? "Please analyze this image."
        : question;

    addMessage(
      ChatMessage(text: displayText, isUser: true, imagePath: image?.path),
    );

    textController.clear();

    selectedImage.value = null;

    messages.add(ChatMessage(text: "AI is typing...", isUser: false));

    saveMessages();

    scrollToBottom();

    isLoading.value = true;

    try {
      final history = buildConversationHistory();

      if(promtTXT.isNotEmpty) history.add(Content(role: "user", parts: [Part.text(promtTXT)]),);

      if (image != null) {
        final imagePart = await createImagePart(image);

        if (imagePart != null) {
          if (history.isNotEmpty && history.last.role == "user") {
            history.removeLast();
          }

          history.add(
            Content(role: "user", parts: [Part.text(displayText), imagePart]),
          );
        }
      }

      if (history.isEmpty || history.last.role != "user") {
        history.add(Content(role: "user", parts: [Part.text(displayText)]));
      }

      final response = await _client.models.generateContent(
        model: AppConfig.geminiModel,
        request: GenerateContentRequest(
          systemInstruction: Content(
            parts: [Part.text(buildSystemInstruction())],
          ),
          contents: history,
        ),
      );

      removeTypingMessage();

      final answer = response.text?.trim();

      if (answer == null || answer.isEmpty) {
        addMessage(
          ChatMessage(
            text: "Sorry, I couldn't generate a response.",
            isUser: false,
          ),
        );
      } else {
        addMessage(ChatMessage(text: answer, isUser: false));
      }

      final usage = response.usageMetadata;

      if (usage != null) {
        debugPrint(
          "Prompt tokens: "
          "${usage.promptTokenCount}",
        );

        debugPrint(
          "Response tokens: "
          "${usage.candidatesTokenCount}",
        );

        debugPrint(
          "Total tokens: "
          "${usage.totalTokenCount}",
        );
      }
    } on RateLimitException catch (e) {
      debugPrint("Gemini Rate Limit: $e");

      removeTypingMessage();

      addMessage(
        ChatMessage(
          text:
              "Too many requests right now. "
              "Please try again in a moment.",
          isUser: false,
        ),
      );
    } on ApiException catch (e) {
      debugPrint("Gemini API Error: $e");

      removeTypingMessage();

      addMessage(
        ChatMessage(text: "Gemini API Error:\n${e.message}", isUser: false),
      );
    } catch (e) {
      debugPrint("AI Error: $e");

      removeTypingMessage();

      addMessage(ChatMessage(text: "Something went wrong:\n$e", isUser: false));
    } finally {
      isLoading.value = false;
      isPromt.value = "";
      promtTXT = "";
      scrollToBottom();
    }
  }

  void removeTypingMessage() {
    if (messages.isNotEmpty && messages.last.text == "AI is typing...") {
      messages.removeLast();

      saveMessages();
    }
  }

  void clearChat() {
    messages.clear();

    chatBox.delete(messagesKey);

    addMessage(
      ChatMessage(
        text:
            "Hello 👋\n"
            "I am your AI Study Assistant.\n"
            "How can I help you today?",
        isUser: false,
      ),
    );

    scrollToBottom(animated: false);
  }

  void clearAllData() {
    messages.clear();

    chatBox.delete(messagesKey);

    chatBox.delete(memoryKey);

    addMessage(
      ChatMessage(
        text:
            "Hello 👋\n"
            "I am your AI Study Assistant.\n"
            "How can I help you today?",
        isUser: false,
      ),
    );
  }

  @override
  void onClose() {
    textController.dispose();

    scrollController.dispose();

    _client.close();

    super.onClose();
  }
}
