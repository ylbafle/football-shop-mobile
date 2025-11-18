import 'package:flutter/material.dart';
import 'package:football_shop/screens/form.dart';
import 'package:football_shop/screens/menu.dart';
import 'package:football_shop/screens/product_entry_list.dart';
import 'package:football_shop/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  // untuk tampilin button

  final ItemHomepage item; 

  const ItemCard(this.item, {super.key}); 

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,                        // ambil warna berdasarkan atribut per itemnya
      borderRadius: BorderRadius.circular(12),  // add border radius untuk setiap card

      child: InkWell(
        // what to do ketika card diclick
        onTap: () {
          // show snackbar ketika dia diclick
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
            );

            if (item.name == "Add Product") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductForm(),
              ));}
            
            else if (item.name == "All Products") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductEntryListPage()  // all products showing
                    ),
                );
            }
        },
        // container untuk simpan icon and text
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              // Menyusun ikon dan teks di tengah kartu.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}