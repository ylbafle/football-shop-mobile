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

---------------------------------- Tugas 9 ----------------------------------
1. Mengapa kita perlu membuat model Dart saat mengambil/mengirim data JSON? 
    karena model disini berfungsi sebagai blueprint untuk data yang kita punya, misal di tugas ini kita punya data product, maka kita perlu model untuk si product (class ProductEntry) sebagai blueprint dari semua data product yang menyimpan atribut product itu sendiri, yaitu nama, deskripsi, harga, dll.
    konsekuensinya jika langsung memetakan Map<String, dynamic> tanpa model (terkait validasi tipe, null-safety, maintainability)?
    Dengan model, kita bisa jamin kalau price itu integer atau name itu String, jika data type salah, aplikasi akan kasih tau errornya dan tidak crash tiba tiba. Model juga membantu kita mendefisinisikan mana data yang wajib ada atau required dan mana yang boleh null dengan bantuan ?. Terkait maintainability, tanpa model, kita harus mengetik string manual setiap kali inisialisasi product baru, seperti data['product_name'] berulang-ulang. Sehingga jika terjadi perubahan di API, kita cukup ubah file product_entry.dart aja atau 1 file model terkait.

2. Apa fungsi package http dan CookieRequest dalam tugas ini? Jelaskan perbedaan peran http vs CookieRequest.
    - package http ini menjadi tool untuk kita melakukan request, seperti GET atau POST. http ini bersifat stateless, jadi setiap request akan dianggap baru dan tidak membawa ingatan dari login sebelumnya.
    - CookieRequest dari pbp_django_auth ini serupa dengan http tapi dia punya memori dan ga stateless. Jadi setiap kita berhasil login, session cookies akan disimpan, dan setiap kita request, CookieRequest akan otomatis attach session cookies yang kita punya jadi data kita sebagai user yang lagi login tercatat.

3. Jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
    seperti yang sudah dijelaskan di nomor 2, CookieRequest menyimpan status login kita melalui session cookies. Jika setiap halaman kita declare CookieRequest baru dengan membuat new CookieRequest(), maka halaman tersebut akan dianggap sebagai user baru karena cookiesnya kosong (since kita declare ulang atau tidak pakai cookies yang sudah ada). That's why kita share dia dengan Provider di main.dart, kita make sure ada satu instance tunggal yang handle session cookies dan share cookies untuk halaman lain yang butuh untuk interact dengan server.

4.  Jelaskan konfigurasi konektivitas yang diperlukan agar Flutter dapat berkomunikasi dengan Django. Mengapa kita perlu menambahkan 10.0.2.2 pada ALLOWED_HOSTS, mengaktifkan CORS dan pengaturan SameSite/cookie, dan menambahkan izin akses internet di Android? Apa yang akan terjadi jika konfigurasi tersebut tidak dilakukan dengan benar?
    Jadi, agar Flutter dan Django bisa saling terhubung atau communicate, kita perlu semacan izin. 10.0.2.2 di ALLOWED_HOSTS membuat Android Emulator menganggap localhost adalah dirinya sendiri dan 10.0.2.2 ini menjadi alamat IP khusus untuk akses server Django dari dalam emulator. Maka, Django harus mengizinkan IP ini agar saat mau diakses tidak ada penolakan akses.
    CORS atau Cross-Origin Resource Sharing yang kita aktifkan berfungsi untuk memblokir akses data antar-domain dan memastikan bahwa browser kita tau bahwa mengambil data dari Django itu aman.
    SameSite/cookie ini adalah kebijakan keamanan modern utuk blok pengiriman cookie antar situs (same site). Kita perlu set SameSite='None' agar Flutter bisa kirim session cookie ke Django saat request.
    Untuk izin akses internet di Andorid (<uses-permission android:name="android.permission.INTERNET" />), ini kita perlu lakukan setting di AndroidManifest.xml karena agar HP diizinkan menggunakan radio internetnya karena secara default, aplkasi android itu isolated atau offline.
    Jika konfigurasi salah, maka aplikasi akan stuck loading terus menerus atau timeout dan akan muncul error connection refused atau error "403 Forbidden/Unauthorized" karena gagal login.

5.  Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
    - user input data di TextFormField pada halaman form (form.dart)
    - fuction onChanged detect ketikan user dan simpan data input user ke variable lokal dengan setState()
    - saat user klik tombol save, request.postJson mengubah data variabel hasil input user tadi menjadi format JSON dan dikirim ke URL Django (create-flutter)
    - Django akan menerima JSON, validate, dan simpan ke database
    - Di halama ProductEntryListPage, ada fungsi fetchProducts yang memanggil request.get ke endpoint JSON Django (fetch data)
    - setelah data JJSON diterima, data akan diubah jadi object ProductEntry dan ditampilkan dengan ListView.builder

6. Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
    - Login:
        - user input username dan pass di halaman login (login.dart)
        - saat button login ditekan, fungsi request.login() dari pbp_django_auth dipanggil ke endpoint /auth/login
        - di Django, fungsi login(request) memanggil authenticate(username, password) untuk cek input dengan data di database. Jika user cocok, Django panggil auth_login(requeset, user), Django akan membuat baris baru di tabel django_session yang berisi ID session dan data user, di header response, Django akan menyisipkan header Set-Cookie yang berisi session ID yang akan dibaca di Flutter nanti
        - Kalau berhasil, function akan return response JSON berisi data user dan pesan sukses
        - di Flutter, CookieRequest akan catch sessionid dari header response dan simpan di memori
        - jika reques.loggedIn bernilai true, user diarahkan ke My HomePage
    - Akses Menu
        - di main.dart, CookieRequest dinitiate seklai menggunakan Provide di root aplikasi dan ini membuat instance CookieRequest yang berisi session cookie 
        - saat user buka halaman menu atau halaman lain, Flutter akan abil instance cookie -> context.watch<CookieRequest>()
        - setiap user mau reqeust (misal request.get()), CookieRequest akan attach sessionid yang disimpan ke header request
        - Django menerima request, cek sessiondid dan cocokin ke django_session sehingga nanti Django bisa kasih akses data
    - Register
        user input data di form register pada RegisterPage
        data ditangkap controller, misal username ditangkap sama _usernameController
        saat tombol ditekan, fungsi request.postJson dipanggil ke endpoint auth/register
        data username dan password akan diencode ke format JSON sebelum dikirim
        di Django, fungsi register(request) akan terima request POST dan parse bodey request dari JSON jadi dictionary python dengna json.loads(request.body)
        setelah itu akan dilakukan validasi username dan password apakah valid dan sesuai
        jika sesuai dan validasi lolos, Django akan membuat user baru (User.objects.create_user()) dan disimpan ke database
        kemudian akan direturn JsonResponse dengan status success kembali ke Flutter
        Flutter akan terima response tersebut dan menampilkan snackbar "successfully resigtered!"
    - Logout
        - user menekan tombol logout, Flutter call function request.logout() ke endpoint
        - di Django, kita pake fungsi bawaan auth_logout, Django akan cari sessionid di database dan hapus session id user tersebut
        - di Flutter, pbp_django_auth akan delete cookie yang tersimpan di memori aplikasi Flutter, status loggedIn menjadi false.
        - dengan pushReplacement, user diarahkan ke LoginPage

7. Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).
    - Integrasi Login, Register, dan Logout
        menambahakan package Provider dan pbp_django_auth di pubspec.yaml
        modifikasi main.dart agar wrap aplikasi dengan Provider yang menyediakan CookieRequest (agar bisa shared cookie session nanti)
        membuat login.dart dan register.dart unuk handle input user dan communicate dengan endpoint auth Django (detail langkah telah dijelaskan di nomor 6)
    - Membuat model custom
        di file product_entry.dart kita buat class ProductEntry, kita define attribute sesuai dengan JSON Django, seperti name, price, description, dll
        dari return JSONResponse dari dartt, kita bisa ambil beberapa value dari product kita dan memasukkannya ke setiap properti atau atribute di object Dart kita
        hal ini memungkinkan kita untuk akses data dengan mudah, misal product.price daripada product['price'] yang lebih sulit
    - Halaman detail Item (product_detail.dart)
        halaman ini menerima required this.rpoduct, jadi nanti di halaman ini ga perlu fetch lagi, hanya terima hasil fetch data dari halaman lain dan data akan disusun dengan layout SingleChildScrollView agar tidak overflow
    - Filter halaman
        di product_entry_list.dart kita ambil username yang sedang login berdasarkan JSON (request.jsonData['username']), terus di dalama loop ikta check, kalau product ini dicreate sama user yang lagi login, maka kita tambahkan ke list product yang akan kita tampilkan di halaman
        untuk trigger filtering ini, di product_card.dart (homepage), tombol My Products akan memanggil list product itu dengan parameter filter, builder: (context) => const ProductEntryListPage(filter: true,)

        
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

