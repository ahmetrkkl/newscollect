  import 'package:flutter/material.dart';
  import 'package:news/services/pharmacy_api_service.dart';
  import '../models/general_pharmacy_result.dart';

  class PharmacyPage extends StatefulWidget {
    const PharmacyPage({Key? key}) : super(key: key);

    @override
    PharmacyPageState createState() => PharmacyPageState();
  }

  class PharmacyPageState extends State<PharmacyPage> {
    late Future<List<GeneralPharmacyResult>> _pharmacyFuture;

    @override
    void initState() {
      super.initState();
      _pharmacyFuture = _fetchPharmacy();
    }

    Future<List<GeneralPharmacyResult>> _fetchPharmacy() async {
      PharmacyApiService apiService = PharmacyApiService();
      return await apiService.fetchPharmacy();
    }
    Future<void> _refreshPharmacy() async {
      setState(() {
        _pharmacyFuture = _fetchPharmacy();
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Nöbetçi Eczane'),
          backgroundColor: Colors.orange[700],
        ),
      body: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
      gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.orange.shade200, Colors.orange.shade200],
      ),
      ),
      child: RefreshIndicator(
      color: Colors.blue,
      onRefresh: _refreshPharmacy,
      child: FutureBuilder<List<GeneralPharmacyResult>>(
      future: _pharmacyFuture,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(
      child: CircularProgressIndicator(),
      );
      } else if (snapshot.hasError) {
      return Center(
      child: Text('Hata: ${snapshot.error}'),
      );
      } else {
      if (snapshot.hasData) {
      List<GeneralPharmacyResult>? weatherList = snapshot.data;
      return ListView.builder(
      itemCount: weatherList!.length,
      itemBuilder: (context, index) {
      GeneralPharmacyResult pharmacyItem = weatherList[index];
                      return Card(
                        color: Colors.orange.shade400,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            '${pharmacyItem.name ?? ''} ECZANESİ',
                            style: const TextStyle(
                              color: Color.fromRGBO(140, 9, 9, 100),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pharmacyItem.address ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                  '0${pharmacyItem.phone ?? ''} ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                pharmacyItem.dist ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text('No data available.'),
                  );
                }
              }
            },
          ),
        ),
      ),
      );
    }
  }