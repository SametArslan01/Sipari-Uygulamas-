import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:siparis_uygulamasi/entity/sepet_yemekler.dart';
import 'package:http/http.dart' as http;


class SepetSayfasi extends StatefulWidget {
  const SepetSayfasi({super.key});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}


class _SepetSayfasiState extends State<SepetSayfasi> {

  late Future<List<SepetYemekler>> sepetYemeklerFuture;

  @override
  void initState() {
    super.initState();
    sepetYemeklerFuture = sepettekiYemekleriGetir();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("Sepetim",style: TextStyle(fontWeight: FontWeight.bold),),
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close,size: 30,)),
      ),
      body: FutureBuilder<List<SepetYemekler>>(
          future: sepetYemeklerFuture,
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child:CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Center(child: Text('Hata oluştu: ${snapshot.error}'));
            }else if(!snapshot.hasData || snapshot.data!.isEmpty){
              return const Center(child: Text("Yemekler bulunamadı"));
            }else{
              List<SepetYemekler> sepetYemekler = snapshot.data!;
              return ListView.builder(
                itemCount: sepetYemekler.length,
                  itemBuilder: (context, index){
                  var yemek = sepetYemekler[index];
                  return Card(
                    margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
                    elevation: 10,
                    child: Row(
                      children: [
                      Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${yemek.yemek_resim_adi}",
                      width: 125,
                      height: 125,),
                      Column(
                        children: [
                        Text(yemek.yemek_adi),
                        Text("Fiyat : \u20BA ${yemek.yemek_fiyat}"),
                        Text("Adet : ${yemek.yemek_siparis_adet}"),
                      ],),
                      Column(children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.delete)),
                        Text("\u20BA ${(yemek.yemek_siparis_adet * yemek.yemek_fiyat)}")
                      ],),
                    ],),
                  );
                  }
              );
            }
          }),
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
    var data = jsonDecode(response.body);
    // Gelen yemek verisini işleyebilirsin
    List<SepetYemekler> sepettekiYemekler =[];
    for(var item in data["sepet_yemekler"]){
      sepettekiYemekler.add(SepetYemekler.fromJson(item));
    }
    return sepettekiYemekler;
  } else {
    throw Exception('Sepetteki Yemekler listesi getirilemedi: ${response.statusCode}');
  }
}
