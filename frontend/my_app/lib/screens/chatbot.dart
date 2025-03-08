import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  File? _image;
  final TextEditingController _questionController = TextEditingController();
  bool _loading = false;
  bool _showDisclaimer = true;
  List<Map<String, dynamic>> _messages = [];

  final String apiUrl = "http://10:0:2:2:5000/upload";

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image uploaded successfully.")),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _sendMessage() async {
    if (_image == null || _questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide both an image and a question.")),
      );
      return;
    }

    setState(() {
      _messages.add({"type": "user", "content": _questionController.text, "timestamp": DateTime.now()});
      _loading = true;
    });
    
    try {
      var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath("image", _image!.path));
      request.fields["question"] = _questionController.text;

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = json.decode(await response.stream.bytesToString());
        setState(() {
          _messages.add({"type": "bot", "content": responseData["answer"] ?? "No response from AI.", "timestamp": DateTime.now()});
        });
      } else {
        throw Exception("Failed to get response from server.");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process your request.")),
      );
    } finally {
      setState(() {
        _loading = false;
        _questionController.clear();
      });
    }
  }

  String _formatTime(DateTime timestamp) {
    return "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RaktVeer"),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: _messages.length + (_showDisclaimer ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showDisclaimer && index == 0) {
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "⚠ This chatbot provides general guidance on blood reports and donation. It does *not* replace professional medical advice. Consult a doctor if needed.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                }
                var message = _messages[_showDisclaimer ? index - 1 : index];
                return Align(
                  alignment: message["type"] == "user" ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: message["type"] == "user" ? Colors.red[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(message["content"], style: TextStyle(fontSize: 14)),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            _formatTime(message["timestamp"]),
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_image != null)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _removeImage,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black54,
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: "Ask about the image...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onTap: () => setState(() => _showDisclaimer = false),
                  ),
                ),
                IconButton(
                  icon: _loading ? CircularProgressIndicator() : Icon(Icons.send, color: Colors.red),
                  onPressed: _loading ? null : _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}