import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-42f6f-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;

  bool isLoading = true;
  bool isSaving = false;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'Products.json');
    final resp = await http.get(url);

    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final temProduct = Product.fromJson(value);
      temProduct.id = key;
      products.add(temProduct);
    });

    isLoading = false;
    notifyListeners();
    return products;
  }

  //Metodo para guardar o crear
  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();
    // Si tengo un id significa que estoy actualizando y si no tengo significa que estoy creando
    if (product.id == null) {
      //Es necesario crear
      await createProduct(product);
    } else {
      // Actualizar
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  // Actualizar un producto
  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Products/${product.id}.json');
    final resp = await http.put(url, body: product.toRawJson());
    final decodedData = resp.body;
    //Actualización del listado de productos
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  //Crear un producto
  Future<String> createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Products.json');
    final resp = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }
}
