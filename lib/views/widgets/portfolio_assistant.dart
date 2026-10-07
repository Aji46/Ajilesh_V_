import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';

class PortfolioAssistantButton extends StatelessWidget {
  const PortfolioAssistantButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Chat with Ajilesh’s portfolio assistant',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const _PortfolioAssistantSheet(),
          ),
          child: Ink(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.accentGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ga.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PortfolioAssistantSheet extends StatefulWidget {
  const _PortfolioAssistantSheet();

  @override
  State<_PortfolioAssistantSheet> createState() =>
      _PortfolioAssistantSheetState();
}

class _PortfolioAssistantSheetState extends State<_PortfolioAssistantSheet> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          "Hi, I'm Ajilesh's portfolio assistant. Ask me about his work, skills, "
          'projects, or how to get in touch.',
      fromAssistant: true,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? suggestedQuestion]) {
    final question = (suggestedQuestion ?? _messageController.text).trim();
    if (question.isEmpty) return;

    final portfolio = context.read<PortfolioProvider>();
    setState(() {
      _messages
        ..add(_ChatMessage(text: question, fromAssistant: false))
        ..add(_ChatMessage(
          text: _answerQuestion(question, portfolio),
          fromAssistant: true,
        ));
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  String _answerQuestion(String question, PortfolioProvider portfolio) {
    final query = question.toLowerCase();

    if (_containsAny(query, ['skill', 'technology', 'tech stack', 'tools'])) {
      return portfolio.skillCategories
          .map((category) => '${category.title}: ${category.items.join(', ')}')
          .join('\n');
    }

    if (_containsAny(query, ['project', 'built', 'portfolio work', 'app'])) {
      return portfolio.projects
          .take(5)
          .map((project) => '${project.title}: ${project.description}')
          .join('\n\n');
    }

    if (_containsAny(query, ['experience', 'career', 'work history', 'job'])) {
      return portfolio.experience
          .map((item) => '${item.role} at ${item.company} (${item.duration})')
          .join('\n');
    }

    if (_containsAny(query, ['education', 'certificate', 'study', 'degree'])) {
      final education = portfolio.education.map(
        (item) =>
            '${item.qualification}, ${item.institution} (${item.duration})',
      );
      final certificates = portfolio.certificates.map(
        (item) => '${item.title}, ${item.issuer}',
      );
      return [...education, ...certificates].join('\n');
    }

    if (_containsAny(query, ['contact', 'email', 'hire', 'phone', 'reach'])) {
      final profile = portfolio.profile;
      return 'Email: ${profile.email}\nPhone: ${profile.phone}\n'
          'Use the contact section to send a project enquiry.';
    }

    final profile = portfolio.profile;
    return '${profile.name} is a ${profile.title}. ${profile.summary}\n\n'
        'You can also ask about skills, projects, experience, education, or contact details.';
  }

  bool _containsAny(String text, List<String> terms) =>
      terms.any(text.contains);

  @override
  Widget build(BuildContext context) {
    final profile = context.read<PortfolioProvider>().profile;
    final availableHeight = MediaQuery.sizeOf(context).height -
        MediaQuery.viewInsetsOf(context).bottom;
    final sheetHeight = math.min(680.0, availableHeight * 0.86);
    final suggestions = [
      'About',
      'Skills',
      'Projects',
      'Experience',
      'Contact'
    ];

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: sheetHeight,
        constraints: const BoxConstraints(maxWidth: 620),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(profile.profileImage),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${profile.name} AI',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Answers based on portfolio details',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close assistant',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (_messages.length == 1)
              SizedBox(
                height: 42,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: suggestions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) => ActionChip(
                    label: Text(suggestions[index]),
                    onPressed: () => _sendMessage(suggestions[index]),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => TweenAnimationBuilder<double>(
                  key: ValueKey(_messages[index]),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  builder: (context, progress, child) => Opacity(
                    opacity: progress,
                    child: Transform.translate(
                      offset: Offset(0, (1 - progress) * 8),
                      child: child,
                    ),
                  ),
                  child: _MessageBubble(
                    message: _messages[index],
                    avatarPath: profile.profileImage,
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Ask about Ajilesh...',
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      tooltip: 'Send message',
                      onPressed: _sendMessage,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.black,
                      ),
                      icon: const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool fromAssistant;

  const _ChatMessage({required this.text, required this.fromAssistant});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  final String avatarPath;

  const _MessageBubble({required this.message, required this.avatarPath});

  @override
  Widget build(BuildContext context) {
    final assistant = message.fromAssistant;
    return Align(
      alignment: assistant ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (assistant) ...[
              CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage(avatarPath),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Align(
                alignment:
                    assistant ? Alignment.centerLeft : Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: math.min(
                      MediaQuery.sizeOf(context).width * 0.68,
                      460,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: assistant
                          ? AppColors.surfaceLight
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: assistant ? AppColors.textPrimary : Colors.white,
                        height: 1.45,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
