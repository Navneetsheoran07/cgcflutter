import 'package:firebase_database/firebase_database.dart';

import 'employee.dart';

class FirebaseService {

  final DatabaseReference ref =
  FirebaseDatabase.instance.ref("Employees");

  Future<void> addEmployee(Employee employee) async {

    await ref.child(employee.id).set(employee.toJson());

  }

  Future<void> updateEmployee(Employee employee) async {

    await ref.child(employee.id).update(employee.toJson());

  }

  Future<void> deleteEmployee(String id) async {

    await ref.child(id).remove();

  }

  Stream<DatabaseEvent> getEmployees(){

    return ref.onValue;

  }

}