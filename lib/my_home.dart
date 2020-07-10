import 'package:accounting/daily/daily.dart';
import 'package:accounting/expenses/expenses.dart';
import 'package:accounting/other/other.dart';
import 'package:accounting/purchasing/purchasing.dart';
import 'package:accounting/worker_debt/workers_dept.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(12),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0A3154),
              ),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "تطبيق ادارة حسابات",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 133),
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  buildCard(
                    "اليومية",
                    context,
                    (context) => new Daily(),
                    Icons.event_note,
                    Colors.cyan.shade900,
                  ),
                  buildCard(
                    "المشتريات",
                    context,
                    (context) => new Purchasing(),
                    Icons.attach_money,
                    Colors.amber,
                  ),
                  buildCard(
                    "المصروفات",
                    context,
                    (context) => new Expenses(),
                    Icons.play_for_work,
                    Colors.pink.shade800,
                  ),
                  buildCard(
                    "الشبكة",
                    context,
                    (context) => new Other(),
                    Icons.work,
                    Colors.brown,
                  ),  buildCard(
                    "ديون العمال",
                    context,
                        (context) => new WorkersDept(),
                    Icons.money_off,
                    Colors.purple.shade900,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

InkWell buildCard(
    String myText, BuildContext context, builder, IconData icon, Color color) {
  return InkWell(
    borderRadius: BorderRadius.circular(60),
    splashColor: Colors.blueGrey,
    onTap: () {
      Navigator.push(context, new MaterialPageRoute(builder: builder));
    },
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(width: 3, color: Color(0xff0a3154))),
      width: double.infinity,
      height: 90,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          Text(
            myText,
            style: TextStyle(
                color: const Color(0xFF0A3154),
                fontWeight: FontWeight.bold,
                fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
