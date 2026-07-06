import 'package:cgcflutter/databaseExample/FirebaseService.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'employee.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseService service = FirebaseService();

  final nameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  void addData(){

    String id=DateTime.now().millisecondsSinceEpoch.toString();

    Employee employee=Employee(
      id: id,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
    );

    service.addEmployee(employee);

    nameController.clear();
    phoneController.clear();
    emailController.clear();

  }

  void update(Employee employee){

    nameController.text=employee.name;
    phoneController.text=employee.phone;
    emailController.text=employee.email;

    showDialog(
        context: context,
        builder: (_){

          return AlertDialog(

            title: const Text("Update"),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),

                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                  ),
                ),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),

              ],
            ),

            actions: [

              TextButton(
                onPressed: (){

                  Employee emp=Employee(
                    id: employee.id,
                    name: nameController.text,
                    phone: phoneController.text,
                        email: emailController.text,
                  );

                  service.updateEmployee(emp);

                  Navigator.pop(context);

                },
                child: const Text("Update"),
              )

            ],
          );

        });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Firebase CRUD"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(

          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
              ),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: addData,
              child: const Text("Add Employee"),
            ),

            const Divider(),

            Expanded(

              child: StreamBuilder<DatabaseEvent>(

                stream: service.getEmployees(),

                builder: (context,snapshot){

                  if(!snapshot.hasData){

                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  }

                  final data=snapshot.data!.snapshot.value;

                  if(data==null){

                    return const Center(
                      child: Text("No Data"),
                    );

                  }

                  Map map=data as Map;

                  List<Employee> employees=[];

                  map.forEach((key, value) {

                    employees.add(Employee.fromJson(
                        Map<String,dynamic>.from(value)));

                  });

                  return ListView.builder(

                    itemCount: employees.length,

                    itemBuilder: (_,index){

                      Employee emp=employees[index];

                      return Card(

                        child: ListTile(

                          title: Text(emp.name),

                          subtitle: Text(
                              "${emp.phone}\n${emp.email}"
                          ),

                          isThreeLine: true,

                          trailing: Row(

                            mainAxisSize: MainAxisSize.min,

                            children: [

                              IconButton(

                                icon: const Icon(Icons.edit),

                                onPressed: (){
                                  update(emp);
                                },

                              ),

                              IconButton(

                                icon: const Icon(Icons.delete,color: Colors.red),

                                onPressed: (){
                                  service.deleteEmployee(emp.id);
                                },

                              )

                            ],

                          ),

                        ),

                      );

                    },

                  );

                },

              ),

            )

          ],

        ),

      ),

    );

  }

}