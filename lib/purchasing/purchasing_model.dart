class PurchasingModel {
  //attributes = fields in table
  int id;
  String details;
  int price;

  PurchasingModel(this.id, this.price, this.details);

  PurchasingModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    details = map['details'];
    price = map['price'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'details': details,
      'price': price};
    return map;
  }
}
