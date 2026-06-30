import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memory_game/services/api_service.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  final String category;
  const GameScreen({super.key, required this.category});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> cardImages = [];
  List<bool> cardFlipped = []; // Kartların açık/kapalı durumunu tutan liste
  bool isLoading = true;

  int? firstIndex; // ilk seçilen kartın indexi
  int? secondIndex; // ikinci seçilen kartın indexi
  bool isChecking = false; // kontrol sırasında tıklamayı engeller

  int hamle = 0;
  int saniye = 0;
  Timer? _timer;
  void startGame() {}

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        saniye++;
      });
    });
    super.initState();
    ApiService().fetchGameImages(widget.category, 8).then((urls) {
      setState(() {
        // 1. Resimleri kopyalayıp 16 adet yapıyoruz ve karıştırıyoruz
        cardImages = [...urls, ...urls];
        cardImages.shuffle();

        // 2. 16 kartın hepsi için başlangıçta "false" (kapalı) durumu üretiyoruz
        cardFlipped = List.generate(cardImages.length, (index) => false);

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} | $hamle Hamle | $saniye sn'),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: cardImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                // Eğer kart açılmışsa resmi göster, kapalıysa turuncu soru işaretini göster

                return GestureDetector(
                  onTap: () {
                    if (isChecking)
                      return; // kontrol sırasında tıklamayı engelle
                    if (cardFlipped[index])
                      return; // zaten açık kartı tekrar açma

                    setState(() {
                      cardFlipped[index] = true;
                    });

                    if (firstIndex == null) {
                      // ilk kart seçildi
                      firstIndex = index;
                    } else {
                      // ikinci kart seçildi
                      secondIndex = index;
                      isChecking = true;
                      hamle++;

                      Future.delayed(const Duration(milliseconds: 800), () {
                        setState(() {
                          if (cardImages[firstIndex!] !=
                              cardImages[secondIndex!]) {
                            // eşleşmedi, kapat
                            cardFlipped[firstIndex!] = false;
                            cardFlipped[secondIndex!] = false;
                          }
                          firstIndex = null;
                          secondIndex = null;
                          isChecking = false;
                        });
                        bool oyunBitti = cardFlipped.every(
                          (kart) => kart == true,
                        );
                        if (oyunBitti) {
                          _timer?.cancel();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Tebrikler!"),
                                content: Text(
                                  "$hamle hamlede $saniye saniyede bitirdin!",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Kapat'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // dialog kapanır
                                      setState(() {
                                        cardFlipped = List.generate(
                                          cardImages.length,
                                          (index) => false,
                                        );
                                        cardImages.shuffle();
                                        hamle = 0;
                                        saniye = 0;
                                      });
                                      _timer = Timer.periodic(
                                        const Duration(seconds: 1),
                                        (timer) {
                                          setState(() {
                                            saniye++;
                                          });
                                        },
                                      );
                                    },
                                    child: const Text('Tekrar Oyna'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    }
                  },
                  child: cardFlipped[index] == true
                      ? Card(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            cardImages[index],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Card(
                          color: Colors.orange,
                          child: const Center(
                            child: Icon(
                              Icons.question_mark,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                );
              },
            ),
    );
  }
}
