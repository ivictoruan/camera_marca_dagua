import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;
  // Strings aleatórias para simular a localização.
  final String _latitude = "-123123281231123";
  final String _longitude = "-123123281231121";

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

    var textInfoIntoImage = img.drawString(
      newImage,
      img.arial_48,
      30,
      30,
      '''
Lati: $_latitude'
Longi: $_longitude
São Luís-MA
      ''',
      color: img.getColor(255, 255, 255),
    );
    final modifiedImageBytes = img.encodeJpg(textInfoIntoImage);
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
        title: const Text('Camera Marca Dagua App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                width: 300,
                height: 300,
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Escolher Imagem'),
              ),
            ),
            
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.location_on_outlined),
              label: const Text('Buscar Localização (GPS/Coordenadas)'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addLocationToImage,
              child: const Text('Adicionar Localização'),
            ),
            const SizedBox(height: 10),
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
