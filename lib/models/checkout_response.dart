class CheckoutResult {
  final bool success;
  final String reference;
  final String message;
  final bool verified;

  CheckoutResult({
    required this.success,
    required this.reference,
    required this.message,
    required this.verified,
  });

  factory CheckoutResult.fromPaystackResponse(dynamic response) {
    return CheckoutResult(
      success: response.status,
      reference: response.reference ?? '',
      message: response.message ?? '',
      verified: response.verify ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'reference': reference,
    'message': message,
    'verified': verified,
  };

  @override
  String toString() =>
      'CheckoutResult(success: $success, reference: $reference, message: $message, verified: $verified)';
}
