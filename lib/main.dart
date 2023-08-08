import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedImage;
  String _latitude = "-123123281231123";
  String _longitude = "-123123281231121";

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _addLocationToImage() async {
    if (_selectedImage == null) {
      return;
    }

    final image = img.decodeImage(await _selectedImage!.readAsBytes());
    final newImage = img.copyResize(image!, width: 800);

    // final logoImage = img.drawImage(newImage, newImage, 0, 0);
    final latitudeText = img.drawString(
      newImage,
      img.arial_48,
      20,
      20,
      'Latitude: $_latitude',
      color: img.getColor(255, 255, 255),
    );

    //  final latitudeText = img.drawImage(dst, src)

    final longitudeText = img.drawString(
      latitudeText,
      img.arial_48,
      20,
      50,
      'Longitude: $_longitude',
      color: img.getColor(255, 255, 255),
    );

    final modifiedImageBytes = img.encodeJpg(longitudeText);
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/modified_image.jpg';
    final modifiedImageFile = File(imagePath)
      ..writeAsBytesSync(modifiedImageBytes);

    setState(() {
      _selectedImage = modifiedImageFile;
    });
  }

  Future<void> _saveImageWithMarcaDaguaToGallery(File? selectedImage) async {
    if (_selectedImage == null) {
      log('Nenhuma imagem selecionada.');
      return;
    }

    // Verifique se a permissão de acesso à galeria já foi concedida.
    if (await Permission.storage.isGranted) {
      try {
        var saved = await ImageGallerySaver.saveFile(selectedImage!.path);
        log("Imagem salva: ${saved.toString()} - Caminho: ${selectedImage.path}");
      } catch (e) {
        log('Erro ao salvar a imagem: $e');
      }
    } else {
      // Caso contrário, solicite a permissão.
      var permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        try {
          var saved = await ImageGallerySaver.saveFile(selectedImage!.path);
          log("Imagem salva: ${saved.toString()} - Caminho: ${selectedImage.path}");
        } catch (e) {
          log('Erro ao salvar a imagem: $e');
        }
      } else {
        log('Permissão de acesso à galeria negada.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Location Overlay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                width: 200,
                height: 200,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Escolher Imagem'),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) => _latitude = value,
              decoration: const InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              onChanged: (value) => _longitude = value,
              decoration: const InputDecoration(labelText: 'Longitude'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addLocationToImage,
              child: const Text('Adicionar Localização'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async =>
                  _saveImageWithMarcaDaguaToGallery(_selectedImage),
              child: const Text('Salvar Imagem'),
            ),
          ],
        ),
      ),
    );
  }
}
