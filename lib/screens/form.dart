import 'package:flutter/material.dart';
import 'package:football_shop/widgets/drawer.dart';

class ProductForm extends StatefulWidget {
    const ProductForm({super.key});

    @override
    State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  String _desc = "";
  String _category = "jersey"; // default
  String _thumbnail = "";
  bool _localbrand = false; // default
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
                    // onchanged dijalankan setiap ada perubahan isis textformfield
                    onChanged: (String? value) {
                      setState(() {
                        _title = value!;
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

                // === Local Product ===
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                    title: const Text("Mark as Local Product"),
                    value: _localbrand,
                    onChanged: (bool value) {
                      setState(() {
                        _localbrand = value;
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Berita berhasil disimpan!'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Name: $_title'),
                                      Text('Description: $_desc'),
                                      Text('Price: $_price'),
                                      Text('Stock: $_stock'),
                                      Text('Image: $_thumbnail'),
                                      Text(
                                          'Local Product: ${_localbrand ? "Yes" : "No"}'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _formKey.currentState!.reset();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
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