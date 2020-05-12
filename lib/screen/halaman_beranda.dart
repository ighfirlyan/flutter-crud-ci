import 'package:contoh/model/response_barang_model.dart';
import 'package:contoh/service/api_service.dart';
import 'package:contoh/widgets/item_barang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'halaman_tambah_edit.dart';

class HalamanBeranda extends StatelessWidget {
  static const String id = "HALAMANBERANDA";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Inventory'),
      ),
      body: GridBarang(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HalamanTambahEdit(
                        barang: null,
                      )));
        },
      ),
    );
  }
}

class GridBarang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            //Karena bersifat future maka memakai future builder,
            child: FutureBuilder<List<Barang>>(
              //memanggil method future yang akan dijalankan
              //agar tidak perlu membuat instance maka getlist barang di class api_service harus dijadikan static
              //karena getlistBarang mengembalikan nilai list barang maka tambahkan <List<Barang>> pada future builder
              future: ApiService.getListBarang(),
              builder: (context, snapshot) {
                //snapshot untuk mengambil state connection
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  //list barang diambil dari snapshot data, snapshot data dari getlistbarang
                  List<Barang> listBarang = snapshot.data;

                  //membuat gridview dengan tampilan 2 item perbaris
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    //ketika length null maka diset 0
                    itemCount: listBarang?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      //membuat efek inkwell
                      return InkWell(
                        splashColor: Colors.indigo,
                        borderRadius: BorderRadius.circular(10.0),
                        child: itemBarang(listBarang[index]),
                        //ketika item barang diklik maka, melakukan perpindahan halaman
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HalamanTambahEdit(
                                      barang: listBarang[index])));
                        },
                      );
                    },
                  );
                }
              },
            )));
  }
}
