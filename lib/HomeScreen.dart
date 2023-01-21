import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:test_2/Album.dart';

import 'package:test_2/photo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Album> albumList = [];
  Future<List<Album>> fetchData() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var parsed =
            convert.jsonDecode(response.body).cast<Map<String, dynamic>>();
        albumList = parsed.map<Album>((json) => Album.fromJson(json)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return albumList;
  }

  // late List<Service>? _userModel = [];
  List<Photo> serViceList = [];
  Future<List<Photo>> getUsers() async {
    try {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
      var response = await http.get(url);
      log(response.statusCode.toString());

      if (response.statusCode == 200) {
        final parsed =
            convert.jsonDecode(response.body).cast<Map<String, dynamic>>();
        log(parsed.toString());
        serViceList =
            parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return serViceList;
  }

  @override
  void initState() {
    getUsers();
    fetchData();
    setState(() {});
    super.initState();
  }

  // void _getData() async {
  //   _userModel = (await ApiService().getUsers());
  //   Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeScreen')),
      body: FutureBuilder<List<Photo>>(
          future: getUsers(),
          builder: (BuildContext context, snapShot) {
            if (snapShot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  itemCount: snapShot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(serViceList[index].url)),
                          title: Text(serViceList[index].title),
                          subtitle: Text(serViceList[index].thumbnailUrl),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}
