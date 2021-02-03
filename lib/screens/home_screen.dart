import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ImagePicker _imagePicker = ImagePicker();
  File _imageFile;
  List _output;

  @override
  void initState() {
    super.initState();
    _loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
  }

  Future<void> _captureImageFromCamera() async {
    PickedFile selectedFile = await _imagePicker.getImage(
      source: ImageSource.camera,
      maxHeight: 680.0,
      maxWidth: 970.0,
    );
    setState(() {
      _imageFile = File(selectedFile.path);
    });
    _detectImage(_imageFile);
  }

  Future<void> _selectImageFromGallery() async {
    PickedFile selectedFile =
        await _imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(selectedFile.path);
    });
    _detectImage(_imageFile);
  }

  Future<void> _detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
    });
  }

  Future<void> _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: [
            SizedBox(height: 50.0),
            Text(
              'Code With Waqar',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            SizedBox(height: 5.0),
            Text(
              'Cat & Dog Detector App',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 50.0),
            Center(
              child: _imageFile == null
                  ? Container(
                      width: size.width * 0.6,
                      child: Column(
                        children: [
                          Image.asset('assets/images/cat_dog.jpg'),
                          SizedBox(height: 50.0),
                        ],
                      ),
                    )
                  : Container(
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.6,
                            height: 250.0,
                            child: Image.file(_imageFile),
                          ),
                          SizedBox(height: 20.0),
                          _output == null
                              ? Container()
                              : Text(
                                  '${_output[0]['label']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.0,
                                  ),
                                ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
            ),
            Container(
              width: size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _captureImageFromCamera(),
                    child: Container(
                      width: 120.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: Text(
                          'Capture Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  GestureDetector(
                    onTap: () => _selectImageFromGallery(),
                    child: Container(
                      width: 120.0,
                      height: 40.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Center(
                        child: Text(
                          'Select Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
