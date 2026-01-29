import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/constant.dart' as AppConstant;

class PaymentRepo {
  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((double.parse(amount) * 100).round()).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var secretKey = AppConstant.stripeSecretKey;
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // ✅ return Map
      } else {
        debugPrint("Stripe Error: ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error in createPaymentIntent: ${e.toString()}");
      return null; // ✅ Safe fallback
    }
  }
}
