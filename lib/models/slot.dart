import 'package:cloud_firestore/cloud_firestore.dart';

class Slot {

  String availability;
  String slot;

  DocumentReference documentReference;

  Slot({this.availability, this.slot});

  Slot.fromMap(Map<String,dynamic> map, {this.documentReference}){

    availability = map["availability"];
    slot = map["slot"];

  }

  Slot.fromSnapshot(DocumentSnapshot snapshot)
  :this.fromMap(snapshot.data, documentReference: snapshot.reference);

  toJson(){
    return {'availability': availability, 'slot': slot};
  }
}