class Yemekler{
  int yemek_id;
  String yemek_adi;
  String yemek_resim_adi;
  int yemek_fiyat;

  Yemekler(
      {required this.yemek_id,
        required  this.yemek_adi,
        required  this.yemek_resim_adi,
        required  this.yemek_fiyat});

  // JSON'dan nesneye dönüştürme
  factory Yemekler.fromJson(Map<String, dynamic> json) {
    return Yemekler(
      yemek_id: int.parse(json['yemek_id']),
      yemek_adi: json['yemek_adi'] as String,
      yemek_resim_adi: json['yemek_resim_adi'] as String,
      yemek_fiyat:  int.parse(json['yemek_fiyat']),
    );
  }

  // Nesneden JSON'a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'yemek_id': yemek_id,
      'yemek_adi': yemek_adi,
      'yemek_resim_adi': yemek_resim_adi,
      'yemek_fiyat': yemek_fiyat,
    };
  }
}