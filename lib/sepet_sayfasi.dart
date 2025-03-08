import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:siparis_uygulamasi/anasayfa.dart';
import 'package:siparis_uygulamasi/entity/sepet_yemekler.dart';
import 'package:http/http.dart' as http;


class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}


class _SepetSayfasiState extends State<SepetSayfasi> {

  late Future<List<SepetYemekler>> sepetYemeklerFuture;
  double toplamYemekFiyat = 0.0;

  @override
  void initState() {
    super.initState();
    sepetYemeklerFuture = sepettekiYemekleriGetir();
  }
  double toplamFiyatHesapla(List<SepetYemekler> yemekler) {
    return yemekler.fold(0, (sum, yemek) => sum + (yemek.yemek_siparis_adet * yemek.yemek_fiyat));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(centerTitle: true,title: const Text("Sepetim",style: TextStyle(fontWeight: FontWeight.bold),),backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const Anasayfa()));
        }, icon: const Icon(Icons.close,size: 30,)),
      ),
      body: FutureBuilder<List<SepetYemekler>>(
          future: sepetYemeklerFuture,
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Center(child: Text("Lütfen Sepete Ürün Ekleyiniz!"));
            }else if(snapshot.hasError){
              return Center(child: Text('Hata oluştu: ${snapshot.error}')); //Hata oluştu:
            }else{
              List<SepetYemekler> sepetYemekler = snapshot.data!;
              WidgetsBinding.instance.addPostFrameCallback((_) { //ile toplam fiyatı güvenli bir şekilde güncellenmesini sağladık.Doğrudan setState yapınca sonsuz döngüye girebilir.
                setState(() {
                  toplamYemekFiyat = toplamFiyatHesapla(sepetYemekler);
                });
              });
              return ListView.builder(
                itemCount: sepetYemekler.length,
                  itemBuilder: (context, index){
                  var yemek = sepetYemekler[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                    ),
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 20,left: 20,right: 20),
                    elevation: 5,
                    child: Row(
                      children: [
                      Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}",
                      width: 150,
                      height: 125,),
                      Column(
                        children: [
                        Text(yemek.yemek_adi,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            const Text("Fiyat : "),
                            Text("\u20BA${yemek.yemek_fiyat}",style: const TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                          const SizedBox(height: 10,),
                        Text("Adet : ${yemek.yemek_siparis_adet}",style: const TextStyle(color: Colors.grey),),
                      ],),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Column(children: [
                          IconButton(onPressed: ()async{
                            await sepettenYemekSil(yemek.sepet_yemek_id);
                            setState(() {
                              sepetYemeklerFuture = sepettekiYemekleriGetir();
                            });
                          }, icon: const Icon(Icons.delete,color: Colors.indigo,size: 35,)),
                          const SizedBox(height: 20,),
                          Text("\u20BA${(yemek.yemek_siparis_adet * yemek.yemek_fiyat)}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                        ],),
                      ),
                    ],),
                  );
                  }
              );
            }
          }),
      bottomSheet: Container(height: 157,color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5.0,left: 20,right: 20,top: 5.0),
            child: Column(
              children: [
               const Row(
                 children: [
                      Text("Gönderim ücreti",style: TextStyle(color: Colors.grey),),
                      Spacer(),
                      Text("\u20BA0",style: TextStyle(color: Colors.grey),),
                    ],
                  ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    const Text("Toplam:",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                    const Spacer(),
                    Text("\u20BA$toplamYemekFiyat",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  ],
                ),
                const SizedBox(height: 25,),
                ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFBB44),
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 100.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),),
                ), child: const Text("SEPETİ ONAYLA",style: TextStyle(color: Colors.black,fontSize: 15,),))
              ],
            ),
          )),
    );
  }
}
Future<List<SepetYemekler>> sepettekiYemekleriGetir() async{
  final response = await http.post(Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php"),
  body: {
    "kullanici_adi" : "samet",
  },
  );
  if (response.statusCode == 200) {
    var cevap = jsonDecode(response.body);
    // Gelen yemek verisini işleyebilirsin
    List<SepetYemekler> sepettekiYemekler =[];
    for(var item in cevap["sepet_yemekler"]){
      sepettekiYemekler.add(SepetYemekler.fromJson(item));
    }
    return sepettekiYemekler;
  } else {
    throw Exception('Sepetteki Yemekler listesi getirilemedi: ${response.statusCode}');
  }
}
Future<void> sepettenYemekSil(int yemekId) async{
  final response = await http.post(Uri.parse("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"),
    body: {
      "sepet_yemek_id" : yemekId.toString(),
      "kullanici_adi" : "samet",
    },
  );
  if(response.statusCode == 200){
    print(response.body);
  }else {
    print(response.body);
  }
}
