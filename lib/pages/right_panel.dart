import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
class RightPanel extends StatefulWidget {
  @override
  _RightPanelState createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Panel derecho'),
            ElevatedButton(
              onPressed: _openFileExplorer,
              child: Text('Seleccionar archivo'),
            ),

          ],
        ),
      ),
    );
  }
  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      if (file.bytes != null) {
        String fileContent = utf8.decode(file.bytes!);
        // Hacer algo con el contenido del archivo
        print('Contenido del archivo: $fileContent');
      } else {
        // No se pudo obtener los bytes del archivo
      }
    } else {
      // El usuario canceló la selección de archivos.
    }
  }
}
