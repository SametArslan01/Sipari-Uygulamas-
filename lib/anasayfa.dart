import 'package:flutter/material.dart';
import 'package:siparis_uygulamasi/entity/sepet_yemekler.dart';
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
              decoration: InputDecoration(
                hintText: "Ara",
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(width: 3,color: Colors.grey)),
                suffixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search_rounded,color: Colors.grey,))
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Yemekler>>(
              future: yemeklerFuture,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata oluştu: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Yemekler bulunamadı"));
                }else{
                  List<Yemekler> yemekler = snapshot.data!;
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
                          onTap: (){},
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
                                  IconButton(
                                      onPressed: (){
                                    sepeteYemekEkle(yemek.yemek_id, yemek.yemek_adi, yemek.yemek_resim_adi, yemek.yemek_fiyat,1);
                                  }, icon: const Icon(Icons.add_box,size: 40,))
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
Future<void> sepeteYemekEkle(int yemek_id, String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet) async {
 final sepetYemek = SepetYemekler(sepet_yemek_id: yemek_id, yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: "samet");
  var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");

  var value=jsonEncode(sepetYemek.toJson());
  var response = await http.post(url,
    headers: <String, String>{
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: sepetYemek.toJson(),
  );

  if (response.statusCode == 200) {
    print('Sepete ekleme başarılı: ${response.body}');
  } else {
    print('Sepete ekleme başarısız: ${response.statusCode}, ${response.body}');
  }
}
