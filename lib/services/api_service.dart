import 'dart:convert';
import 'package:http/http.dart' as http;
 

class ApiService {
  
  final String _apiKey =
      "qg9SK8l3uTACyTFMrRLenb6Otto1wmJdd83iWMlpuHHQN4PWv9wqrYxm";

  Future<List<String>> fetchGameImages(String query, int adet) async {
    var url = Uri.parse(
      "https://api.pexels.com/v1/search?query=$query&per_page=$adet",
    );

    try {
      var res = await http.get(
        url,
        headers: {
          'Authorization': _apiKey,
        }, 
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        List<dynamic> photos = data['photos'];

        return photos.map((item) => item['src']['medium'] as String).toList();
      }

      print("Hata kodu: ${res.statusCode}");
    } catch (e) {
      print("Bağlantı hatası: $e");
    }

    return [];
  }
}
