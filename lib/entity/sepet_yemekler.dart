class SepetYemekler{
  int sepet_yemek_id;
  String yemek_adi;
  String yemek_resim_adi;
  int yemek_fiyat;
  int yemek_siparis_adet;
  String kullanici_adi;

  SepetYemekler(
      { required this.sepet_yemek_id,
        required this.yemek_adi,
        required this.yemek_resim_adi,
        required this.yemek_fiyat,
        required this.yemek_siparis_adet,
        required this.kullanici_adi});

  // JSON'dan nesneye dönüştürme
  factory SepetYemekler.fromJson(Map<String, dynamic> json) {
    return SepetYemekler(
      sepet_yemek_id: int.parse(json['sepet_yemek_id']),
      yemek_adi: json['yemek_adi'] as String,
      yemek_resim_adi: json['yemek_resim_adi'] as String,
      yemek_fiyat:  int.parse(json['yemek_fiyat']),
      yemek_siparis_adet: int.parse(json["yemek_siparis_adet"]),
      kullanici_adi: json["kullanici_adi"] as String,
    );
  }

  // Nesneden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'yemek_adi': yemek_adi,
      'yemek_resim_adi': yemek_resim_adi,
      'yemek_fiyat': yemek_fiyat.toString(),
      'yemek_siparis_adet': yemek_siparis_adet.toString(),
      'kullanici_adi': "samet",
    };
  }

}