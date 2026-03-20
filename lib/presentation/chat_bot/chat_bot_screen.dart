import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_cubit.dart';
import 'package:ar_chem_lab/presentation/chat_bot/cubit/chat_state.dart';
import 'package:ar_chem_lab/domain/entities/ai_message.dart';
import 'package:ar_chem_lab/config/di/di.dart';
import 'package:ar_chem_lab/core/constants/app_assets.dart';
import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/core/theme/app_styles.dart';
import 'package:ar_chem_lab/presentation/widget/chat_bubble.dart';
import 'package:ar_chem_lab/presentation/widget/user_header.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_view_model.dart';
import 'package:ar_chem_lab/presentation/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ChatCubit>(),
      child: const ChatBotView(),
    );
  }
}

class ChatBotView extends StatefulWidget {
  const ChatBotView({super.key});

  @override
  State<ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<ChatBotView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(_messageController.text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
    return Scaffold(
      body: Padding(
        padding: AppPadding.screen,
        child: Column(
          children: [
            BlocBuilder<AuthViewModel, AuthState>(
              builder: (context, state) {
                String name = "...";
                if (state is AuthInitial) {
                  context.read<AuthViewModel>().getProfile();
                }
                if (state is ProfileSuccess) {
                  name = state.user.username.toUpperCase();
                } else if (state is AuthError) {
                  name = "ALCHEMIST";
                }
                return UserHeader(
                  imageUrl: AppAssets.userImage,
                  title: "HEY $name",
                  subtitle: "Online",
                  showBackButton: true,
                );
              },
            ),
    
            // THE MECHANISM: Switch between Empty State and Chat State
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  _scrollToBottom();
                },
                builder: (context, state) {
                  final messages = state.messages;
                  final isLoading = state is ChatLoading;
    
                  if (messages.isEmpty && !isLoading) {
                    return _buildEmptyState();
                  }
    
                  return Column(
                    children: [
                      Expanded(child: _buildChatList(messages)),
                      if (isLoading)
                        const ChatBubble(
                          text:
                              "", // Bubble handles widget if text is empty or we can pass a widget
                          isUser: false,
                          isThinking:
                              true, // I should update ChatBubble to support this
                        ),
                    ],
                  );
                },
              ),
            ),
    
            _buildMessageInput(),
            SizedBox(height: 20.h),
          ],
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
          SizedBox(height: 10.h),
          BlocBuilder<AuthViewModel, AuthState>(
            builder: (context, state) {
              String name = "ALCHEMIST";
              if (state is ProfileSuccess) {
                name = state.user.username.toUpperCase();
              }
              return Text("Hello $name", style: AppStyles.bold20whiteOrbitron);
            },
          ),
          Text(
            "How can i assist you today?",
            style: AppStyles.bold20whiteOrbitron,
          ),
          SizedBox(height: 15.h),
          _buildFeatureCard(
            subtitle: "Generate Chemical Solutions\nAI-powered prompt builder\nCreate precise chemistry prompts",
            imagePath: AppAssets.cardImage_1,
            isFullWidth: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFeatureCard(
                subtitle: "AI Chemistry Visualizer\nfor chemical reactions and concepts",
                imagePath: AppAssets.cardImage_2,
              ),
              _buildFeatureCard(
                subtitle: "Reaction Analyzer\nExplain reaction steps",
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
              color: AppColors.darkGray,
              thickness: 2,
              endIndent: 15.w,
            ),
          ),
          Text(
            _getFormattedDate(dateTime),
            style: AppStyles.medium14whiteInter,
          ),
          Expanded(
            child: Divider(
              color: AppColors.darkGray,
              thickness: 2,
              indent: 15.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<AiMessage> messages) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final currentMsg = messages[index];
        final DateTime currentTime = currentMsg.time;
        bool showDate = false;
        if (index == 0) {
          showDate = true;
        } else {
          final DateTime previousTime = messages[index - 1].time;
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
              text: currentMsg.text,
              isUser: currentMsg.isUser,
              onTypewriterUpdate: _scrollToBottom,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.lightBlue, width: 2),
      ),
      child: Column(
        children: [
          TextField(
            maxLines: null,
            minLines: 1,
            controller: _messageController,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: "Message Chatbot Ai....",
              hintStyle: AppStyles.regular16WiteSecondary.copyWith(
                color: AppColors.white.withValues(alpha: 0.3),
              ),
              border: InputBorder.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add, color: AppColors.white, size: 28.w),
                ),
              ),
            ],
          ),
        ],
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
      height: 140.h,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        border: Border.all(color: AppColors.lowSaturationWhite, width: 1.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 40.w, height: 40.h),
          SizedBox(height: 10.h),
          Expanded(
            child: Text(
              subtitle,
              style: AppStyles.regular12whiteInter
            ),
          ),
        ],
      ),
    );
  }
}
