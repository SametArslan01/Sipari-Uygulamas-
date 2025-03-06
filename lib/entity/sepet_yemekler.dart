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


  // Nesneden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'sepet_yemek_id': sepet_yemek_id,
      'yemek_adi': yemek_adi,
      'yemek_resim_adi': yemek_resim_adi,
      'yemek_fiyat': yemek_fiyat,
      'yemek_siparis_adet': yemek_siparis_adet,
      'kullanici_adi': kullanici_adi,
    };
  }

}