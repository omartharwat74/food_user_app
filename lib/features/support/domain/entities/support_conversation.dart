/// Represents the active support conversation returned by `GET /api/v1/support`.
class SupportConversation {
  const SupportConversation({
    required this.id,
    required this.status,
    required this.messages,
  });

  final int id;
  final String status;
  final List<SupportChatMsg> messages;
}

/// A single chat message from the support conversation.
class SupportChatMsg {
  const SupportChatMsg({
    required this.id,
    required this.body,
    required this.senderType,
    required this.imageUrl,
    required this.attachments,
    required this.createdAt,
  });

  final int id;
  final String? body;
  final String senderType; // 'user' | 'admin'
  final String? imageUrl;
  final List<String> attachments;
  final DateTime createdAt;

  bool get isMine => senderType == 'user';
}
