import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:song/models/add_song.dart';
import 'package:song/services/adds_song_service.dart';

class AddSongPage extends StatefulWidget {
  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _sourceController = TextEditingController();
  File? _imageFile;
  final _service = AddSongService();

  Future<void> _pickThumbnail() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final size = await file.length();
      if (size <= 2 * 1024 * 1024) {
        setState(() => _imageFile = file);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File too large. Max size is 2MB.')),
        );
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tambahkan thumbnail nya')),
      );
      return;
    }

    final song = AddSong(
      title: _titleController.text,
      artist: _artistController.text,
      description: _descriptionController.text,
      source: _sourceController.text.isEmpty ? 'www.youtube.com' : _sourceController.text,
    );

    final success = await _service.uploadSong(song, _imageFile);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Song saved!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload song')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new song')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v!.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _artistController,
                decoration: InputDecoration(labelText: 'Artist'),
                validator: (v) => v!.isEmpty ? 'Please enter artist name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Please enter description' : null,
              ),
              TextFormField(
                controller: _sourceController,
                decoration: InputDecoration(labelText: 'Source'),
                validator: (v) => v!.isEmpty ? 'Please enter source' : null,
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Add thumbnail ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickThumbnail,
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _imageFile == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.upload_file, size: 30, color: Colors.grey),
                                  Text(
                                    'Tambahkan file',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Save Song'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
