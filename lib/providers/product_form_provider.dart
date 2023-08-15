import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Product product;
  ProductFormProvider(this.product);
  updateAvailability(bool value) {
    print(value);
    product.available = value;
    notifyListeners();
  }

  bool esValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
