import 'package:flutter/material.dart';
import 'package:siparis_uygulamasi/detay_sayfasi.dart';
import 'package:siparis_uygulamasi/entity/yemekler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:siparis_uygulamasi/sepet_sayfasi.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  late Future<List<Yemekler>> yemeklerFuture;
  int yemekSiparisAdeti = 0;
  var tfAramaKelimesi = TextEditingController();
  String aramaQuery = "";
  var iconButton = IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded,color: Colors.grey,));




  @override
  void initState() {
    super.initState();
    yemeklerFuture = yemekListesiGetir();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.only(left: 20,right: 20,top: 30),
          child: const Row(
            children: [
              Text(
                "Merhaba",
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Teslimat Adresi", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text("Evim", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Icon(Icons.home, color: Colors.white, size: 50),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: tfAramaKelimesi,
              decoration: InputDecoration(
                hintText: "Ara",
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.grey)),
                suffixIcon: iconButton,
              ),
              onChanged: (value){
                setState(() {
                  aramaQuery = value.toLowerCase();
                  iconButton = IconButton(onPressed: (){
                    setState(() {
                      tfAramaKelimesi.clear();
                      aramaQuery = "";
                      iconButton = IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded,color: Colors.grey,));
                    });
                  }, icon: const Icon(Icons.close,color: Colors.grey,));
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Yemekler>>(
              future: yemeklerFuture,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Yemekler bulunamadı"));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata oluştu: ${snapshot.error}'));
                }else{
                  List<Yemekler> yemekler = snapshot.data!.where((yemek) => yemek.yemek_adi.toLowerCase().contains(aramaQuery)).toList();
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: yemekler.length,
                    itemBuilder: (context ,index){
                      final yemek = yemekler[index];
                      return  Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DetaySayfasi(sepeteEklenecekYemek: yemek,)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,children: [Icon(Icons.favorite_border)],),
                              ),
                              Image.network(
                                "http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}",
                                width: 100, // Görselin genişliği
                                height: 100, // Görselin yüksekliği
                              ),
                              const SizedBox(height: 5), // İkon ile etiket arasında boşluk
                              Text(
                                yemek.yemek_adi,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.directions_bike,color: Colors.green,size: 16,),
                                  Text("Ücretsiz Gönderim",style: TextStyle(color: Colors.black54,fontSize: 12),),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.currency_lira,size: 25,),
                                  Text(yemek.yemek_fiyat.toString(),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                                  const Spacer(),
                                  const Icon(Icons.add_box,size: 40,),
                                  SizedBox(width: 5,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },

            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SepetSayfasi()));
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.shopping_cart,color: Colors.white,size: 30,),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.home,color: Colors.indigo,),
          ), label: "Anasayfa"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favoriler"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

Future<List<Yemekler>> yemekListesiGetir() async{
  final response = await http.get(Uri.parse("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php"),
  headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if(response.statusCode == 200){
    var data = jsonDecode(response.body);
    List<Yemekler> tumYemekler = [];
    for(var item in data["yemekler"]){
      tumYemekler.add(Yemekler.fromJson(item));
    }
    return tumYemekler;
  }else{
    throw Exception('Yemekl listesi getirilemedi: ${response.statusCode}');
  }
}

