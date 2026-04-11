import '../models/payment_model.dart';
import 'api_client.dart';
import 'api_config.dart';

class PaymentApiService {
  final ApiClient _client = ApiClient();

  Future<PaymentModel> createPayment(Map<String, dynamic> data) async {
    final response = await _client.post(ApiConfig.payments, body: data);
    return PaymentModel.fromJson(response);
  }

  Future<List<PaymentModel>> getPayments() async {
    final response = await _client.get(ApiConfig.payments);
    return (response as List).map((json) => PaymentModel.fromJson(json)).toList();
  }

  Future<PaymentModel> collectPayment(String id) async {
    // Driver collects the payment (CASH or QR)
    final response = await _client.patch(ApiConfig.paymentCollect(id));
    return PaymentModel.fromJson(response);
  }

  Future<PaymentModel> confirmPayment(String id) async {
    // User confirms the payment
    final response = await _client.patch(ApiConfig.paymentConfirm(id));
    return PaymentModel.fromJson(response);
  }
}
