
class Employee{
  String id;
  String name;
  String email;
  String phone;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phone});

  factory Employee.fromJson(Map data){
    return Employee(

      id: data['id'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
        );

    }
    Map<String,dynamic>toJson(){
    return{
      'id':id,
      'name':name,
      'email':email,
      'phone':phone,
    };
  }


}