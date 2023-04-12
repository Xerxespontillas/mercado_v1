import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mercado_v1/addProduct.dart';
import 'package:mercado_v1/services/Product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchText = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late Future<List<Products>> _futureProduct;

  Future<void> _addProduct() async {
    String name = _nameController.text;
    String description = _descriptionController.text;
    String price = _priceController.text;
    String quantity = _quantityController.text;
    String address = _addressController.text;
    String image = _imageController.text;

    final url = Uri.parse('http://172.29.7.254:3000/api/Product');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'Name': name,
          'Description': description,
          'Price': price,
          'Quantity': quantity,
          'address': address,
          'Image': image,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
       fetchProducts();
        print('Data sent successfully');
      } else {
         final responseBody = response.body;
      print(response.statusCode);
      print(responseBody);
        print('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error2: $e');
    }
  }

  void _showAddProductCatalog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Product Name',
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Product Description',
                  ),
                ),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    hintText: 'Product Image URL',
                  ),
                ),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Product Price',
                  ),
                ),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Product Quantity',
                  ),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Product Address',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addProduct();
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _futureProduct = fetchProducts();
    _futureProduct = fetchProducts();
  _nameController.clear();
  _descriptionController.clear();
  _priceController.clear();
  _quantityController.clear();
  _addressController.clear();
  _imageController.clear();
    
  }

  Future<List<Products>> fetchProducts() async {
    final url = Uri.parse('http://172.29.7.254:3000/api/Product');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      print(response.statusCode);
      print(responseBody);
      return (jsonDecode(response.body) as List)
          .map((e) => Products.fromJson(e))
          .toList();
    } else {
      final responseBody = response.body;
      print(response.statusCode);
      print(responseBody);
      throw Exception('No products available');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText.text= value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Products>>(
              future: _futureProduct,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Products> filteredProducts = [];

                    filteredProducts = snapshot.data!
                        .where((product) => product.name.contains(_searchText.text))
                        .toList();

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ListTile(
                        leading: Text(
                          product.image,
                        ),
                        title: Text(product.name),
                        subtitle: Text(product.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _addProduct,
                              icon: Icon(Icons.add),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Add functionality to review product
                              },
                              icon: Icon(Icons.star_border),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showAddProductCatalog,
            child: Text('Add Product'),
          ),
        ],
      ),
    );
  }
}
