class PaymentModel {
  final String id;
  final String bookingId;
  final double amount;
  final String method; // CASH or QR
  final String status; // PENDING, COLLECTED, CONFIRMED
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.bookingId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      method: json['method'] ?? 'CASH',
      status: json['status'] ?? 'PENDING',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'amount': amount,
      'method': method,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
