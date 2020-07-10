class WorkersDoptModel {
  //attributes = fields in table
  int id;
  String name;
  int salary;
  int takefrom;
  int remain;

  WorkersDoptModel(
      this.id,
      this.name,
      this.salary,
      this.takefrom,
      this.remain);
  WorkersDoptModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    salary = map['salary'];
    takefrom = map['takefrom'];
    remain = map['remain'];
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'salary': salary,
      'takefrom': takefrom,
      'remain': remain,
    };
    return map;
  }
}
