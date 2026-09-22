/// Centralised API paths. Feature repositories should compose paths from this
/// file instead of scattering literal URLs throughout UI code.
abstract final class ApiEndpoints {
  static const String apiV1 = '/api/v1';
  static const String auth = '$apiV1/auth';
  static const String register = '$auth/register';
  static String verifyOtp(String id) => '$auth/verify-otp/$id';
  static const String resendOtp = '$auth/resend-otp';
  static const String campaigns = '/campaigns';
  static const String donations = '/donations';
  static const String payments = '/payments';

  static String campaignById(String campaignId) => '$campaigns/$campaignId';
  static String donationById(String donationId) => '$donations/$donationId';
  static String paymentByReference(String reference) =>
      '$payments/reference/$reference';
}
