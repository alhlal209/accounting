import 'package:accounting/worker_debt/DBHelperWorker.dart';
import 'package:flutter/cupertino.dart';
import 'DBHelperWorker.dart';
import 'take_model.dart';
import 'workers_dept_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class WorkersDoptDetails extends StatefulWidget {
  WorkersDoptModel workersDoptModel;

  WorkersDoptDetails(this.workersDoptModel);

  @override
  _WorkersDoptDetailsState createState() => _WorkersDoptDetailsState();
}

class _WorkersDoptDetailsState extends State<WorkersDoptDetails> {
  Future<List<TakeModel>> takeModels;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_mony_takeen = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  int idtake;
  int foreignkey;
  int quantity;
  String date;
  String currentdate;
  int remain;
  int sumTake;

  final formKey = new GlobalKey<FormState>();

  Future<List<TakeModel>> takeModel;

  DBHelper dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
    sum();
    getCurrentDate();
  }

  refreshList() {
    setState(() {
      takeModel = dbHelper.getWorkerDetails();
    });
  }

  getCurrentDate() {
    var date1 = new DateTime.now().toString();

    var dateParse = DateTime.parse(date1);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    setState(() {
      currentdate = formattedDate.toString();
    });
  }

  sum() {
    dbHelper.sumTake().then((value) {
      setState(() {
        sumTake = null ? sumTake = 0 : sumTake = value;
      });
    });
  }

  clearName() {
    controller_name.text = '';
    controller_mony_takeen.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        TakeModel takeModel =
            TakeModel(idtake, quantity, date, foreignkey);
        dbHelper.updateDetails(takeModel);
        setState(() {
          isUpdating = false;
        });
      } else {
        TakeModel takeModel =
            TakeModel(null, quantity, date, foreignkey);
        dbHelper.saveDetails(takeModel);
      }

      clearName();
      refreshList();
      Navigator.of(context).pop();
    }
  }

  void form1() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        isUpdating ? 'تعديل عملية سحب' : 'اضافة عملية سحب جديدة',
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
                  controller: controller_mony_takeen,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Color(0xFF0A3154),
                          width: 2,
                        ),
                      ),
                      labelText: 'ادخل المبلغ'),
                  validator: (val) => val.length == 0 ? 'المبلغ فارغ' : null,
                  onSaved: (val) {
                    quantity = int.parse(val);
                    date=currentdate;
                    foreignkey = widget.workersDoptModel.id;
                    remain = widget.workersDoptModel.salary;
                  },
                ),
//                - sumTake
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
                        isUpdating ? 'تعديل' : 'اضافة',
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
                        setState(
                          () {
                            isUpdating = false;
                          },
                        );
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

  void delete1() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        "هل تريد حذف هذه العملية",
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
                  controller: controller_mony_takeen,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      labelText: 'المبلغ'),
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
                        TakeModel takeModel = TakeModel(
                            idtake, quantity, date, foreignkey);
                        dbHelper.deleteDetail(takeModel.idtake);
                        Navigator.of(context).pop();
                        clearName();
                        refreshList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(widget.workersDoptModel.name),
        centerTitle: true,
      ), //          Text("data")
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:15,left: 15,right: 15 ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.transparent,
                  border: Border.all(width: 2, color: Colors.black87),
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Text("الراتب :"+
                      widget.workersDoptModel.salary.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("المتبقي :"+
                        widget.workersDoptModel.remain.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),  Text("المسحوب :"+
                        widget.workersDoptModel.takefrom.toString(),
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black87,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "عمليات السحب",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black87, fontSize: 35),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                future: dbHelper.allDetails(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          TakeModel takeModel =
                              TakeModel.fromMap(snapshot.data[index]);
                          return ListTile(
                            title: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.transparent,
                                border:
                                    Border.all(width: 2, color: Colors.black87),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          isUpdating = true;
                                          foreignkey = takeModel.foreignkey;
                                          quantity = takeModel.quantity;
                                          idtake=takeModel.idtake;
                                          date=takeModel.date;
                                        });
                                        controller_mony_takeen.text =
                                            takeModel.quantity.toString();
                                        form1();
                                      }),
                                  Expanded(
                                    child: Text(
                                      "تاريخ السحب\n" + takeModel.date.toString(),
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black87),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "المبلغ المسحوب\n" +
                                          takeModel.quantity.toString(),
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black87),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.redAccent,
                                      onPressed: () {
                          setState(() {
                            isUpdating = true;
                            idtake=takeModel.idtake;
                          });
                          controller_mony_takeen.text =
                              takeModel.quantity.toString();
                          delete1();
                                      }),
                                ],
                              ),
                            ),
                          );
                        });
                  } else if (null == snapshot.data || snapshot.data.length == 0) {
                    return Center(
                        child: Text(
                      "اضغط على زر الاضافة لاضافة عمال جدد",
                      style: TextStyle(
                        color: Colors.purple.shade900,
                        fontSize: 30,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                    ));
                  }

                  return CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form1();
        },
        child: Icon(Icons.money_off),
        backgroundColor: Colors.redAccent,
        tooltip: "خصم من راتب العامل",
      ),
    );
  }
}
