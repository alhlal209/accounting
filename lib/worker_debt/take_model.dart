class TakeModel {
  //attributes = fields in table

  int idtake;
  int quantity;
  String date;
  int foreignkey;
  TakeModel(
      this.idtake,
      this.quantity,
      this.date,
      this.foreignkey
      );

  TakeModel.fromMap(Map<String, dynamic> map) {
    idtake = map['idtake'];
    quantity = map['quantity'];
    date = map['date'];
    foreignkey = map['foreignkey'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idtake': idtake,
      'quantity': quantity,
      'date': date,
      'foreignkey': foreignkey,
    };
    return map;
  }
}
