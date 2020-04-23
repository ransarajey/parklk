import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import './models/slot.dart';


void main() => runApp(Parklk());

class Parklk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'test',
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

  getAll(){

  return Firestore.instance.collection(firestoreCollectionName).snapshots();
}


  Widget buildBody(BuildContext context){

  return StreamBuilder<QuerySnapshot>(
    stream: getAll(),
    builder: (context,snapshot){
      if(snapshot.hasError){
        return Text('Error');
      }
      if(snapshot.hasData){
        print("Documents -> ${snapshot.data.documents}");
        return buildList(context,snapshot.data.documents);
      }
    },
  );
}


Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot){

  return ListView(
    children: snapshot.map((data) => listItemBuild(context,data)).toList(),
  );

}

Widget listItemBuild(BuildContext context, DocumentSnapshot data){

  final slot = Slot.fromSnapshot(data);

  return Padding(
    key: ValueKey(slot.slot),
    padding: EdgeInsets.symmetric(vertical : 3, horizontal: 0),
    child: Container(
        
        decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
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
                  Icon(Icons.directions_car , size: 50, color: slot.availability=="0" ? Colors.green : Colors.red),
                  Text("Parking Slot No: "+ slot.slot, style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ), ),
                ],
                ),
                // Divider(),
                Row(
                  children: <Widget>[
                  // Icon(Icons.person, color: Colors.purple,),
                  // Text(slot.availability),


                ],
                )
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
      resizeToAvoidBottomPadding: false,

      appBar: AppBar(
        title: Text(widget.appTitle),
        actions: <Widget>[

        ],
      ),
      body: Container(
        padding: EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          Text("Welcome to Park.LK", style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800
        ),),
          SizedBox(
            height: 20,
          ),
          Flexible(child: buildBody(context),)


          ],

        ),




      ),
    );
  }
}
