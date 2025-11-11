# football_shop

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
---------------------------------- Tugas 8 ----------------------------------
1. Navigator.push() vs Navigator.pushReplacement()
    Menggunakan Navigator.push() berarti kita menambahkan route baru ke stack (jadi kayak kita push halaman baru terus timpa halaman yang lama) sehingga route yang baru itu ada di halaman paling atas stack dan bisa dilihat user. Kalau Navigator.pushReplacement() itu menghapus route yang saat ini lagi ditampilin dan digantikan dengan route yang baru. Jadi, route lama (yang paling terakhir diakses) digantikan langsung sama route baru.
    Dalam kasus apa kedua navigator itu digunakan?
    Navigator.push() cocok digunakan kalau di halaman yang baru mau kita tambahin ada button back atau button untuk kembali ke halaman sebelumnya karena Navigator.push() kan tidak menghapus halaman sebelumnya sehingga memungkinkan pengguna untuk kembali. Contoh saat kita isi New Product Form itu ada button back kalau user tidak jadi isi formnyaa, jadi balik ke halaman sebelum form itu dipanggil. Navigator.pushReplacement() cocok digunakan kalau misal user setelah login pindah ke main page. Karena user udah berhasil login jadi harusnya user ga perlu ada button back untuk ke login page lagi. Jadi, langsung aja direplace sama route yang ke main page.

2. Bagaimana memanfaatkan hierarki widget?
    Di project football shop ini, scaffold digunakan sebagai widget terluar buat setiap page yang kita buat karena scaffold menjadi struktur atau kerangka dasar dari halaman tersebut sehingga ini juga bisa membuat halaman lain seragam gitu secara ukuran. 
    Untuk AppBar itu dijadikan child dari Scaffold (di menu.dart) jadi dia ada di bahian paling atas Scaffold. Hierarki ini membuat AppBar ada di dalam Scaffold dan ukurannya ga melebihi Scaffold. Sama halnya dengan drawer, di sini drawer juga ada di Scaffold sebagai child. Karena kedua child ini di dalam Scaffold, jadi ukuran mereka juga konsisten setiap pemanggilan.

3. Kelebihan layout widget saat membuat form:
    a. Padding: kasih jarak ke tepi halaman, jadi widget text field atau button ga langsung menempel ke tepian sehingga desain terlihat lebih leluasa dan rapi.
    Contoh di setiap input, misal product name, itu idbungkus di dalam padding -> padding: const EdgeInsets.all(8.0) dimana ada spasi 8 piksel di sekeliling setiap field
    b. SingleChildScrollView: membungkus column yang berisi semua field form jadi content di dalamnya (bagian body) bisa discroll.
    Contoh: di form.dart, Column yang berisi semua field data yang harus diisi user, diwrap di dalam SingleChildScrollView
    c. ListView: fungsinya mirip dengan SingleChildScrollView, tetapi ListView didesign untuk display large number of child widgets, kalau SingleChildScrollView, sesuai namanya, hanya bisa wrap 1 child

4. Warna Tema
    Warna tema diset di main.dart sebagai tempat pusat untuk tema sehingga warnanya konsisten di seluruh app. Jadi di MyApp, didefinisikan ThemeData untuk MaterialApp, digunakan ColorScheme.fromSedd untuk ambil warna hijau khas Soccerholy, jadi nanti flutter otomatis fenerate seluruh color pallete dari seed warna tersebut sehingga warnanya konsisten.


---------------------------------- Tugas 7 ----------------------------------
1. Flutter Widget Tree
    Widget tree adalah gabungan dari beberapa widget yang menggambarkan bagaimana widget saling terhubung satu sama lain (semacam peta atau tree)
    Bagaimana hubungan parent-child bekerja antar widget?
    - Top to Bottom (Parent ke Child)
        Parent memberi batasan atau constraint data, aturan layout, dan lainnya ke child
    - Bottom to Top (Child ke Parent)
        Child memberikan konten yang ingin ditampilkan di dalam parent dan  menentukan apa yang dia butuh tapi masih sesuai dengan batasan parent. Contohnya, menentukan ukuran yang dibutuhkan tanpa melebihi ukuran batas dari parent. Kemudian, child akan mengembalikan hasil ukuran itu ke parent dan parent akan menata posisi childnya.
        Kalau child menghasilkan event, ia memberi tahu parent melalui callback.

