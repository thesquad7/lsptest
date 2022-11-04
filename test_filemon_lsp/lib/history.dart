import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<BarangIndex>> fetchBarang() async {
  final res = await http.get(
    Uri.parse('https://service.garasitekno.com/lokasi.php'),
  );
  if (res.statusCode == 200) {
    List jsonResponse = (json.decode(res.body) as Map<String, dynamic>)["data"];
    return jsonResponse.map((data) => BarangIndex.fromJson(data)).toList();
  } else {
    throw Exception('Barang Kosong');
  }
}

class BarangIndex {
  final String id, name, keterangan, kontributor, lat, lon;

  BarangIndex(
      {required this.id,
      required this.name,
      required this.keterangan,
      required this.kontributor,
      required this.lat,
      required this.lon});

  factory BarangIndex.fromJson(Map<String, dynamic> json) {
    return BarangIndex(
      id: json['id'],
      name: json['nama'],
      lat: json['lat'],
      lon: json['lon'].toString(),
      keterangan: json['keterangan'],
      kontributor: json['kontributor'],
    );
  }
}

class History extends StatefulWidget {
  @override
  State<History> createState() => history();
}

class history extends State<History> {
  late final Future<List<BarangIndex>> details;

  @override
  void initState() {
    super.initState();
    details = fetchBarang();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text('History')),
        ),
        body: Center(
          child: FutureBuilder<List<BarangIndex>>(
              future: details,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<BarangIndex>? details = snapshot.data;
                  return ListView.builder(
                      itemCount: details!.length,
                      itemBuilder: (BuildContext context, index) {
                        final detail = details[index];
                        return Card(
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
                                        child: Center(child: Text(detail.name)),
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
                                        child: Center(
                                            child: Text(detail.keterangan)),
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
                                        child: Center(
                                            child: Text(detail.kontributor)),
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
                                          child:
                                              Center(child: Text(detail.lat)),
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
                                          child:
                                              Center(child: Text(detail.lon)),
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
                                            "id",
                                            style: TextStyle(fontSize: 11),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 60,
                                        width: 120,
                                        child: Center(
                                          child: Center(child: Text(detail.id)),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        );
                      });
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Harap Hubungkan Koneksi"));
                }
                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
