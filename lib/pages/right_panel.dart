import 'dart:io';

import 'package:testeo/tools/manejoDeTextos.dart';
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
            SizedBox( height: 20.0),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                    onPressed: _openFileExplorer,
                    child: Text('Seleccionar archivo'),
                  ),
                ),
                  Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        String ssml = convertToSSML(_textEditingController.text);
                        _textEditingController.text=ssml;
                        print(analizarSentimiento(ssml));
                      },
                      child: Text('\u{1F5E3}', style: TextStyle(fontSize: 30)),
                    ),
                  ),


                ],
              ),


            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(20, 20, 10, 20),
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(

                                  labelText: 'Ingrese su texto',

                                  border: OutlineInputBorder(),

                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                                ),
                                maxLines: null, // Permite múltiples líneas de texto
                                onChanged: (value) {
                                  setState(() {}); // Actualiza el estado para redibujar el widget
                                },
                              ),
                            ),

                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )

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
      final path = result.files.single.path;
      final file = File(path!);

      String fileContent = '';

      fileContent = await file.readAsString();

      _textEditingController.text = fileContent;
      convertToSSML(fileContent);
      print('Contenido del archivo '+fileContent);
      //print('Contenido del archivo: '+ convertToSSML(fileContent));
    } else {
      // El usuario canceló la selección de archivos.
    }
  }
}
