import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  Map<String, dynamic> toMap() {
    return {"text": text, "isUser": isUser};
  }

  factory ChatMessage.fromMap(Map data) {
    return ChatMessage(text: data["text"], isUser: data["isUser"]);
  }
}

class StudyWithAiController extends GetxController {
  final TextEditingController text = TextEditingController();

  final messages = <ChatMessage>[].obs;

  late Box chatBox;

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();

    chatBox = Hive.box("chatBox");

    loadMessages();

    if (messages.isEmpty) {
      addMessage(
        ChatMessage(
          text:
              "Hello 👋\nI am your AI Study Assistant.\nHow can I help you today?",
          isUser: false,
        ),
      );
    }
  }

  // Load chat from Hive

  void loadMessages() {
    final data = chatBox.get("messages", defaultValue: []);

    messages.value = List<Map>.from(
      data,
    ).map((e) => ChatMessage.fromMap(e)).toList();
  }

  // Save chat to Hive

  void saveMessages() {
    chatBox.put("messages", messages.map((e) => e.toMap()).toList());
  }

  // Add message

  void addMessage(ChatMessage message) {
    messages.add(message);

    saveMessages();
  }

  // Send question and get AI answer

  Future<void> getResponse() async {
    final question = text.text.trim();

    if (question.isEmpty) return;

    addMessage(ChatMessage(text: question, isUser: true));
    messages.add(ChatMessage(text: "AI is Typing...", isUser: false));

    text.clear();

    isLoading = true;

    update();

    try {
      const apiUrl = "https://api.featherless.ai/v1/chat/completions";

      const apiKey = "rc_6422c36f4b8952d652fe5c44570006cdf99703438a3ab4826bc2c1a654338525";

      // Send previous conversation

      final history = messages.map((msg) {
        return {"role": msg.isUser ? "user" : "assistant", "content": msg.text};
      }).toList();

      final response = await http.post(
        Uri.parse(apiUrl),

        headers: {
          "Content-Type": "application/json",

          "Authorization": "Bearer $apiKey",
        },

        body: jsonEncode({
          "model": "Qwen/Qwen2.5-7B-Instruct",

          "messages": history,

          "temperature": 0.7,
        }),
      );
      messages.removeLast();
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final answer = data["choices"][0]["message"]["content"];
        
        addMessage(ChatMessage(text: answer, isUser: false));
      } else {
        addMessage(
          ChatMessage(text: "API Error: ${response.statusCode}", isUser: false),
        );
      }
    } catch (e) {
      messages.removeLast();
      addMessage(ChatMessage(text: "Error: $e", isUser: false));
    }

    isLoading = false;

    update();
  }

  // Delete all history

  void clearChat() {
    messages.clear();

    chatBox.delete("messages");
  }

  @override
  void onClose() {
    text.dispose();

    super.onClose();
  }
}
