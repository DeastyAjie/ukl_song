// user.dart (UserService disesuaikan dengan soal UKL)

import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> loginUser(Map<String, String> data) async {
    var uri = Uri.parse('https://dummyjson.com/auth/login');

    try {
      var response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': data['username'],
          'password': data['password'],
        }),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        return {
          "status": true,
          "message": "Login berhasil sebagai ${result['username']}",
          "data": result,
        };
      } else {
        return {
          "status": false,
          "message": "Username atau password salah."
        };
      }
    } catch (e) {
      return {
        "status": false,
        "message": "Terjadi kesalahan: $e"
      };
    }
  }
}
