import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/features/support/presentation/cubit/support_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late SupportCubit cubit;

  setUp(() {
    mockDio = MockDio();
    cubit = SupportCubit(dio: mockDio);
  });

  tearDown(() {
    cubit.close();
  });

  group('SupportCubit - Order ID linking logic', () {
    test('sends order_id with the first message when no prior messages exist', () async {
      // 1. Initial support returns no conversation (or empty messages)
      when(() => mockDio.get<dynamic>(ApiEndpoints.supportLoad)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportLoad),
          data: {
            'status': 200,
            'data': null,
          },
        ),
      );

      // Set orderId (as passed from order details)
      cubit.setInitialOrderId(42);
      await cubit.loadInitialSupport();

      FormData? capturedFormData;
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.supportSendMessage,
          data: any(named: 'data'),
        ),
      ).thenAnswer((invocation) async {
        capturedFormData = invocation.namedArguments[#data] as FormData;
        return Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportSendMessage),
          data: {
            'status': 200,
            'data': {
              'message': {
                'id': 1,
                'body': 'First message',
                'sender_type': 'user',
                'created_at': '2026-11-03T12:00:00Z',
              },
            },
          },
        );
      });

      // Send first message
      await cubit.sendMessage(text: 'First message');

      expect(capturedFormData, isNotNull);
      final fields = Map.fromEntries(capturedFormData!.fields);
      expect(fields['body'], 'First message');
      expect(fields['order_id'], '42');

      // Send second message in same session -> order_id MUST NOT be included
      FormData? secondFormData;
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.supportSendMessage,
          data: any(named: 'data'),
        ),
      ).thenAnswer((invocation) async {
        secondFormData = invocation.namedArguments[#data] as FormData;
        return Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportSendMessage),
          data: {
            'status': 200,
            'data': {
              'message': {
                'id': 2,
                'body': 'Second message',
                'sender_type': 'user',
                'created_at': '2026-11-03T12:01:00Z',
              },
            },
          },
        );
      });

      await cubit.sendMessage(text: 'Second message');

      expect(secondFormData, isNotNull);
      final secondFields = Map.fromEntries(secondFormData!.fields);
      expect(secondFields['body'], 'Second message');
      expect(secondFields.containsKey('order_id'), isFalse);
    });

    test('STRICTLY FORBIDS sending order_id if conversation already has prior messages', () async {
      // 1. Initial support returns existing conversation with messages
      when(() => mockDio.get<dynamic>(ApiEndpoints.supportLoad)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportLoad),
          data: {
            'status': 200,
            'data': {
              'conversation': {
                'id': 10,
                'status': 'open',
              },
              'messages': {
                'items': [
                  {
                    'id': 1,
                    'body': 'Previous message from earlier',
                    'sender_type': 'user',
                    'created_at': '2026-11-02T10:00:00Z',
                  },
                ],
              },
            },
          },
        ),
      );

      // Set orderId (opened from order details, but conversation exists with prior messages)
      cubit.setInitialOrderId(42);
      await cubit.loadInitialSupport();

      expect(cubit.state.messages.length, 1);

      FormData? capturedFormData;
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.supportSendMessage,
          data: any(named: 'data'),
        ),
      ).thenAnswer((invocation) async {
        capturedFormData = invocation.namedArguments[#data] as FormData;
        return Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportSendMessage),
          data: {
            'status': 200,
            'data': {
              'message': {
                'id': 2,
                'body': 'New message on existing ticket',
                'sender_type': 'user',
                'created_at': '2026-11-03T12:00:00Z',
              },
            },
          },
        );
      });

      // Send message
      await cubit.sendMessage(text: 'New message on existing ticket');

      expect(capturedFormData, isNotNull);
      final fields = Map.fromEntries(capturedFormData!.fields);
      expect(fields['body'], 'New message on existing ticket');
      expect(fields.containsKey('order_id'), isFalse,
          reason: 'order_id must never be sent when ticket has prior messages to avoid 422');
    });

    test('does not send order_id when user opened support from non-order screen', () async {
      when(() => mockDio.get<dynamic>(ApiEndpoints.supportLoad)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportLoad),
          data: {
            'status': 200,
            'data': null,
          },
        ),
      );

      // No initial orderId
      await cubit.loadInitialSupport();

      FormData? capturedFormData;
      when(
        () => mockDio.post<dynamic>(
          ApiEndpoints.supportSendMessage,
          data: any(named: 'data'),
        ),
      ).thenAnswer((invocation) async {
        capturedFormData = invocation.namedArguments[#data] as FormData;
        return Response(
          requestOptions: RequestOptions(path: ApiEndpoints.supportSendMessage),
          data: {
            'status': 200,
            'data': {
              'message': {
                'id': 1,
                'body': 'General help question',
                'sender_type': 'user',
                'created_at': '2026-11-03T12:00:00Z',
              },
            },
          },
        );
      });

      await cubit.sendMessage(text: 'General help question');

      expect(capturedFormData, isNotNull);
      final fields = Map.fromEntries(capturedFormData!.fields);
      expect(fields['body'], 'General help question');
      expect(fields.containsKey('order_id'), isFalse);
    });
  });
}
