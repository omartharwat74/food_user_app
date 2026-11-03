import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_user_app/core/constants/api_endpoints.dart';
import 'package:food_user_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:food_user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:food_user_app/features/home/domain/usecases/home_usecases.dart';
import 'package:food_user_app/features/home/presentation/cubit/home_cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late HomeRemoteDataSourceImpl remoteDataSource;
  late HomeRepositoryImpl repository;
  late GetStoresUseCase getStoresUseCase;
  late StoresCubit storesCubit;

  final sampleStoresJson = {
    'status': 200,
    'msg': 'تم جلب المتاجر بنجاح',
    'data': {
      'items': [
        {
          'id': 1,
          'section_id': 1,
          'name': 'عز الشام',
          'logo': 'https://example.com/logo.png',
          'cover': 'https://example.com/cover.png',
          'is_major': false,
          'allows_self_pickup': true,
          'prep_time_from': 25,
          'prep_time_to': 50,
          'availability': 'open',
          'offer': null,
          'rating_avg': 4.5,
          'rating_count': 10,
          'tags': [
            {'id': 1, 'name': 'برجر'}
          ],
        }
      ],
      'meta': {
        'current_page': 1,
        'last_page': 1,
        'per_page': 10,
        'total': 1,
      },
      'is_random': false,
    }
  };

  setUp(() {
    mockDio = MockDio();
    remoteDataSource = HomeRemoteDataSourceImpl(dio: mockDio);
    repository = HomeRepositoryImpl(remoteDataSource: remoteDataSource);
    getStoresUseCase = GetStoresUseCase(repository);
    storesCubit = StoresCubit(getStoresUseCase: getStoresUseCase);
  });

  tearDown(() {
    storesCubit.close();
  });

  group('HomeRemoteDataSource - Self Pickup Stores endpoint', () {
    test('calls ApiEndpoints.selfPickupStores when isSelfPickup is true and omits section_id if 4', () async {
      String? requestedPath;
      Map<String, dynamic>? requestedParams;

      when(
        () => mockDio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        requestedPath = invocation.positionalArguments[0] as String;
        requestedParams =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
        return Response(
          requestOptions: RequestOptions(path: requestedPath!),
          data: sampleStoresJson,
        );
      });

      final result = await remoteDataSource.getStores(
        sectionId: 4,
        isSelfPickup: true,
        tagIds: [1],
        fastPrep: 1,
        topRated: 1,
        hasOffers: 1,
      );

      expect(requestedPath, equals(ApiEndpoints.selfPickupStores));
      expect(requestedPath, equals('/api/v1/stores/self-pickup'));
      expect(requestedParams?['section_id'], isNull); // 4 is omitted for self-pickup
      expect(requestedParams?['tag_ids[]'], equals([1]));
      expect(requestedParams?['fast_prep'], equals(1));
      expect(requestedParams?['top_rated'], equals(1));
      expect(requestedParams?['has_offers'], equals(1));
      expect(result.items.length, equals(1));
      expect(result.items.first.name, equals('عز الشام'));
      expect(result.items.first.allowsSelfPickup, isTrue);
    });

    test('retains section_id when isSelfPickup is true and sectionId is not 4', () async {
      String? requestedPath;
      Map<String, dynamic>? requestedParams;

      when(
        () => mockDio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        requestedPath = invocation.positionalArguments[0] as String;
        requestedParams =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
        return Response(
          requestOptions: RequestOptions(path: requestedPath!),
          data: sampleStoresJson,
        );
      });

      await remoteDataSource.getStores(
        sectionId: 1,
        isSelfPickup: true,
      );

      expect(requestedPath, equals(ApiEndpoints.selfPickupStores));
      expect(requestedParams?['section_id'], equals(1));
    });

    test('calls ApiEndpoints.stores when isSelfPickup is false', () async {
      String? requestedPath;
      Map<String, dynamic>? requestedParams;

      when(
        () => mockDio.get<dynamic>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((invocation) async {
        requestedPath = invocation.positionalArguments[0] as String;
        requestedParams =
            invocation.namedArguments[#queryParameters] as Map<String, dynamic>?;
        return Response(
          requestOptions: RequestOptions(path: requestedPath!),
          data: sampleStoresJson,
        );
      });

      await remoteDataSource.getStores(
        sectionId: 1,
        isSelfPickup: false,
      );

      expect(requestedPath, equals(ApiEndpoints.stores));
      expect(requestedPath, equals('/api/v1/stores'));
      expect(requestedParams?['section_id'], equals(1));
    });
  });

  group('StoresCubit with isSelfPickup', () {
    test('fetches self-pickup stores and emits StoresLoaded', () async {
      when(
        () => mockDio.get<dynamic>(
          ApiEndpoints.selfPickupStores,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.selfPickupStores),
          data: sampleStoresJson,
        ),
      );

      await storesCubit.fetchStores(
        sectionId: 4,
        isSelfPickup: true,
      );

      expect(storesCubit.state, isA<StoresLoaded>());
      final loaded = storesCubit.state as StoresLoaded;
      expect(loaded.items.length, equals(1));
      expect(loaded.items.first.name, equals('عز الشام'));
    });
  });

  group('TagsCubit for self-pickup', () {
    test('fetches global tags when sectionId is null', () async {
      final getTagsUseCase = GetTagsUseCase(repository);
      final tagsCubit = TagsCubit(getTagsUseCase: getTagsUseCase);

      when(
        () => mockDio.get<dynamic>(
          ApiEndpoints.tags,
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiEndpoints.tags),
          data: {
            'status': 200,
            'msg': 'تم جلب التاجات بنجاح',
            'data': {
              'items': [
                {'id': 1, 'name': 'برجر', 'section_id': 1},
                {'id': 2, 'name': 'بيتزا', 'section_id': 1},
              ],
            },
          },
        ),
      );

      await tagsCubit.fetchTags(sectionId: null);

      expect(tagsCubit.state, isA<TagsLoaded>());
      final loaded = tagsCubit.state as TagsLoaded;
      expect(loaded.sectionId, isNull);
      expect(loaded.tags.length, equals(2));
      expect(loaded.tags.first.name, equals('برجر'));

      tagsCubit.close();
    });
  });
}
