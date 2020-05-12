import 'dart:convert';

import 'package:contoh/model/response_barang_model.dart';
import 'package:contoh/model/response_post_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final _host = 'http://192.168.100.24/server_inventory/index.php/api';

  //METHOD READ BARANG
  static Future<List<Barang>> getListBarang() async {
    //karena object barang berbentuk list, maka dibuat list
    List<Barang> listBarang = [];
    //get selalu bersifat future, simpan pada response
    final response = await http.get('$_host/getbarang'); //data json

    //cek respon status
    if (response.statusCode == 200) {
      //ambil data response.body kemudian convert nilai response.body dengan jsonDecode
      //simpan data pada final json
      final json = jsonDecode(response.body);
      //convert data json menjadi class sehingga dapat diolah
      //responsebarang nanti dapat diolah
      ResponseBarang respBarang = ResponseBarang.fromJson(json);
      //karena responsebarang berupa list maka lakukan perulangan
      respBarang.barang.forEach((item) {
        listBarang.add(item);
      });

      return listBarang;
    } else {
      return [];
    }
  }

  //METHOD CREATE
  Future<ResponsePost> postBarang(nama, jumlah, gambar) async {
    //membuat method post lalu simpan pada final response
    final response = await http.post('$_host/insertbarang',
        //untuk melakukan POST maka format body harus disesuaikan dengan json
        body: {
          'nama': nama, // 'nama' sebelah kiri harus sesuai dengan nama json
          'jumlah': jumlah, //
          'gambar': gambar //
        });

    if (response.statusCode == 200) {
      ResponsePost responseRequest =
          ResponsePost.fromJson(jsonDecode(response.body));

      return responseRequest;
    } else {
      return null;
    }
  }

  //METHOD UPDATE dengan method POS
  //yang membedakan update data dan create adalah id
  Future<ResponsePost> updateBarang(id, nama, jumlah, gambar) async {
    final response = await http.post('$_host/updatebarang',
        body: {"id": id, 'nama': nama, 'jumlah': jumlah, 'gambar': gambar});

    if (response.statusCode == 200) {
      ResponsePost responseRequest =
          ResponsePost.fromJson(jsonDecode(response.body));
      return responseRequest;
    } else {
      return null;
    }
  }

  //METHOD DELETE
  Future<ResponsePost> delBarang(id) async {
    //delet barang hanya membutuhkan id-nya saja
    final response = await http.post('$_host/deletebarang', body: {'id': id});

    if (response.statusCode == 200) {
      ResponsePost responseRequest =
          ResponsePost.fromJson(jsonDecode(response.body));

      return responseRequest;
    } else {
      return null;
    }
  }
}
