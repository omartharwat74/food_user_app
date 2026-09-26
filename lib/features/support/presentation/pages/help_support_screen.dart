import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:food_user_app/core/constants/app_assets.dart';
import 'package:food_user_app/core/theme/app_colors.dart';
import 'package:food_user_app/core/theme/text_styles.dart';
import 'package:food_user_app/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/di/injection_container.dart' as di;
import 'package:food_user_app/features/support/domain/entities/support_conversation.dart';
import 'package:food_user_app/features/support/presentation/cubit/support_cubit.dart';
import 'package:food_user_app/core/widgets/app_directional_icons.dart';
import 'package:food_user_app/core/widgets/app_media.dart';

/// A thin view-model bridging [SupportChatMsg] to the existing UI widgets.
class SupportChatMessage {
  const SupportChatMessage({
    required this.id,
    required this.text,
    required this.isMine,
    required this.attachments,
    required this.createdAt,
  });

  final String id;
  final String text;
  final bool isMine;
  final List<String> attachments;
  final DateTime createdAt;

  factory SupportChatMessage.fromMsg(SupportChatMsg msg) => SupportChatMessage(
    id: msg.id.toString(),
    text: msg.body ?? '',
    isMine: msg.isMine,
    attachments: msg.attachments,
    createdAt: msg.createdAt,
  );
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SupportCubit>(),
      child: const _HelpSupportScreenContent(),
    );
  }
}

class _HelpSupportScreenContent extends StatefulWidget {
  const _HelpSupportScreenContent();

  @override
  State<_HelpSupportScreenContent> createState() =>
      _HelpSupportScreenContentState();
}

class _HelpSupportScreenContentState extends State<_HelpSupportScreenContent> {
  static const _headerContentHeight = 68.0;
  static const _composerTopPadding = 20.0;
  static const _composerHorizontalPadding = 16.0;
  static const _composerBottomPadding = 20.0;
  static const _messageHorizontalPadding = 16.0;

  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<SupportCubit>().loadInitialSupport();
    });
  }

  @override
  void dispose() {
    context.read<SupportCubit>().cleanupListeners();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty && _selectedImage == null) return;
    context.read<SupportCubit>().sendMessage(text: text, image: _selectedImage);
    _controller.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground(context),
        body: BlocConsumer<SupportCubit, SupportState>(
          listenWhen: (prev, curr) => prev != curr,
          listener: (context, state) {
            if (!mounted) return;
            // Scroll to bottom whenever new messages arrive.
            if (state.messages.isNotEmpty) _scrollToBottom();
            // Show error snackbar if needed.
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage!),
                    backgroundColor: AppColors.error,
                  ),
                );
            }
          },
          builder: (context, state) {
            final msgs = state.messages
                .map(SupportChatMessage.fromMsg)
                .toList();
            final chatWidgets = <Widget>[];
            int i = 0;
            while (i < msgs.length) {
              if (msgs[i].isMine) {
                chatWidgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ChatMessageBubble(
                      message: msgs[i],
                      text: _resolveMessageText(msgs[i]),
                    ),
                  ),
                );
                i++;
              } else {
                final group = <SupportChatMessage>[];
                while (i < msgs.length && !msgs[i].isMine) {
                  group.add(msgs[i]);
                  i++;
                }
                chatWidgets.add(
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SupportMessageGroup(
                      messages: group,
                      resolveText: _resolveMessageText,
                    ),
                  ),
                );
              }
            }

            return Column(
              children: [
                _SupportChatHeader(title: l10n.supportChatTitle),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsetsDirectional.fromSTEB(
                            _messageHorizontalPadding,
                            20,
                            _messageHorizontalPadding,
                            24,
                          ),
                          children: [
                            _DateSeparator(label: l10n.supportToday),
                            const SizedBox(height: 20),
                            ...chatWidgets,
                            // Loading indicator while sending
                            if (state.isSending)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                _SupportComposer(
                  controller: _controller,
                  onSend: state.isSending ? () {} : _sendText,
                  selectedImage: _selectedImage,
                  onPickImage: _pickImage,
                  onRemoveImage: () {
                    setState(() {
                      _selectedImage = null;
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _resolveMessageText(SupportChatMessage message) {
    final l10n = AppLocalizations.of(context)!;

    return switch (message.text) {
      'supportGoodEvening' => l10n.supportGoodEvening,
      'supportHowCanWeHelp' => l10n.supportHowCanWeHelp,
      'supportSampleUserIssue' => l10n.supportSampleUserIssue,
      final text => text,
    };
  }
}

class _SupportChatHeader extends StatelessWidget {
  const _SupportChatHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: topSafe + _HelpSupportScreenContentState._headerContentHeight,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          const Positioned.fill(child: ColoredBox(color: AppColors.primary)),
          Positioned.fill(
            child: Image.asset(AppAssets.headerPattern, fit: BoxFit.cover),
          ),
          PositionedDirectional(
            start: 16,
            end: 16,
            top: topSafe,
            bottom: 20,
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => context.pop(),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        AppDirectionalIcons.backChevron(context),
                        color: AppColors.text,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: AppTextStyles.primaryButtonLabel.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: AppTextStyles.caption(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.3,
      ),
    );
  }
}

class _SupportMessageGroup extends StatelessWidget {
  const _SupportMessageGroup({
    required this.messages,
    required this.resolveText,
  });

  final List<SupportChatMessage> messages;
  final String Function(SupportChatMessage message) resolveText;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.centerLeft,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Image.asset(
                AppAssets.supportAdminIcon,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final message in messages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: _ChatMessageBubble(
                      message: message,
                      text: resolveText(message),
                    ),
                  ),
                _MessageTime(time: _formatTime(messages.last.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  const _ChatMessageBubble({required this.message, required this.text});

  final SupportChatMessage message;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    final bubble = Column(
      crossAxisAlignment: isMine
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: isMine
                ? AppColors.border(context).withValues(alpha: 0.35)
                : AppColors.error.withValues(alpha: 0.10),
            borderRadius: _bubbleRadius(isMine),
          ),
          child: _MessageContent(message: message, text: text),
        ),
        if (isMine) ...[
          const SizedBox(height: 4),
          _MessageTime(time: _formatTime(message.createdAt)),
        ],
      ],
    );

    if (isMine) {
      return Align(
        alignment: Alignment.centerRight,
        child: Directionality(textDirection: TextDirection.ltr, child: bubble),
      );
    }

    return bubble;
  }

  BorderRadius _bubbleRadius(bool isMine) {
    if (isMine) {
      return const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      );
    }

    return const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomRight: Radius.circular(12),
    );
  }
}

class _MessageContent extends StatelessWidget {
  const _MessageContent({required this.message, required this.text});

  final SupportChatMessage message;
  final String text;

  @override
  Widget build(BuildContext context) {
    final validImageUrl = message.attachments
        .where((u) => u.trim().isNotEmpty)
        .firstOrNull;

    if (validImageUrl != null) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppNetworkImage(
                validImageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            if (text.trim().isNotEmpty) _TextMessageContent(text: text),
          ],
        ),
      );
    }
    return _TextMessageContent(text: text);
  }
}

