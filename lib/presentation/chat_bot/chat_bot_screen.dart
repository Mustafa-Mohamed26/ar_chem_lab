import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_gradients.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/chat_bubble.dart';
import 'package:ar_chem_lab/presentation/widget/user_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      // FIX 2: Always add a 'time' key with a DateTime object
      _messages.add({
        "sender": "user",
        "text": _messageController.text,
        "time": DateTime.now(),
      });
      _messageController.clear();

      // Simulate AI Response after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          // Best practice: check if widget is still in tree
          setState(() {
            _messages.add({
              "sender": "bot",
              "text":
                  "That's an interesting chemistry question! Let me help you with that.",
              "time":
                  DateTime.now(), // FIX 3: Add timestamp to bot response too
            });
          });
        }
      });
    });
  }

  String _getFormattedDate(DateTime dateTime) {
    final now = DateTime.now();

    // Day Suffix Logic (1st, 2nd, 3rd, 4th...)
    String suffix = 'th';
    final day = dateTime.day;
    if (!(day >= 11 && day <= 13)) {
      switch (day % 10) {
        case 1:
          suffix = 'st';
          break;
        case 2:
          suffix = 'nd';
          break;
        case 3:
          suffix = 'rd';
          break;
      }
    }

    // Month names
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    String monthStr = months[dateTime.month - 1];

    // If the year is different from the current year, add it to the string
    if (dateTime.year != now.year) {
      return "$monthStr ${dateTime.day}$suffix, ${dateTime.year}";
    } else {
      return "$monthStr ${dateTime.day}$suffix";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.primary(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.midnightBlue, AppColors.royalBlue],
        ),
      ),
      child: Scaffold(
        body: Padding(
          padding: AppPadding.screen,
          child: Column(
            children: [
              UserHeader(
                imageUrl: AppAssets.userImage,
                title: "HEY MIKE",
                subtitle: _messages.isEmpty ? "" : "Online",
                showBackButton: true,
              ),

              // THE MECHANISM: Switch between Empty State and Chat State
              Expanded(
                child: _messages.isEmpty
                    ? _buildEmptyState()
                    : _buildChatList(),
              ),

              _buildMessageInput(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Image.asset(AppAssets.robotImage, height: 200.h),
          Text("Hello Mark", style: AppStyles.regular24whitePrimary),
          Text(
            "How can I assist you today?",
            style: AppStyles.regular24whitePrimary,
          ),
          SizedBox(height: 25.h),
          // Example of one of your feature cards
          _buildFeatureCard(
            subtitle:
                "Generate Chemical Solutions AI-powered prompt builder Create precise chemistry prompts ",
            imagePath: AppAssets.cardImage_1,
            isFullWidth: true,
          ),
          // Add more cards here following the image layout...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureCard(
                subtitle: "AI Chemistry Visualizer for chemical reactions",
                imagePath: AppAssets.cardImage_2,
              ),
              _buildFeatureCard(
                subtitle: "Reaction Analyzer Explain reaction steps ",
                imagePath: AppAssets.cardImage_3,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime dateTime) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.lowSaturationWhite,
              thickness: 2,
              endIndent: 15.w,
            ),
          ),
          Text(
            _getFormattedDate(dateTime),
            style: AppStyles.medium12whitePrimary,
          ),
          Expanded(
            child: Divider(
              color: AppColors.lowSaturationWhite,
              thickness: 2,
              indent: 15.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final currentMsg = _messages[index];
        final DateTime currentTime = currentMsg['time'] as DateTime;
        bool showDate = false;
        if (index == 0) {
          showDate = true;
        } else {
          final DateTime previousTime =
              _messages[index - 1]['time'] as DateTime;
          if (currentTime.day != previousTime.day ||
              currentTime.month != previousTime.month ||
              currentTime.year != previousTime.year) {
            showDate = true;
          }
        }
        return Column(
          children: [
            if (showDate) _buildDateDivider(currentTime),
            ChatBubble(
              text: currentMsg["text"] as String,
              isUser: currentMsg["sender"] == "user",
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      // This padding acts as the thickness of your border
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        gradient: const LinearGradient(
          colors: [
            AppColors.electricBlue,
            AppColors.skyBlue,
            AppColors.skyBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.62, 1.0],
        ),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            24.r,
          ), // Slightly smaller than parent
          color: AppColors.royalBlue, // Match your theme's dark blue
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                maxLines: 3,
                controller: _messageController,
                style: const TextStyle(color: AppColors.white),
                decoration: InputDecoration(
                  hintText: "Message Chatbot Ai...",
                  hintStyle: AppStyles.regular16WiteSecondary,
                  fillColor: AppColors.white,
                  border: InputBorder.none,
                ),
              ),
            ),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 0.5),
                  color: AppColors.lowSaturationWhite,
                ),
                child: const Icon(Icons.add, color: AppColors.white, size: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String subtitle,
    required String imagePath,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : 165.w,
      height: isFullWidth ? 135.h : 135.h,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: AppColors.lowSaturationWhite,
        border: Border.all(color: AppColors.lowSaturationWhite, width: 1),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(imagePath, width: 45.w, height: 45.h),
                Expanded(
                  child: Text(
                    subtitle,
                    style: AppStyles.regular16WiteSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
