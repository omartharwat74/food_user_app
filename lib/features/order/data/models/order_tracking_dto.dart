import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:food_user_app/features/order/domain/entities/order_tracking.dart';

part 'order_tracking_dto.freezed.dart';
part 'order_tracking_dto.g.dart';

@freezed
abstract class OrderTrackingDto with _$OrderTrackingDto {
  const factory OrderTrackingDto({
    required String orderId,
    required String status,
    int? estimatedMinutes,
    String? driverName,
    String? driverPhone,
    double? driverLat,
    double? driverLng,
    double? driverRating,
    List<TimelineEntryDto>? timeline,
  }) = _OrderTrackingDto;

  factory OrderTrackingDto.fromJson(Map<String, dynamic> json) =>
      _$OrderTrackingDtoFromJson(json);
}

@freezed
abstract class TimelineEntryDto with _$TimelineEntryDto {
  const factory TimelineEntryDto({
    required String status,
    String? description,
    required DateTime timestamp,
  }) = _TimelineEntryDto;

  factory TimelineEntryDto.fromJson(Map<String, dynamic> json) =>
      _$TimelineEntryDtoFromJson(json);
}

extension OrderTrackingDtoMapper on OrderTrackingDto {
  OrderTracking toEntity() {
    return OrderTracking(
      orderId: orderId,
      status: status,
      estimatedMinutes: estimatedMinutes,
      driverName: driverName,
      driverPhone: driverPhone,
      driverLat: driverLat,
      driverLng: driverLng,
      driverRating: driverRating,
      timeline: timeline?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

extension TimelineEntryDtoMapper on TimelineEntryDto {
  TimelineEntry toEntity() {
    return TimelineEntry(
      status: status,
      description: description,
      timestamp: timestamp,
    );
  }
}
