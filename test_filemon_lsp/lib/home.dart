import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:test_filemon_lsp/history.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  myapp createState() => myapp();
}

class myapp extends State<Home> {
  Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  bool _isListenLocation = false, _isGetLocation = false;
  late TextEditingController? _nama;
  late TextEditingController? _keterangan;
  late TextEditingController? _kontributor;
  String? lat;
  String? lon;
  @override
  void initState() {
    super.initState();
    _nama = TextEditingController();
    _keterangan = TextEditingController();
    _kontributor = TextEditingController();
  }

  Kirim() async {
    try {
      var data = FormData.fromMap({
        'aksi': "simpan",
        'nama': _nama.toString(),
        'kontributor': _kontributor.toString(),
        'keterangan': _keterangan.toString(),
        'lat': _locationData.latitude.toString(),
        'lon': _locationData.longitude.toString(),
      });
      var dio = Dio();
      dio.options.headers['content-Type'] = 'application/x-www-form-urlencoded';
      var response = await dio
          .post('https://service.garasitekno.com/lokasi.php', data: data);
      print(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("LSPTest")),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
            height: 60,
            color: Colors.red,
            child: Center(
                child: Text("Filemon Sitanggang",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ),
          SizedBox(height: 10),
          Container(
            height: 60,
            color: Colors.blue,
            child: Center(
                child: Text("Checkin Lokasi",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))),
          ),
          SizedBox(height: 10),
          Container(
              height: 200,
              child: Card(
                elevation: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(children: [
                        Container(
                          child: Row(children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(child: Text("Nama")),
                            ),
                            Container(
                              height: 60,
                              width: 120,
                              child: TextField(
                                controller: _nama,
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: Row(children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                  child: Text(
                                "Keterangan",
                                style: TextStyle(fontSize: 10),
                              )),
                            ),
                            Container(
                              height: 60,
                              width: 120,
                              child: TextField(
                                controller: _keterangan,
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: Row(children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                  child: Text(
                                "Kontributor",
                                style: TextStyle(fontSize: 10),
                              )),
                            ),
                            Container(
                              height: 60,
                              width: 120,
                              child: TextField(
                                controller: _kontributor,
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                    Container(
                      child: Column(children: [
                        Container(
                          child: Row(children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Text("Latitude"),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 120,
                              child: Center(
                                child: Text(_locationData.latitude.toString()),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: Row(children: [
                            Container(
                              height: 60,
                              width: 60,
                              child: Center(
                                child: Text(
                                  "Longitude",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 120,
                              child: Center(
                                child: Text(_locationData.longitude.toString()),
                              ),
                            ),
                          ]),
                        ),
                      ]),
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Kirim();
                    },
                    child: const Text('Kirim'),
                  ),
                ),
                Container(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () async {
                      _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled) {
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          return;
                        }
                      }

                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          return;
                        }
                      }
                      _locationData = await location.getLocation();
                      setState(() {
                        _isGetLocation = true;
                      });
                    },
                    child: const Text('Ambil Lokasi'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 50,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => History()),
                );
              },
              child: const Text('History'),
            ),
          ),
        ],
      )),
    );
  }
}

class postMod {
  final String _url = 'https://service.garasitekno.com/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': "application/x-www-form-urlencoded",
    });
  }
}
