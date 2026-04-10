import 'package:equatable/equatable.dart';

class RatingModel extends Equatable {
  final String id;
  final String rideId;
  final String fromUserId;
  final String toUserId;
  final double score;
  final String? comment;
  final DateTime createdAt;

  const RatingModel({
    required this.id,
    required this.rideId,
    required this.fromUserId,
    required this.toUserId,
    required this.score,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
