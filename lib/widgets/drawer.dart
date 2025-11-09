import 'package:flutter/material.dart';
import 'package:football_shop/screens/menu.dart';
import 'package:football_shop/screens/form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(117, 167, 24, 1),
            ),child: Column(
              children: [
                Text(
                  'Soccerholy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Explore Soccerholy!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal, // weight biasa
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyHomePage(colorScheme: Theme.of(context).colorScheme),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.post_add),
            title: const Text('Add Product'),
            // redirection ke form
            onTap: () {
              // routing ke form
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductForm(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}