2. Widget pada Football_Shop
    a. Widget custom (buatan sendiri)
        - MyHomePage sebagai widget home page dan menjadi container untuk semua widget lain di dalamnya, misal Scaffold, AppBar, Column, Row, GridView, dll.
        - InfoCard sebagai card (template card) untuk show informasi npm, nama, kelas -> reusable widget.
        - ItemCard sebagai card (template card) untuk show button dalam bentuk card yang bisa diklik 
    b. Widget Tata Letak
        - Scaffold sebagai kerangka dasar halaman untuk menyediakan struktur halaman standar, seperti appBar (yang di atas) dan body (yang di tengah)
        - AppBar untuk menampilkan judul halaman
        - Padding untuk memberi spasi di sekeliling child
        - Column sebagai penyusun children di dalamnya secara vertikal ke bawah 
        - Row sebagai penyusun children di dalamnya secara horizontal ke samping (kiri ke kanan)
        - Center untuk menepatkan child di tengah suatu area
        - SizedBox adalah kotak kosong untuk memberi jarak atau space antar elemen (mirip margin)
        - GridView.count: susunan grid untuk susun children dalam bentuk grid, bisa kita set misal pakai crossAxisCount: 3, ini berarti kita susun 3 kolom ke samping
    c. Widget Tampilan
        - Text: untuk show text 
        - Icon: show ikon dari library Flutter, contoh di tugas 7 ini ada Icons.list
        - Card: widget dasar untuk InfoCard untuk membuat kotak with rounded edge dan sedikit shadow
        - Material: kanvas untuk ItemCard sebagai alas yang bisa diberi warna dan borderRadius
        - Inkwell: membuat ItemCard bisa diklik dan widget ini juga untuk detext onTap dan memberi efek riak air saat disentuh
        - ScaffoldMessanger/SnackBar: untuk show widget SnackBar (pop-up kecil di bawah with message) saat ada triggering action


3. Apa itu MaterialApp?
    MaterialApp adalah widget pembungkus utama yang menyediakan semua fitur yang diperlukan untuk membangun suatu aplikasi. Bisa dipakai untuk tema, misal kalau di tutorial kita pakai untuk colors theme jadi warna biru, untuk navigasi halaman, dan menentukan halaman home.
    Kenapa sering jadi widget root?
    Karena MaterialApp yang menyediakan dasar buat widget widget kita karena dia yang provide tema atau cara navigasi.

4. StatelessWidget dan StatefulWidget
    StatelessWidget berarti widget tidak punya state atau ingatan, jadi widget tidak bisa berubah, contohnya Text dan Icon. Kita gunakan StatelessWidget kalau kita tidak perlu merubah widget jika ada interaksi dari pengguna.
    StatefulWidget adalah widget yang memiliki state atau ingatan internal. Jadi widget ini bisa berubah kapan aja selama aplikasiinya berjalan. StatefulWidget bisa merubah dirinya sendiri dengan memanggil fungsi setState(). Contohnya checkbox, ada state dimana dia dicentang atau tidak. StatefulWidget digunakan kalau kita perlu tampilan yang mau diperbarui saat aplikasi berjalan atau saat pengguna menekan tombol, mengetik sesuatu, atau data yang berubah.

3. Apa itu BuildContext?
    Untuk setiap widget memiliki BuildContextnya masing-masing yang menyimpna informasi di mana tepat widget tersebut ada di suatu tree. Jadi, BuildContext semacam GPS untuk menemukan ancestors atau leluhurnya.
    Bagaimana penggunaannya di method build?
    Metode build adalah metode yang bertugas untuk menggambar widget dengan BuildContext sebagai parameter yang secara otomatis diberikan flutter. BuildContext ini menjadi penghubung antara widget sekarang denagan ancestors terdekat yang menyediakan layanan atau fitur tertentu. Misal dia menggunakan Theme.of(context) maka widget akan mencari data theme dari ancestors terdekatnya.

4. Hot Reload vs Hot Restart
    Hot reload diipanggil dengan menekan r kecil dan perintah ini akan mengupdate kode terbaru kita ke aplikasi yang sedang berjalan tanpa perlu restart aplikasi, tetapi hanya method build yang dijalankan ulan dan state tidak direset karena kita cuma jalanin method build(). Jika kita melakukan perubahan seperti merubah warna atau state (semua yang diluar method build), umumnya hot reload sering gagal.
    Hot restart dipanggil dengan menekan R besar. Hot restart mamtikan aplikasi internal dan bangun ulang seluruh aplikasi dari awal, seluruh widget tree akan dibuat ulang, dan state akan direset. Hot restart dapat digunakan jika kita mengubah suatu struktur class atau ubah state.

5. Navigasi untuk berpindah layar di Flutter
    Bisa menggunakan widget Navigator dari MaterialApp. 
    - Berpindah layar baru (push)
        Untuk berpindah ke layar atau halaman baru kita seakan push halaman baru tersebut ke atas tumpukan jadi halaman saat ini seperti tertutup. Kita bisa pakai metode Navigator.push() yang membutuhkan context (untuk tahu lokasi) dan rute halaman baru. Untuk rutenya paling umum digunakan MaterialPageRoute yang umumnya juga handle animasi transisi halaman.
        Cara alternatif, kita jjuga bisa menggunakan Navigator.pushNamed() untuk langsung direct ke halaman tertentu dengan rute yang udah diberi nama, misal Navigator.pushNamed(context, '/nextPage')
    - Kembali ke Layar Sebelumnya (Pop)
        Untuk kembali ke layar atau halaman sebelumnya, kita menghapus atau pop halaman saat ini dari atas tumpukan jadi seakan halaman dibawahnya terlihat atau muncul lagi. Kita bisa pakai method Navigator.pop().

