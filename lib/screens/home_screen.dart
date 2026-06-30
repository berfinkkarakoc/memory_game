import 'package:flutter/material.dart';
import 'package:memory_game/screens/game_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_game/screens/auth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Game> kategoriler = [
    Game(
      name: 'Hayvanlar',
      category: 'animals',
      image: AssetImage('assets/images/hayvan_eslestirme.png'),
    ),
    Game(
      name: 'Uzay',
      category: 'space',
      image: AssetImage('assets/images/uzay_eslestirme.png'),
    ),
    Game(
      name: 'Bayraklar',
      category: 'flags',
      image: AssetImage('assets/images/bayrak_eslestirme.png'),
    ),
    Game(
      name: 'Doğa',
      category: 'nature',
      image: AssetImage('assets/images/doga_eslestirme.png'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],

      appBar: AppBar(
        title: const Text('KART ŞEÇ'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu),
            onSelected: (String value) {
              if (value == 'ayarlar') {
                print("Ayarlara tıklandı");
              } else if (value == 'profil') {
                print("Profile tıklandı");
              } else if (value == 'cikis') {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'profil',
                  child: Text('Profil Bilgileri'),
                ),
                PopupMenuItem<String>(
                  value: 'ayarlar',
                  child: Text('Sistem Ayarları'),
                ),
                PopupMenuItem<String>(value: 'cikis', child: Text('Çıkış Yap')),
              ];
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.only(top: 50.0),
        itemCount: kategoriler.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5,
        ),

        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GameScreen(category: kategoriler[index].category),
                ),
              );
            },
            child: Card(
              clipBehavior:
                  Clip.antiAlias, // Resmin köşelerinin taşmasını engeller
              child: Stack(
                children: <Widget>[
                  // 1. Katman: Resmi tüm kartı kaplayacak şekilde yayıyoruz
                  Positioned.fill(
                    child: Image(
                      image: kategoriler[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 2. Katman: Yazıyı en alta ortalıyoruz
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double
                          .infinity, // Şeridin kartı tamamen kaplaması için
                      color: Colors
                          .black54, // Yazının arkasına hafif siyah saydam bir şerit (okunmayı kolaylaştırır)
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ), // Yazıya alt-üst boşluk
                      child: Text(
                        kategoriler[index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors
                              .white, // Resmin üstünde beyaz yazı çok daha iyi görünür
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Game {
  final String name;
  final String category;
  final ImageProvider image;

  Game({required this.name, required this.category, required this.image});
}
