import 'package:flutter/foundation.dart';

class DonationController extends ChangeNotifier {
  /// Starts empty so donors deliberately choose or enter their amount.
  double amount = 0;
  String paymentMethod = 'Card';
  bool acceptedTerms = false;
  double get fee => amount * .029;
  double get total => amount + fee;
  bool get amountIsValid => amount >= 5 && amount <= 10000;
  void setAmount(double value) {
    amount = value;
    notifyListeners();
  }

  void setMethod(String value) {
    paymentMethod = value;
    notifyListeners();
  }

  void setTerms(bool value) {
    acceptedTerms = value;
    notifyListeners();
  }
}
