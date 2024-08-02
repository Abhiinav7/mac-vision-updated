import 'dart:convert';

FoodMenu foodMenuFromJson(String str) => FoodMenu.fromJson(json.decode(str));
String foodMenuToJson(FoodMenu data) => json.encode(data.toJson());

class FoodMenu {
  List<Datum> data;

  FoodMenu({
    required this.data,
  });

  factory FoodMenu.fromJson(Map<String, dynamic> json) => FoodMenu(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String fId;
  String hId;
  String foodName;
  String foodPrice;
  String foodImage;

  Datum({
    required this.fId,
    required this.hId,
    required this.foodName,
    required this.foodPrice,
    required this.foodImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    fId: json["f_id"],
    hId: json["h_id"],
    foodName: json["food_name"],
    foodPrice: json["food_price"],
    foodImage: json["food_image"],
  );

  Map<String, dynamic> toJson() => {
    "f_id": fId,
    "h_id": hId,
    "food_name": foodName,
    "food_price": foodPrice,
    "food_image": foodImage,
  };
}
