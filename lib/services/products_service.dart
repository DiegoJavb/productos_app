// ignore_for_file: unused_local_variable, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:productos_app/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-42f6f-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  final storage = FlutterSecureStorage();

  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;

  ProductsService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(
      _baseUrl,
      'Products.json',
      {'auth': await storage.read(key: 'token' ?? '')},
    );
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
    final url = Uri.https(
      _baseUrl,
      'Products/${product.id}.json',
      {'auth': await storage.read(key: 'token' ?? '')},
    );
    final resp = await http.put(
      url,
      body: product.toRawJson(),
    );
    final decodedData = resp.body;
    /*
    Actualización del listado de productos
    */
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;
    return product.id!;
  }

  //Crear un producto
  Future<String> createProduct(Product product) async {
    final url = Uri.https(
      _baseUrl,
      'Products.json',
      {'auth': await storage.read(key: 'token' ?? '')},
    );
    final resp = await http.post(url, body: product.toRawJson());
    final decodedData = json.decode(resp.body);
    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile == null) return null;
    isSaving = false;
    notifyListeners();
    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/dxql1qa6j/image/upload?upload_preset=b76fhn0s',
    );
    //Creamos la petición
    final imageUploadRequest = http.MultipartRequest('POST', url);
    //Adjuntamos el file
    final file = await http.MultipartFile.fromPath(
      'file',
      newPictureFile!.path,
    );
    imageUploadRequest.files.add(file);
    //Disparamos la petición
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    newPictureFile = null;
    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
