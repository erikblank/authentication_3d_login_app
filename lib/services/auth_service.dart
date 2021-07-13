import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  static Future<Map<String, dynamic>> getGoogleCode() async {
    final response = await http.get(
        Uri.parse("https://aue-3d-auth.herokuapp.com/api/auth/google-code"));
    print(response.body);

    if (response.statusCode == 200) {
      // if response is successful then parse json
      return jsonDecode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to fetch data from server');
    }
  }

  static Future<void> authenticateWithCube(Map<String, dynamic> data) async {
    final response = await http.post(
        Uri.parse("https://aue-3d-auth.herokuapp.com/api/auth/cube-status"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
    if (response.statusCode != 200) {
      throw Exception("Server error");
    }
  }
}
