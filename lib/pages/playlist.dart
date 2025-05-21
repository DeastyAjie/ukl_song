import 'package:flutter/material.dart';
import 'package:song/models/song_playlist.dart';
import 'package:song/services/playlist_service.dart';
import 'package:song/pages/song_list.dart';
import 'package:song/models/user_login.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  late Future<List<Playlist>> _playlists;
  UserLogin? userLogin;

  @override
  void initState() {
    super.initState();
    _playlists = PlaylistService.fetchPlaylists();
    _getUser();
  }

  void _getUser() async {
    var user = await UserLogin.getUser();
    setState(() {
      userLogin = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Playlist>>(
        future: _playlists,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final playlists = snapshot.data ?? [];

          if (playlists.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Selamat datang, ${userLogin?.username ?? 'pengguna'}!",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text("Belum ada playlist tersedia."),
                ],
              ),
            );
          }

          final isShortList = playlists.length <= 4;

          final content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Selamat datang, ${userLogin?.username ?? 'pengguna'}!",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              ...playlists.map((playlist) => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      leading: const Icon(Icons.music_note, color: Colors.red),
                      title: Text(
                        playlist.playlistName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text("${playlist.songCount} songs"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongListPage(
                              playlistId: playlist.uuid,
                              playlistName: playlist.playlistName,
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            ],
          );

          return isShortList
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top,
                      ),
                      child: IntrinsicHeight(
                        child: content,
                      ),
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [content],
                );
        },
      ),
    );
  }
}
