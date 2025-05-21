import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:song/models/song.detail.dart';

class SongDetailService{
  static Future<SongDetail> fetchSongDetail(String songId) async {
    final response = await http.get(
      Uri.parse('https://learn.smktelkom-mlg.sch.id/ukl2/playlists/song/$songId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return SongDetail.fromJson(data);
    } else {
      throw Exception("Failed to load song detail");
    }
  }
}