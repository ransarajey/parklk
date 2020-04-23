import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './models/slot.dart';

void main() => runApp(Parklk());

class Parklk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'test',
      home: Parklkapp(),
    );
  }
}

class Parklkapp extends StatefulWidget {
  Parklkapp() : super();

  final String appTitle = "Park LK";

  @override
  _ParklkappState createState() => _ParklkappState();
}

class _ParklkappState extends State<Parklkapp> {
  String firestoreCollectionName = "parking";

  Slot currentSlot;

  getAll() {
    return Firestore.instance.collection(firestoreCollectionName).snapshots();
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getAll(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.hasData) {
          print("Documents -> ${snapshot.data.documents}");
          return buildList(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => listItemBuild(context, data)).toList(),
    );
  }

  Widget listItemBuild(BuildContext context, DocumentSnapshot data) {
    final slot = Slot.fromSnapshot(data);

    return Padding(
      key: ValueKey(slot.slot),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          color: slot.availability == "0"
              ? Colors.lightGreen[300]
              : Colors.redAccent[100],
          border: Border.all(
            color: slot.availability == "0" ? Colors.green : Colors.red,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: SingleChildScrollView(
          child: ListTile(
            title: Container(
              // color: slot.availability=="1" ? Colors.red : Colors.green,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.directions_car,
                          size: 40,
                          color: slot.availability == "0"
                              ? Colors.green
                              : Colors.red),
                      Text(
                        "    Parking Slot No: " + slot.slot,
                        style: TextStyle(
                            color: slot.availability == "0"
                                ? Colors.green
                                : Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  // Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.appTitle),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'images/parklk.png',
              height: 100,
            ),
            Text(
              'To find a parking slot',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 8,
            ),
            Flexible(
              child: buildBody(context),
            )
          ],
        ),
      ),
    );
  }
}
