import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/http_appwrite_service.dart';
import '../../../../core/utils/config.dart';

class CommunityPostForm extends StatefulWidget {
  const CommunityPostForm({super.key});

  @override
  CommunityPostFormState createState() => CommunityPostFormState();
}

class CommunityPostFormState extends State<CommunityPostForm> {
  final _formKey = GlobalKey<FormState>();
  final _postTitleController = TextEditingController();
  final _contentController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _authorTitleController = TextEditingController();
  final _pollQuestionController = TextEditingController();
  final _pollOptionController = TextEditingController();
  final List<String> _pollOptions = [];
  File? _selectedImage;

  @override
  void dispose() {
    _postTitleController.dispose();
    _contentController.dispose();
    _authorNameController.dispose();
    _authorTitleController.dispose();
    _pollQuestionController.dispose();
    _pollOptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
  }

  Future<String?> _uploadImage(AppwriteService appwriteService) async {
    if (_selectedImage == null) return null;

    final response = await appwriteService.uploadFile(
      bucketId: appwriteBucketId,
      file: _selectedImage!,
      fileId: 'unique()',
    );

    final fileId = response['\$id'];
    return '${appwriteService.endpoint}/storage/buckets/$appwriteBucketId/files/$fileId/view?project=$appwriteProjectId&mode=admin';
  }

  void _addPollOption() {
    if (_pollOptionController.text.isNotEmpty) {
      setState(() {
        _pollOptions.add(_pollOptionController.text);
        _pollOptionController.clear();
      });
    }
  }

  void _submitForm() async {
    final currentContext = context;

    if (_formKey.currentState!.validate()) {
      try {
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Adding post...')),
        );

        final appwriteService = AppwriteService();

        final imageUrl = await _uploadImage(appwriteService);
        if (!mounted) return;

        if (imageUrl == null) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(content: Text('Failed to upload image.')),
          );
          return;
        }

        final formattedPollOptions = _pollOptions
            .map((option) => {'option': option, 'votes': 0})
            .toList();

        final dataObj = {
          'postTitle': _postTitleController.text,
          'content': _contentController.text,
          'imageUrl': imageUrl,
          'authorName': _authorNameController.text,
          'authorTitle': _authorTitleController.text,
          'pollQuestion': _pollQuestionController.text,
          'pollOptions': jsonEncode(formattedPollOptions),
        };

        await appwriteService.createDocument(
          collectionId: "posts",
          data: dataObj,
          documentId: 'unique()',
        );

        if (!mounted) return;

        ScaffoldMessenger.of(currentContext).clearSnackBars();
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Post added successfully!')),
        );
        Navigator.of(currentContext).pop();
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(currentContext).showSnackBar(
          SnackBar(content: Text('Error adding post: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Select Image'),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Selected Image: ${_selectedImage!.path}'),
                ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _postTitleController,
                decoration: const InputDecoration(labelText: 'Post Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a post title'
                    : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter content for the post'
                    : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _authorNameController,
                decoration: const InputDecoration(labelText: 'Author Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the author name'
                    : null,
              ),
              TextFormField(
                controller: _authorTitleController,
                decoration: const InputDecoration(labelText: 'Author Title'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter the author title'
                    : null,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _pollQuestionController,
                  decoration: const InputDecoration(
                    labelText: 'Poll Question',
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a poll question'
                      : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _pollOptionController,
                  decoration: const InputDecoration(
                    labelText: 'Poll Option',
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ElevatedButton(
                  onPressed: _addPollOption,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
                  ),
                  child: const Text(
                    'Add Poll Option',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              if (_pollOptions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Poll Options:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ..._pollOptions.map((option) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 5,
                        child: ListTile(
                          title: Text(option,
                              style: const TextStyle(fontSize: 16)),
                          trailing: const Icon(Icons.check_circle,
                              color: Colors.green),
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
