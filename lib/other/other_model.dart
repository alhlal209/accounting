class OtherModel {
  //attributes = fields in table
  int id;
  int salary;
  String TakeOrPut;
  String date;

  OtherModel(this.id, this.salary,
      this.TakeOrPut,
      this.date);

  OtherModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    salary = map['salary'];
    TakeOrPut = map['TakeOrPut'];
    date = map['date'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'salary': salary,
//      'up': up,
      'date': date,
    };
    return map;
  }
}
