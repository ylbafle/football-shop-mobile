import 'package:flutter/material.dart';
import 'package:football_shop/screens/form.dart';
import 'package:football_shop/screens/login.dart';
import 'package:football_shop/widgets/drawer.dart';
import 'package:football_shop/widgets/product_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatelessWidget {
    MyHomePage({super.key, required ColorScheme colorScheme}); 

    final String nama = "Cathlin Abigail";
    final String npm = "2406418774";
    final String kelas = "A";

    final List<ItemHomepage> items = [
    ItemHomepage("All Products", Icons.list, Colors.blue),
    ItemHomepage("My Products", Icons.person, Colors.green),
    ItemHomepage("Add Product", Icons.add, Colors.red),
  ];

  @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
    // Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
    return Scaffold(
      // AppBar: bagian atas halaman untuk show judul
        appBar: AppBar(
        title: const Text(
          'Soccerholy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        
         // untuk tombol logout
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: Theme.of(context).colorScheme.primary,
                elevation: 0, 
                shape: const StadiumBorder(), 
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Logout'),
            onPressed: () async {
              
            final response = await request.logout(
                "http://127.0.0.1:8000/auth/logout/"); 
            
            String message = response["message"];
            if (context.mounted) {
                if (response['status']) {
                    String uname = response["username"];
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message See you again, $uname."),
                    ));
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(message),
                        ),
                    );
                }
              }
            },
          ),
        )],
      ),
      drawer: LeftDrawer(),

      // Body halaman dengan padding di sekelilingnya.
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Menyusun widget secara vertikal dalam sebuah kolom.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row untuk menampilkan 3 InfoCard secara horizontal.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoCard(title: 'NPM', content: npm),
                InfoCard(title: 'Name', content: nama),
                InfoCard(title: 'Class', content: kelas),
              ],
            ),

            // Memberikan jarak vertikal 16 unit.
            const SizedBox(height: 16.0),

            // Menempatkan widget berikutnya di tengah halaman.
            Center(
              child: Column(
                // Menyusun teks dan grid item secara vertikal.

                children: [
                  // Menampilkan teks sambutan dengan gaya tebal dan ukuran 18.
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Welcome to Soccerholy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),

                  // Grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom.
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    // Agar grid menyesuaikan tinggi kontennya.
                    shrinkWrap: true,

                    // Menampilkan ItemCard untuk setiap item dalam list items.
                    children: items.map((ItemHomepage item) {
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// untuk atribut card
class ItemHomepage {
  final String name;
  final IconData icon;
  final Color? color;

  ItemHomepage(this.name, this.icon, this.color);
}

// untuk tampilin card dan titlenya
class InfoCard extends StatelessWidget {

  final String title;  
  final String content;  

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      // make a new card
      elevation: 2.0,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5, 
        padding: const EdgeInsets.all(16.0),
        // susun title and content vertically
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(content),
          ],
        ),
      ),
    );
  }
}

