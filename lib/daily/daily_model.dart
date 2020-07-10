class DailyModel {
  int id;
  int day;
  int grid;
  int cash;

  DailyModel(this.id, this.day,this.grid,this.cash);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'day': day,
      'grid': grid,
      'cash': cash,
    };
    return map;
  }

  DailyModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    day = map['day'];
    grid = map['grid'];
    cash = map['cash'];
  }
}