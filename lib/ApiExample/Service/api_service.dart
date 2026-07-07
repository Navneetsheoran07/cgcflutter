import 'dart:convert';
import 'dart:math';



import 'package:cgcflutter/ApiExample/Service/api_constant.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';


class ApiService {
  Future<List<UserModel>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstant.baseUrl + ApiConstant.users);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<UserModel> _model = userModelFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString() as num);
    }
  }



}
