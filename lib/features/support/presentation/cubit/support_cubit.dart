import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/features/support/data/models/support_conversation_dto.dart';
import 'package:food_user_app/features/support/domain/entities/support_conversation.dart';
import 'package:food_user_app/features/support/presentation/cubit/support_state.dart';

export 'support_state.dart';

class SupportCubit extends Cubit<SupportState> {
  SupportCubit({required Dio dio}) : _dio = dio, super(const SupportState());

  final Dio _dio;

  StreamSubscription<DatabaseEvent>? _firebaseSub;
  int? _listeningConversationId;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Loads the active support conversation from `GET /api/v1/support`.
  /// If no conversation exists, clears state and stops any Firebase listener.
  Future<void> loadInitialSupport() async {
    if (isClosed) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final response = await _dio.get<dynamic>(ApiEndpoints.supportLoad);
      final data = _extractData(response.data);

      if (data == null) {
        // No active conversation
        emit(
          const SupportState(isLoading: false, messages: [], lastMessageId: 0),
        );
        _stopFirebaseListener();
        return;
      }

      final dto = SupportConversationDto.fromJson(data);
      final conversation = dto.toEntity();
      final msgs = List<SupportChatMsg>.from(conversation.messages);
      msgs.sort((a, b) => a.id.compareTo(b.id));

      final maxId = _maxId(msgs);

      emit(
        state.copyWith(
          isLoading: false,
          conversation: conversation,
          messages: msgs,
          lastMessageId: maxId,
          clearError: true,
        ),
      );

      _startFirebaseListener(conversation.id);
    } on DioException catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(isLoading: false, errorMessage: _extractDioError(e)),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    }
  }

  /// Sends a message via `POST /api/v1/support/messages` (multipart).
  /// Instantly appends the returned message and updates [lastMessageId].
  Future<void> sendMessage({String? text, File? image}) async {
    if (isClosed) return;
    if ((text == null || text.trim().isEmpty) && image == null) return;

    emit(state.copyWith(isSending: true, clearError: true));
    try {
      final formData = FormData.fromMap({
        if (text != null && text.trim().isNotEmpty) 'body': text.trim(),
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: 'image.jpg',
          ),
      });

      final response = await _dio.post<dynamic>(
        ApiEndpoints.supportSendMessage,
        data: formData,
      );

      final responseData = response.data;
      final msgData = _extractData(responseData);
      final convData = _extractConversationFromResponse(responseData);

      // Parse the returned message
      SupportChatMsg? newMsg;
      if (msgData != null) {
        newMsg = SupportChatMsgDto.fromJson(msgData).toEntity();
      }

      // Check if a brand-new conversation was created
      int? newConvId;
      SupportConversation? updatedConv = state.conversation;
      if (convData != null) {
        final convDto = SupportConversationDto.fromJson(convData);
        newConvId = convDto.id;
        updatedConv = convDto.toEntity();
      }

      final updatedMessages = [...state.messages, ?newMsg];
      final newLastId = newMsg != null
          ? (newMsg.id > state.lastMessageId ? newMsg.id : state.lastMessageId)
          : state.lastMessageId;

      emit(
        state.copyWith(
          isSending: false,
          conversation: updatedConv,
          messages: updatedMessages,
          lastMessageId: newLastId,
          clearError: true,
        ),
      );

      // Restart Firebase listener if a new conversation was created
      if (newConvId != null && newConvId != _listeningConversationId) {
        _startFirebaseListener(newConvId);
      } else if (updatedConv != null && _listeningConversationId == null) {
        _startFirebaseListener(updatedConv.id);
      }
    } on DioException catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(isSending: false, errorMessage: _extractDioError(e)),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isSending: false, errorMessage: e.toString()));
      }
    }
  }

  /// Fetches messages newer than [afterId] from `GET /api/v1/support/messages?after_id=`.
  Future<void> fetchNewMessages(int afterId) async {
    if (isClosed) return;
    try {
      final response = await _dio.get<dynamic>(
        ApiEndpoints.supportMessagesAfter(afterId),
      );
      final rawData = response.data;
      if (rawData == null) return;

      // The after_id endpoint may return the message list directly inside
      // response.data['data'] as a List, or wrapped under a 'messages' key.
      List<dynamic> rawList = [];
      if (rawData is Map<String, dynamic>) {
        final inner = rawData['data'];
        if (inner is List) {
          rawList = inner;
        } else if (inner is Map<String, dynamic>) {
          if (inner.containsKey('items') && inner['items'] is List) {
            rawList = inner['items'] as List<dynamic>;
          } else if (inner.containsKey('messages')) {
            if (inner['messages'] is List) {
              rawList = inner['messages'] as List<dynamic>;
            } else if (inner['messages'] is Map &&
                (inner['messages'] as Map)['items'] is List) {
              rawList = (inner['messages'] as Map)['items'] as List<dynamic>;
            }
          }
        }
      }

      final newMsgs = rawList
          .whereType<Map<String, dynamic>>()
          .map(SupportChatMsgDto.fromJson)
          .map((d) => d.toEntity())
          .where((m) => m.id > state.lastMessageId)
          .toList();

      if (newMsgs.isEmpty || isClosed) return;

      final updatedMessages = List<SupportChatMsg>.from(state.messages)
        ..addAll(newMsgs);
      updatedMessages.sort(
        (a, b) => a.id.compareTo(b.id),
      ); // strictly chronological

      final newLastId = updatedMessages.last.id;
      emit(state.copyWith(messages: updatedMessages, lastMessageId: newLastId));
    } catch (e) {
      // Silently ignore polling errors — UI is unaffected
      debugPrint('[SupportCubit] fetchNewMessages error: $e');
    }
  }

  /// Cleans up the Firebase listener. Call from screen's dispose().
  void cleanupListeners() {
    _stopFirebaseListener();
  }

  // ── Firebase RTDB "Bell" Listener ──────────────────────────────────────────

  void _startFirebaseListener(int conversationId) {
    if (_listeningConversationId == conversationId) return;
    _stopFirebaseListener();

    _listeningConversationId = conversationId;

    final String dbUrl =
        'https://lababk-10014-default-rtdb.europe-west1.firebasedatabase.app';
    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: dbUrl,
    );

    final ref = db.ref('support_realtime/conversations/$conversationId');

    _firebaseSub = ref.onValue.listen(
      (event) {
        if (isClosed) return;
        if (event.snapshot.value == null) return;

        int? remoteLastId;
        if (event.snapshot.value is Map) {
          final data = Map<String, dynamic>.from(event.snapshot.value as Map);
          remoteLastId = _parseInt(data['last_message_id']);
        } else if (event.snapshot.value is int) {
          remoteLastId = event.snapshot.value as int;
        }

        if (remoteLastId != null && remoteLastId > state.lastMessageId) {
          fetchNewMessages(state.lastMessageId);
        }
      },
      onError: (Object e) {
        debugPrint('[SupportCubit] Firebase listener error: $e');
      },
    );
  }

  void _stopFirebaseListener() {
    _firebaseSub?.cancel();
    _firebaseSub = null;
    _listeningConversationId = null;
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Extracts the `data` field from a typical API envelope.
  Map<String, dynamic>? _extractData(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data == null) return null;
      if (data is Map<String, dynamic>) return data;
    }
    return null;
  }

  /// Checks whether the response also contains a nested `conversation` key
  /// (sent when the backend implicitly creates a new conversation on first message).
  Map<String, dynamic>? _extractConversationFromResponse(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final data = raw['data'];
      if (data is Map<String, dynamic>) {
        if (data.containsKey('conversation') &&
            data['conversation'] is Map<String, dynamic>) {
          return data['conversation'] as Map<String, dynamic>;
        }
        // Some backends nest at top level
        if (data.containsKey('id') && data.containsKey('messages')) {
          return data;
        }
      }
    }
    return null;
  }

  int _maxId(List<SupportChatMsg> msgs) {
    if (msgs.isEmpty) return 0;
    return msgs.map((m) => m.id).reduce((a, b) => a > b ? a : b);
  }

  String _extractDioError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return (data['message'] as String?) ??
          (data['error'] as String?) ??
          e.message ??
          e.toString();
    }
    return e.message ?? e.toString();
  }

  @override
  Future<void> close() {
    _stopFirebaseListener();
    return super.close();
  }
}

int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  return int.tryParse(v.toString());
}
