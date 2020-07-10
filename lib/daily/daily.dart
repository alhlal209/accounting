import 'DBHelperDaily.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'daily_model.dart';
import 'dart:async';

class Daily extends StatefulWidget {
  @override
  _DailyState createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  //
  Future<List<DailyModel>> dailyModels;
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  int day;
  int cash;
  int sumCash;
  int grid;
  int sumGrid;
  int curUserId;

  final formKey = new GlobalKey<FormState>();
  DBHelperDaily dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelperDaily();
    isUpdating = false;
    refreshList();
    sum();
  }

  refreshList() {
    setState(() {
      dailyModels = dbHelper.getDailyModels();
    });
  }

  sum() {
    dbHelper.sumCash().then((value) {
      setState(() {
        sumCash = value;
      });
    });
    dbHelper.sumGrid().then((value) {
      setState(() {
        sumGrid = value;
      });
    });
  }

  clearName() {
    controller.text = '';
    controller1.text = '';
    controller2.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        DailyModel e = DailyModel(curUserId, day, cash, grid);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        DailyModel e = DailyModel(null, day, cash, grid);
        dbHelper.save(e);
      }
      sum();
      clearName();
      refreshList();
      Navigator.of(context).pop();
    }
  }

  void form() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        isUpdating ? 'تعديل يومية' : 'إضافة يومية',
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'اليوم'),
                  validator: (val) => val.length == 0 ? 'اذخل اليوم' : null,
                  onSaved: (val) => day = int.parse(val),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'ادخل الشبكة'),
                  validator: (val) => val.length == 0 ? 'ادخل رقم صحيح' : null,
                  onSaved: (val) => cash = int.parse(val),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller2,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'ادخل النقدي'),
                  validator: (val) => val.length == 0 ? 'ادخل رقم صحيح' : null,
                  onSaved: (val) => grid = int.parse(val),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xFF0A3154),
                      onPressed: validate,
                      child: Text(
                        isUpdating ? 'تعديل' : 'إضافة',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          isUpdating = false;
                        });
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        isUpdating ? 'الغاء التعديل' : 'الغاء',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void delete() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "هل تريد حذف اليومية",
        style: TextStyle(
          color: Colors.red,
        ),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'اليوم'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller1,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'الشبكة'),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller2,
                  readOnly: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'النقدي'),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Colors.red,
                      onPressed: () {
                        DailyModel dailyModel =
                            DailyModel(curUserId, day, cash, grid);
                        dbHelper.delete(dailyModel.id);
                        Navigator.of(context).pop();
                        clearName();
                        refreshList();
                        sum();
                      },
                      child: Text(
                        "حذف",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      color: Color(0xFF0A3154),
                      onPressed: () {
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'الغاء الحذف',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  SingleChildScrollView dataTable(List<DailyModel> dailyModels) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DataTable(
              columnSpacing: MediaQuery.of(context).size.width/8,
              dividerThickness: 2,
              columns: [
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'الاجمالي',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'الشبكة',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'النقدي',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'اليوم',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
              rows: dailyModels
                  .map(
                    (dailyModel) => DataRow(cells: [
                      DataCell(
                        Expanded(
                          child: Text(
                            (dailyModel.cash + dailyModel.grid).toString(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isUpdating = true;
                            curUserId = dailyModel.id;
                          });
                          controller1.text = dailyModel.grid.toString();
                          controller2.text = dailyModel.cash.toString();
                          controller.text = dailyModel.day.toString();
                          delete();
                        },
                      ),
                      DataCell(
                        Expanded(
                          child: Text(
                            dailyModel.grid.toString(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isUpdating = true;
                            curUserId = dailyModel.id;
                          });
                          controller1.text = dailyModel.grid.toString();
                          controller2.text = dailyModel.cash.toString();
                          controller.text = dailyModel.day.toString();
                          form();
                        },
                      ),
                      DataCell(
                        Expanded(
                          child: Text(
                            dailyModel.cash.toString(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isUpdating = true;
                            curUserId = dailyModel.id;
                          });
                          controller1.text = dailyModel.grid.toString();
                          controller2.text = dailyModel.cash.toString();
                          controller.text = dailyModel.day.toString();
                          form();
                        },
                      ),
                      DataCell(
                        Expanded(
                          child: Text(
                            dailyModel.day.toString(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            isUpdating = true;
                            curUserId = dailyModel.id;
                          });
                          controller1.text = dailyModel.grid.toString();
                          controller2.text = dailyModel.cash.toString();
                          controller.text = dailyModel.day.toString();
                          form();
                        },
                      ),
                    ]),
                  )
                  .toList(),
            ),
            DataTable(headingRowHeight: 0, dividerThickness: 2,
                columns: [
              DataColumn(label: SizedBox()),
              DataColumn(label: SizedBox()),
              DataColumn(label: SizedBox()),
              DataColumn(label: SizedBox()),
            ], rows: [
              DataRow(cells: [
                DataCell(
                  Expanded(
                    child: Text(
                      (sumCash + sumGrid).toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(
                  Expanded(
                    child: Text(
                      sumGrid.toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(
                  Expanded(
                    child: Text(
                      sumCash.toString(),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ),
                DataCell(
                  Expanded(
                    child: Text(
                      'المجموع',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ]),
            ]),
          ],
        ),
      ),
    );
  }

  list() {
    return sumGrid!=null?FutureBuilder(
        future: dailyModels,
        builder: (context, snapshot) {
          if (snapshot.hasData&&null != snapshot.data&&snapshot.data.length != null) {
            return dataTable(snapshot.data);
          }
          else if (null == snapshot.data || snapshot.data.length == 0||!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Center(child: CircularProgressIndicator());
        },
      )
    :Expanded(
      child: Center(child: Text("اضغط على زر الاضافة لاضافة يومية جديدة",style: TextStyle(
        color: Colors.cyan.shade900,
        fontSize: 30,
      ),textDirection: TextDirection.rtl,textAlign: TextAlign.center,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.cyan.shade900,
        title: new Text('إضافة يومية'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: IconButton(
              onPressed: () {
                form();
              },
              icon: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: new Container(
        width: MediaQuery.of(context).size.width,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}
