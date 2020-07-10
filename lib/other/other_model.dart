class OtherModel {
  //attributes = fields in table
  int id;
  int salary;
//  bool up;
  String date;

  OtherModel(this.id, this.salary,
//      this.up,
      this.date);

  OtherModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    salary = map['salary'];
//    up = map['up'];
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
