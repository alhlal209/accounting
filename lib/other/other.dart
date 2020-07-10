import 'package:accounting/other/other_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DBHelperOther.dart';

class Other extends StatefulWidget {
  @override
  _OtherState createState() => _OtherState();
}

class _OtherState extends State<Other> {
  Future<List<OtherModel>> OtherModels;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_salary = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  bool up ;
  int salary;
  String date;
  String currentdate;
  int curUserId;

  final formKey = new GlobalKey<FormState>();
  DBHelper dbHelper;
  bool isUpdat;

  getCurrentDate() {
    var date1 = new DateTime.now().toString();

    var dateParse = DateTime.parse(date1);

    var formattedDate = "${dateParse.day}-${dateParse.month}-${dateParse.year}";

    setState(() {
       currentdate = formattedDate.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdat = false;
     up = true;
    refreshList();
    getCurrentDate();
  }

  refreshList() {
    setState(() {
      OtherModels = dbHelper.getOtherModels();
    });
  }

  clearName() {
    controller_name.text = '';
    controller_salary.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdat) {
        OtherModel e = OtherModel(
          curUserId,
          salary,
//          up,
          date,
        );
        dbHelper.update(e);
        setState(() {
          isUpdat = false;
          up=true;
        });
      } else {
        OtherModel e = OtherModel(
          null,
          salary,
//          up,
          date,
        );
        dbHelper.save(e);
      }
      clearName();
      refreshList();
      getCurrentDate();
      Navigator.of(context).pop();
    }
  }

  var value;
  var _character;
  var value2;

  void form() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        isUpdat ? 'تعديل العملية' : 'اضافة عملية جديدة',
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
                    controller: controller_salary,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: Color(0xFF0A3154),
                              width: 2,
                            )),
                        labelText: 'ادخل المبلغ'),
                    validator: (val) => val.length == 0 ? 'ادخل المبلغ' : null,
                    onSaved: (val) {
                      salary = int.parse(val);
                      date = currentdate;
                    }),
                SizedBox(
                  height: 8,
                ),
                RadioListTile<String>(
                  title: const Text('سحب'),
                  value: value,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value;
                      up=true;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('ايداع'),
                  value: value2,
                  groupValue: _character,
                  onChanged: (value) {
                    setState(() {
                      _character = value;
                      up=false;
                    });
                  },
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
                        isUpdat ? 'تعديل' : 'اضافة',
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
                          isUpdat = false;
                        });
                        clearName();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        isUpdat ? 'الغاء التعديل' : 'الغاء',
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
        "هل تريد الحذف",
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
                  controller: controller_salary,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
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
                        OtherModel otherModel = OtherModel(
                          curUserId,
                          salary,
//                          up,
                          date,
                        );
                        dbHelper.delete(otherModel.id);
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

  list() {
    return Expanded(
      child: FutureBuilder(
        future: dbHelper.allOthers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  OtherModel otherModel =
                      OtherModel.fromMap(snapshot.data[index]);
                  return ListTile(
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(
                          top: 15, left: 8, right: 8, bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          isUpdat = true;
                                          up=false;
                                          curUserId = otherModel.id;
                                          date=otherModel.date;
                                        });
                                        controller_salary.text =
                                            otherModel.salary.toString();
                                        form();
                                      }),
                                otherModel.salary<5000?  IconButton(
                                      icon: Icon(Icons.arrow_upward),
                                      color: Colors.green,
                                      onPressed: () {
                                        setState(() {
                                          isUpdat = true;
                                          up=false;
                                          curUserId = otherModel.id;
                                        });
                                        controller_salary.text =
                                            otherModel.salary.toString();
                                        form();
                                      }): IconButton(
                                    icon: Icon(Icons.arrow_downward),
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      setState(() {
                                        isUpdat = true;
                                        up=false;
                                        curUserId = otherModel.id;
                                      });
                                      controller_salary.text =
                                          otherModel.salary.toString();
                                      form();
                                    }),
                                ],
                              ),
                              Expanded(
                                child: Text(
                                  "المبلغ\n" + otherModel.salary.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "التاريخ\n" + otherModel.date.toString(),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.redAccent,
                                  onPressed: () {
                                    setState(() {
                                      isUpdat = true;
                                      curUserId = otherModel.id;
                                    });
                                    controller_salary.text =
                                        otherModel.salary.toString();
                                    delete();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else if (null == snapshot.data || snapshot.data.length == 0||salary==null) {
            return Center(child: Text("لا توجد بيانات"));
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.brown,
        title: new Text('الشبكة'),
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
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[list()],
        ),
      ),
    );
  }
}
