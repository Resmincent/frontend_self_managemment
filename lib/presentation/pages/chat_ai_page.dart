import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:self_management/common/app_color.dart';
import 'package:self_management/common/info.dart';
import 'package:self_management/data/models/item_chat_model.dart';
import 'package:self_management/presentation/controllers/chat_ai_controller.dart';
import 'package:self_management/presentation/widgets/custom_input.dart';

class ChatAiPage extends StatefulWidget {
  const ChatAiPage({super.key});

  static const routeName = '/chat-ai';

  @override
  State<ChatAiPage> createState() => _ChatAiPageState();
}

class _ChatAiPageState extends State<ChatAiPage> {
  final chatAIController = Get.put(ChatAiController());
  final promptChatController = TextEditingController();
  final scrollController = ScrollController();

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCirc,
      );
    });
  }

  @override
  void initState() {
    chatAIController.setupModel();
    super.initState();
  }

  @override
  void dispose() {
    ChatAiController.delete();
    super.dispose();
  }

  sendMessage() async {
    final messageFromUser = promptChatController.text;
    if (messageFromUser == '') {
      Info.failed('Prompt must be filled');
      return;
    }

    final responseAi = await chatAIController.sendMessage(messageFromUser);

    if (responseAi == null) {
      Info.failed('AI Not Response');
    }

    promptChatController.clear();
    scrollDown();
  }

  Widget _buildHeaderAI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const ImageIcon(
              AssetImage('assets/images/arrow_left.png'),
              size: 24,
              color: AppColor.primary,
            ),
          ),
          const Text(
            'Chat AI',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const ImageIcon(
              AssetImage('assets/images/add_agenda.png'),
              size: 24,
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListChat() {
    return Obx(() {
      final list = chatAIController.list;
      return ListView.builder(
        controller: scrollController,
        itemCount: list.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final itemChat = list[index];
          return _buildItemChat(itemChat);
        },
      );
    });
  }

  Widget _buildItemChat(ItemChatModel itemChat) {
    bool fromUser = itemChat.fromUser;
    Image? image = itemChat.image;
    String? text = itemChat.text;

    final maxWidth = MediaQuery.sizeOf(context).width * 0.8;

    return Column(
      crossAxisAlignment:
          fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (image != null)
          Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: 300,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 6,
                color: AppColor.secondary,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: image,
            ),
          ),
        if (text != null)
          Container(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: fromUser ? AppColor.secondary : AppColor.colorWhite,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: fromUser
                ? Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: AppColor.textTitle,
                    ),
                  )
                : MarkdownBody(
                    data: text,
                  ),
          ),
        const Gap(20),
      ],
    );
  }

  Widget _buildInputChat() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: AppColor.colorWhite,
      ),
      child: Obx(() {
        if (chatAIController.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final xFile = chatAIController.image;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chatAIController.noImage && xFile.path.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(xFile.path),
                    fit: BoxFit.fitHeight,
                    height: 120,
                  ),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: CustomInput(
                    controller: promptChatController,
                    hintText: 'Input prompt..',
                    // suffixIcon: 'assets/images/image.png',
                    // suffixOnTap: () => chatAIController.pickImage(),
                  ),
                ),
                const Gap(16),
                FloatingActionButton(
                  onPressed: sendMessage,
                  backgroundColor: AppColor.colorWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      width: 2,
                      color: AppColor.primary,
                    ),
                  ),
                  child: const ImageIcon(
                    AssetImage('assets/images/send.png'),
                    size: 24,
                    color: AppColor.primary,
                  ),
                )
              ],
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Gap(20),
            _buildHeaderAI(),
            Expanded(
              child: _buildListChat(),
            ),
            _buildInputChat(),
          ],
        ),
      ),
    );
  }
}
