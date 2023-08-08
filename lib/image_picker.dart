// import 'dart:io';
// import 'package:image/image.dart' as img;

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class ImagePickerApp extends StatefulWidget {
//   const ImagePickerApp({super.key});

//   @override
//   _ImagePickerAppState createState() => _ImagePickerAppState();
// }

// class _ImagePickerAppState extends State<ImagePickerApp> {
//   File? _imageFile;
//   final picker = ImagePicker();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _imageFile != null
//                 ? Image.file(_imageFile!)
//                 : const Icon(Icons.image, size: 100),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: const Text('Pick Image'),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _latitudeController,
//               decoration: const InputDecoration(
//                 labelText: 'Latitude',
//               ),
//             ),
//             TextField(
//               controller: _longitudeController,
//               decoration: const InputDecoration(
//                 labelText: 'Longitude',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: createImageText,
//               child: const Text('Add Coordinates'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _pickImage() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       if (pickedFile != null) {
//         _imageFile = File(pickedFile.path);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }

//   createImageText() async {
//     (img.Command()
//       // Create an image, with the default uint8 format and default number of channels, 3.
//       ..createImage(width: 256, height: 256)
//       // Fill the image with a solid color (blue)
//       ..fill(color: img.ColorRgb8(0, 0, 255)))
//       // Draw some text using the built-in 24pt Arial font
//       ..drawString('Hello World', font: img.arial24, x: 0, y: 0)
//       // Draw a red line
//       ..drawLine(
//           x1: 0,
//           y1: 0,
//           x2: 256,
//           y2: 256,
//           color: img.ColorRgb8(255, 0, 0),
//           thickness: 3)
//       // Blur the image
//       ..gaussianBlur(radius: 10)
//       // Save the image to disk as a PNG.
//       ..writeToFile('test.png')
//       // Execute the command sequence.
//       ..execute();
//   }

//   void _addCoordinatesToImage() async {
//     if (_imageFile == null) {
//       Fluttertoast.showToast(
//         msg: 'Please select an image first.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//       return;
//     }

//     final latitude = _latitudeController.text;
//     final longitude = _longitudeController.text;

//     if (latitude.isEmpty || longitude.isEmpty) {
//       Fluttertoast.showToast(
//         msg: 'Please enter latitude and longitude.',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//       );
//       return;
//     }

//     // TODO: Add coordinates to the image.

//     // Load the image using 'image' package

//     // Define the coordinates for the text

//     // Add latitude and longitude as text to the image
//     // img.drawString(image, x:x, y:y, "$latitude, $longitude", font: );

//     // Save the modified image to a new file
//     // final directory = await getTemporaryDirectory();
//     // final newFilePath = '${directory.path}/modified_image.jpg';
//     // File(newFilePath).writeAsBytesSync(img.encodeJpg(image));

//     Fluttertoast.showToast(
//       msg: 'Coordinates added to the image.',
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//     );
//   }
// }
