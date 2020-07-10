import 'DBHelperPurchasing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'purchasing_model.dart';
import 'dart:async';
class Purchasing extends StatefulWidget {
  @override
  _PurchasingState  createState() => _PurchasingState();
}

class _PurchasingState extends State<Purchasing> {
  //
  Future<List<PurchasingModel>> purchasingModels;
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
      purchasingModels = dbHelper.getPurchasingModels();
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
        PurchasingModel e = PurchasingModel(
          curUserId,
          price,
          details,
        );
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        PurchasingModel e = PurchasingModel(
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
        isUpdating ? 'تعديل مشتريات حالية' : 'اضافة مشتريات جديدة',
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
                      labelText: 'ادخل سعر الشراء'),
                  validator: (val) =>
                  val.length == 0 ? 'ادخل سعر الشراء' : null,
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
                      labelText: 'تفاصيل المشترى'),
                  validator: (val) => val.length == 0 ? 'اذخل تفاصيل المشترى' : null,
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
                      labelText: 'المشترى'),
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
                        PurchasingModel purchasingModel = PurchasingModel(
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
        future: dbHelper.allPurchasing(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  PurchasingModel purchasingModel =
                  PurchasingModel.fromMap(snapshot.data[index]);
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
                                  "سعر المشترى\n" + purchasingModel.price.toString(),
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
                                  "الوصف\n" +
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
            return Expanded(
              child: Center(child: Text("اضغط على زر الاضافة لإضافة عمليات شراء جديدة",style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 30,
              ),textDirection: TextDirection.rtl,textAlign: TextAlign.center,)),
            );
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
        backgroundColor: Colors.amber.shade900,
        title: new Text('المشتريات'),
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
