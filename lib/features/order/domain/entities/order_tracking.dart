import 'package:equatable/equatable.dart';

class OrderTracking extends Equatable {
  final String orderId;
  final String status;
  final int? estimatedMinutes;
  final String? driverName;
  final String? driverPhone;
  final double? driverLat;
  final double? driverLng;
  final double? driverRating;
  final List<TimelineEntry> timeline;

  const OrderTracking({
    required this.orderId,
    required this.status,
    this.estimatedMinutes,
    this.driverName,
    this.driverPhone,
    this.driverLat,
    this.driverLng,
    this.driverRating,
    this.timeline = const [],
  });

  @override
  List<Object?> get props => [
    orderId,
    status,
    estimatedMinutes,
    driverName,
    driverPhone,
    driverLat,
    driverLng,
    driverRating,
    timeline,
  ];
}

class TimelineEntry extends Equatable {
  final String status;
  final String? description;
  final DateTime timestamp;

  const TimelineEntry({
    required this.status,
    this.description,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [status, description, timestamp];
}