class _TextMessageContent extends StatelessWidget {
  const _TextMessageContent({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 220),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: AppTextStyles.caption(context).copyWith(
            color: AppColors.onSurface(context),
            fontSize: 12,
            fontWeight: FontWeight.w400,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

class _MessageTime extends StatelessWidget {
  const _MessageTime({required this.time});

  final String time;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: AppTextStyles.caption(context).copyWith(
        color: AppColors.paragraph(context),
        fontSize: 8,
        fontWeight: FontWeight.w400,
        height: 1.25,
      ),
    );
  }
}

class _SupportComposer extends StatelessWidget {
  const _SupportComposer({
    required this.controller,
    required this.onSend,
    required this.selectedImage,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final File? selectedImage;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        _HelpSupportScreenContentState._composerHorizontalPadding,
        _HelpSupportScreenContentState._composerTopPadding,
        _HelpSupportScreenContentState._composerHorizontalPadding,
        bottomSafe + _HelpSupportScreenContentState._composerBottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard(context),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      selectedImage!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: onRemoveImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            textDirection: TextDirection.ltr,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.start,
                    cursorColor: AppColors.cursor(context),
                    minLines: 1,
                    maxLines: 1,
                    style: AppTextStyles.inputText(
                      context,
                    ).copyWith(fontSize: 12, height: 1.3),
                    decoration: InputDecoration(
                      hintText: l10n.supportInputHint,
                      hintStyle: AppTextStyles.inputHint(context).copyWith(
                        color: AppColors.paragraph(context),
                        fontSize: 12,
                        height: 1.3,
                      ),
                      filled: true,
                      fillColor: AppColors.surfaceCard(context),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.border(context),
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.border(context),
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.fieldFocusBorder(context),
                          width: 0.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => onSend(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _ComposerIconButton(
                onTap: onPickImage,
                child: Image.asset(AppAssets.imageAdd, width: 24, height: 24),
              ),
              const SizedBox(width: 8),
              _ComposerIconButton(
                onTap: onSend,
                child: SvgPicture.asset(
                  AppAssets.supportSendIcon,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComposerIconButton extends StatelessWidget {
  const _ComposerIconButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard(context),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border(context), width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

String _formatTime(DateTime time) {
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final suffix = time.hour >= 12 ? 'PM' : 'AM';
  return '${hour.toString().padLeft(2, '0')}:$minute$suffix';
}
