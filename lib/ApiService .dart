import 'dart:convert' as convert;
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = 'https://jsonplaceholder.typicode.com';
  static String usersEndpoint = '/users';
}

class ApiService {
  Future<List<Service>?> getUsers() async {
    List<Service> serViceList = [];
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final parsed =
            convert.jsonDecode(response.body).cast<Map<String, dynamic>>();
        log(parsed.toString());
        serViceList =
            parsed.map<Service>((json) => Service.fromJson(json)).toList();
        return serViceList;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class Service {
  late int id;
  late String name;
  late String username;
  late String email;
  late String phone;
  late String website;

  Service(
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.website,
  );

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;

    data['phone'] = phone;
    data['website'] = website;

    return data;
  }
}
