import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'entity/sepet_yemekler.dart';
import 'entity/yemekler.dart';


class DetaySayfasi extends StatefulWidget {
   final Yemekler sepeteEklenecekYemek;
   DetaySayfasi({super.key,required this.sepeteEklenecekYemek});

  @override
  State<DetaySayfasi> createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {

  int yemekAdeti  = 1;
  double toplamYemekFiyat = 0.0;

  @override
  void initState() {
    super.initState();
    toplamYemekFiyat = double.parse(widget.sepeteEklenecekYemek.yemek_fiyat.toString());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text("Ürün Detayı",style: TextStyle(fontWeight: FontWeight.bold),),automaticallyImplyLeading: false,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
    }, icon: const Icon(Icons.close,size: 30,),
      ),
        actions: const [Icon(Icons.favorite,size: 30,),SizedBox(width: 15,)],
    ),
      body: Column(
        children: [
          const Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star,color: Colors.amber,),
                Icon(Icons.star,color: Colors.amber,),
                Icon(Icons.star,color: Colors.amber,),
                Icon(Icons.star,color: Colors.amber,),
                Icon(Icons.star_border,),
              ],
            ),
          ),
          Image.network("http://kasimadalan.pe.hu/yemekler/resimler/${widget.sepeteEklenecekYemek.yemek_resim_adi}",
          width: 250,height: 250,),
          Text("\u20BA${widget.sepeteEklenecekYemek.yemek_fiyat.toString()}",
            style: const TextStyle(color: Colors.indigo,fontSize: 30,fontWeight: FontWeight.bold),),
          Text(widget.sepeteEklenecekYemek.yemek_adi,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 35),),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      if(yemekAdeti <= 1){}else {
                        yemekAdeti--;
                      toplamYemekFiyat = (yemekAdeti * double.parse(widget.sepeteEklenecekYemek.yemek_fiyat.toString()));
                      }
                    });
                  },
                  child: Container(width: 70,height: 70,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.indigo,),
                  child: const Icon(Icons.remove,color: Colors.white,size: 40,),),
                ),
                Container(width: 70,height: 70,color: Colors.white,
                  child: Center(child: Text(yemekAdeti.toString(),style: const TextStyle(fontSize: 40,fontWeight: FontWeight.bold),)),),
                InkWell(
                  onTap: (){
                    setState(() {
                      yemekAdeti++;
                      toplamYemekFiyat = (yemekAdeti * double.parse(widget.sepeteEklenecekYemek.yemek_fiyat.toString()));
                    });
                  },
                  child: Container(width: 70,height: 70,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.indigo,),
                    child: const Icon(Icons.add,color: Colors.white,size: 40,),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: const Color(0xD5EAEAED),
                padding: const EdgeInsets.symmetric(vertical:5,horizontal: 10),minimumSize: const Size(0, 0), // Minimum boyutu sınırla
                ), child: const Text("25-35 dk",style: TextStyle(color: Color(0xFF5C5C5C),fontSize: 15),)),
                ElevatedButton(
                    onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: const Color(0xD5EAEAED),
                  padding: const EdgeInsets.symmetric(vertical:5,horizontal: 10),minimumSize: const Size(0, 0), // Minimum boyutu sınırla
                ), child: const Text("Ücretsiz Teslimat",style: TextStyle(color: Color(0xFF5C5C5C),fontSize: 15),)),
                ElevatedButton(
                    onPressed: (){},style: ElevatedButton.styleFrom(backgroundColor: const Color(0xD5EAEAED),
                  padding: const EdgeInsets.symmetric(vertical:5,horizontal: 10),minimumSize: const Size(0, 0), // Minimum boyutu sınırla
                ), child: const Text("İndirim %10",style: TextStyle(color: Color(0xFF5C5C5C),fontSize: 15),)),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("\u20BA$toplamYemekFiyat",style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ElevatedButton(
                    onPressed: () async{
                    await sepeteYemekEkle(widget.sepeteEklenecekYemek.yemek_id, widget.sepeteEklenecekYemek.yemek_adi,
                          widget.sepeteEklenecekYemek.yemek_resim_adi,
                          widget.sepeteEklenecekYemek.yemek_fiyat, yemekAdeti);
                    Navigator.pop(context);
                    await  showDialog(context: context, builder: (BuildContext context){
                        return const AlertDialog(
                          content: Text("Ürün Sepete Eklendi",style: TextStyle(fontSize: 25),),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 40),
                  backgroundColor: Colors.indigo
                ), child: const Text("Sepete Ekle",style: TextStyle(color: Colors.white,fontSize: 25),))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Future<void> sepeteYemekEkle(int yemek_id, String yemek_adi, String yemek_resim_adi, int yemek_fiyat, int yemek_siparis_adet) async {
  final sepetYemek = SepetYemekler(sepet_yemek_id: yemek_id, yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: "samet");
  var url = Uri.parse("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php");

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

