import 'DBHelperExpenses.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'expenses_model.dart';
import 'dart:async';
class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  //
  Future<List<ExpensesModel>> expensesModels;
  TextEditingController controller_name = TextEditingController();
  TextEditingController controller_price = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  int id;
  String details;
  int price;
  int curUserId;

  final formKey = new GlobalKey<FormState>();
  DBHelper dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      expensesModels = dbHelper.getExpensesModel();
    });
  }

  clearName() {
    controller_name.text = '';
    controller_price.text = '';
  }

  validate() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        ExpensesModel e = ExpensesModel(
          curUserId,
          price,
          details,
        );
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        ExpensesModel e = ExpensesModel(
          null,
          price,
          details,
        );
        dbHelper.save(e);
      }
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
        isUpdating ? 'تعديل مصروفات حالية' : 'اضافة مصروفات جديدة',
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
              children: <Widget>[ TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_price,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'ادخل السعر'),
                  validator: (val) =>
                  val.length == 0 ? 'ادخل السعر' : null,
                  onSaved: (val) {
                    price = int.parse(val);
                  }),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_name,
                  keyboardType: TextInputType.text,
                  maxLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Color(0xFF0A3154),
                            width: 2,
                          )),
                      labelText: 'تفاصيل المصروف'),
                  validator: (val) => val.length == 0 ? 'اذخل تفاصيل المصروف' : null,
                  onSaved: (val) => details = val,
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
              children: <Widget>[            TextFormField(
                textDirection: TextDirection.rtl,
                controller: controller_price,
                readOnly: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2,
                        )),
                    labelText: 'السعر'),
              ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  controller: controller_name,
                  maxLines: 10,
                  readOnly: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                      labelText: 'المصروف'),
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
                        ExpensesModel purchasingModel = ExpensesModel(
                          curUserId,
                          price,
                          details,
                        );
                        dbHelper.delete(purchasingModel.id);
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
        future: dbHelper.allExpenses(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ExpensesModel purchasingModel =
                  ExpensesModel.fromMap(snapshot.data[index]);
                  return ListTile(
                    title: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(top: 15, left: 8, right: 8,bottom: 15),
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
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.green,
                                  onPressed: () {setState(() {
                                    isUpdating = true;
                                    curUserId = purchasingModel.id;
                                  });
                                  controller_name.text = purchasingModel.details;
                                  controller_price.text = purchasingModel.price.toString();
                                  form();}),
                              Expanded(
                                child: Text(
                                  "السعر\n" + purchasingModel.price.toString(),
                                  style: TextStyle(fontSize: 18,color: Colors.white),
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
                                      curUserId = purchasingModel.id;
                                    });
                                    controller_name.text = purchasingModel.details;
                                    controller_price.text = purchasingModel.price.toString();
                                    delete();
                                  }),
                            ],
                          ),
                          SizedBox(height: 5,),
                          SizedBox(
                            width: 200,
                            height: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                          SizedBox(height: 8,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[

                              Expanded(
                                child: Text(
                                  "التفاصيل\n" +
                                      purchasingModel.details,
                                  style: TextStyle(fontSize: 18,color: Colors.white),
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }

          else if (null == snapshot.data || snapshot.data.length == 0||price==null) {
            return Center(child: Text("اضغط على زر الاضافة لاضافة مصروفات جديدة",style: TextStyle(
              color: Colors.purple.shade900,
              fontSize: 30,
            ),textDirection: TextDirection.rtl,textAlign: TextAlign.center,));
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
        backgroundColor: Colors.pink.shade800,
        title: new Text('المصروفات'),
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
