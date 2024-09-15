import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isDetecting = false;
  XFile? _capturedImage;
  String? _imageDescription;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    initializeCamera();
    initializeTTS();
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isNotEmpty) {
      _cameraController =
          CameraController(_cameras![0], ResolutionPreset.medium);
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  void initializeTTS() {
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void captureImage() async {
    if (!_isDetecting) {
      _isDetecting = true;
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = image;
        });
        describeImage(image.path);
      } catch (e) {
        Fluttertoast.showToast(msg: "Error capturing image: $e");
        _isDetecting = false;
      }
    }
  }

  void describeImage(String imagePath) async {
    var client = http.Client();
    try {
      var url =
          'http://10.0.2.2:8000/describe_image'; // Use 10.0.2.2 for Android emulator
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(await http.MultipartFile.fromPath('file', imagePath));

      var response = await client.send(request);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        var json = jsonDecode(responseString);
        _imageDescription = json['description'];
        Fluttertoast.showToast(msg: "Detected information: $_imageDescription");
        if (_imageDescription != null) {
          flutterTts.speak(_imageDescription!);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error calling BLIP service: ${responseString}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to call BLIP service: $e");
    } finally {
      client.close();
      setState(() {
        _isDetecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(child: CircularProgressIndicator());
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      content = CameraPreview(_cameraController!);
      if (_capturedImage != null) {
        content = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
            if (_imageDescription != null)
              Container(
                color: Colors.black54,
                child: Text(
                  _imageDescription!,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      }
    }

    return Scaffold(
      body: content,
      floatingActionButton: _capturedImage == null
          ? FloatingActionButton(
              onPressed: captureImage,
              child: Icon(Icons.camera),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
