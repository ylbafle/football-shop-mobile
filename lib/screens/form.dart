import 'package:flutter/material.dart';
import 'package:football_shop/widgets/drawer.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:football_shop/screens/menu.dart';

class ProductForm extends StatefulWidget {
    const ProductForm({super.key});

    @override
    State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _desc = "";
  String _category = "jersey"; // default
  String _thumbnail = "";
  bool _featured = false; // default
  String _price = ""; 
  String _stock = "";

  final List<String> _categories = [
    'ball',
    'jersey',
    'keychains',
    'shoe',
    'bag',
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Add Your New Product',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Color.fromRGBO(117, 167, 24, 1),
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                // === Product Name ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "product name",
                      labelText: "Product Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    // onchanged dijalankan setiap ada perubahan isi textformfield
                    onChanged: (String? value) {
                      setState(() {
                        _name = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Product Name Can Not Be Empty!"; // return string kalau error
                      }
                      return null;
                    },
                  ),
                ),

                // === Description ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "description",
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _desc = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Description Can Not Be Empty!";
                      }
                      return null;
                    },
                  ),
                ),

                // === Price ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "price",
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // supaya ada keyboard angka
                    keyboardType: TextInputType.number, 

                    onChanged: (String? value) {
                      setState(() {
                        _price = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Price Can Not Be Empty!";
                      }
                      
                      final price = int.tryParse(value);

                      if (price == null) {
                        return "Price must be a valid number!";
                      }

                      if (price < 0) {
                        return "Price cannot be negative!";
                      }
                      
                      return null;
                    },
                  ),
                ),

                // === Stok ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "stock",
                      labelText: "Stock",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // supaya keyboard angka muncul
                    keyboardType: TextInputType.number, 

                    onChanged: (String? value) {
                      setState(() {
                        _stock = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Stock Can Not Be Empty!";
                      }
                      
                      final stok = int.tryParse(value);

                      if (stok == null) {
                        return "Stock must be a valid number!";
                      }

                      if (stok < 0) {
                        return "Stock cannot be negative!"; 
                      }
                      return null;
                    },
                  ),
                ),



                // === Category ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    value: _category,
                    items: _categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(
                                  cat[0].toUpperCase() + cat.substring(1)),
                            ))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                      });
                    },
                  ),
                ),

                // === Thumbnail URL ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "image url (optional)",
                      labelText: "Image URL",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _thumbnail = value!;
                      });
                    },
                  ),
                ),

                // === Is Featured ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text("Mark as Featured Product"),
                    value: _featured,
                    onChanged: (bool value) {
                      setState(() {
                        _featured = value;
                      });
                    },
                  ),
                ),

                // === Save ===
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color.fromRGBO(117, 167, 24, 1)),
                      ),
                      child: const Text('Save'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // TODO: Replace the URL with your app's URL
                          // To connect Android emulator with Django on localhost, use URL http://10.0.2.2/
                          // If you using chrome,  use URL http://localhost:8000
                          
                          final response = await request.postJson(
                            "http://localhost:8000/create-flutter/",
                            jsonEncode({
                              "name": _name,
                              "description": _desc,
                              "price": _price,
                              "stock": _stock,
                              "thumbnail": _thumbnail,
                              "category": _category,
                              "is_featured": _featured,
                            }),
                          );
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("News successfully saved!"),
                              ));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage(colorScheme: ColorScheme.fromSeed(
                                      seedColor: const Color.fromRGBO(117, 167, 24, 1),
                                    ),)),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Something went wrong, please try again."),
                              ));
                            }
                          }
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}