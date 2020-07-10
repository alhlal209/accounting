class ExpensesModel{
  //attributes = fields in table
  int id;
  String details;
  int price;

  ExpensesModel(this.id, this.price, this.details);
  ExpensesModel.fromMap(Map<String, dynamic> map) {
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