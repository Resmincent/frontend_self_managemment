import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:self_management/common/constans.dart';
import 'package:self_management/common/logging.dart';
import 'package:self_management/data/models/item_chat_model.dart';

import '../../common/info.dart';

class ChatAiController extends GetxController {
  late final GenerativeModel _model;
  late final ChatSession _chatSession;

  final _list = <ItemChatModel>[].obs;
  List<ItemChatModel> get list => _list;

  final _loading = false.obs;

  bool get loading => _loading.value;

  final _image = XFile('').obs;
  XFile get image => _image.value;

  bool get noImage => image.path == '';

  pickImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      // Validate that the file exists
      if (!File(pickedImage.path).existsSync()) {
        Info.failed('Image file not found');
        return;
      }

      _image.value = pickedImage;
    } catch (e) {
      fdLog.title('Chat Ai Controller - pickImage', e.toString());
      Info.failed('Failed to pick image');
    }
  }

  setupModel() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: Constans.googleAIAPIKey,
    );

    _chatSession = _model.startChat();
  }

  // In ChatAiController class
  Future<String?> sendMessage(String messageFromUser) async {
    _loading.value = true;

    try {
      // Check if image exists and is valid before proceeding
      Image? imageSelected;
      if (!noImage && File(image.path).existsSync()) {
        imageSelected = Image.file(
          File(image.path),
          fit: BoxFit.fitHeight,
        );
      }

      final itemChatUser = ItemChatModel(
        image: imageSelected,
        text: messageFromUser,
        fromUser: true,
      );
      _list.add(itemChatUser);

      late GenerateContentResponse responseAi;

      if (noImage) {
        final contentOnlyText = Content.text(messageFromUser);
        responseAi = await _chatSession.sendMessage(contentOnlyText);
      } else {
        try {
          Uint8List bytes = await image.readAsBytes();
          // Make sure mime type exists or provide a fallback
          String mimeType = image.mimeType ?? 'image/jpeg';

          final contentWithImage = [
            Content.multi(
              [
                TextPart(messageFromUser),
                DataPart(
                  mimeType,
                  bytes,
                ),
              ],
            )
          ];
          responseAi = await _model.generateContent(contentWithImage);
        } catch (imageError) {
          // If image processing fails, fall back to text-only
          fdLog.title('Chat Ai Controller - Image Processing Error',
              imageError.toString());
          final contentOnlyText = Content.text(messageFromUser);
          responseAi = await _chatSession.sendMessage(contentOnlyText);
        }
      }

      final messageFromAi = responseAi.text;
      final itemChatAi = ItemChatModel(
        image: null,
        text: messageFromAi,
        fromUser: false,
      );
      _list.add(itemChatAi);

      return messageFromAi;
    } catch (e) {
      fdLog.title('Chat Ai Controller - sendMessage', e.toString());
      // Add more user-friendly error handling here
      return null;
    } finally {
      _loading.value = false;
      // Make sure to reset the image properly
      _image.value = XFile('');
    }
  }

  static delete() {
    Get.delete<ChatAiController>(force: true);
  }
}
