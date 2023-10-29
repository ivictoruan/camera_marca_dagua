import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _selectedImage;

  Future<void> _pickImage({bool? isGallery}) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: (isGallery ?? false) ? ImageSource.gallery : ImageSource.camera,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _addWatermarkToImage() async {
    if (_selectedImage == null) {
      log('Nenhuma imagem selecionada.');
      return;
    }
    const String customText = "Seu texto da marca d'agua aqui";
    if (_selectedImage == null) {
      return;
    }
    final image = img.decodeImage(
      await _selectedImage!.readAsBytes(),
    );
    final newImage = img.copyResize(
      image!,
      width: 800,
    );
    img.drawString(
      newImage,
      customText,
      font: img.arial48,
      wrap: true,
    );

    final modifiedImageBytes = img.encodeJpg(newImage);
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/modified_image.jpg';
    final modifiedImageFile = File(imagePath)
      ..writeAsBytesSync(modifiedImageBytes);

    setState(() {
      _selectedImage = modifiedImageFile;
    });
  }

  Future<void> _saveImageWithWatermark(File? selectedImage) async {
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
        title: const Text('Câmera Marca D\'agua App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Material(
              elevation: 5,
              shadowColor: Colors.purple[100],
              color: Colors.grey[100],
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.contain,
                      width: 350,
                      height: 450,
                    )
                  : Container(
                      width: 350,
                      height: 500,
                      color: Colors.grey[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Escolha uma imagem \nou tira uma foto",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: 200,
                              child: OutlinedButton.icon(
                                onPressed: () async =>
                                    await _pickImage(isGallery: true),
                                icon: const Icon(Icons.file_upload_outlined),
                                label: const Text('Galeria'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 200,
              child: OutlinedButton.icon(
                onPressed: () async => await _pickImage(),
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Câmera'),
              ),
            ),
            if (_selectedImage != null)
              SizedBox(
                width: 200,
                child: OutlinedButton.icon(
                  onPressed: () async => await _pickImage(isGallery: true),
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text('Galeria'),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            label: const Text('Add marca d\'agua'),
            icon: const Icon(Icons.add),
            onPressed: () async => await _addWatermarkToImage(),
          ),
          ElevatedButton.icon(
            label: const Text('Salvar'),
            icon: const Icon(Icons.save_alt_rounded),
            onPressed: () async =>
                await _saveImageWithWatermark(_selectedImage),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
