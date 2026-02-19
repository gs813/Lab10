import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductApiService {
  static const String _baseUrl =
      'https://fakestoreapi.com/products';

  Future<List<ProductModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map((e) => ProductModel.fromJson(e))
          .toList();
    }

    throw Exception('Failed to load products');
  }
}
