import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:testeo/funciones.dart';
import 'package:testeo/tools/globales.dart';
import 'package:testeo/tools/manejoDeTextos.dart';
import 'package:testeo/tools/openai_services.dart';
import 'package:statsfl/statsfl.dart';

// Esta es la clase que representa el widget de la aplicación
class AppAgentes extends StatefulWidget {
  // const AppAgentes({super.key});
  const AppAgentes({Key? key}) : super(key: key);

  @override
  AppAgentesState createState() => AppAgentesState();
}

// Esta es la clase de estado correspondiente al StatefulWidget
class AppAgentesState extends State<AppAgentes> {
  @override
  // Este método se llama cada vez que se actualiza el estado de la aplicación.
  Widget build(BuildContext context) {
    // Devuelve una instancia de MaterialApp, que es la raíz de la interfaz de usuario.
    return gui(context);
  }

  //############### FUNCIONES DE INICIALIZACION##############
  @override
  void initState() {
    //se llama cuando este objeto se agrega al árbol de widget(en este caso al inicio ya q es la raiz)
    texto = "";
    super.initState();
    initTts();
    initRive(riv);
  }

  initTts() async {
    //inicializa el flutterTts, controlador del texto a voz
    flutterTts = FlutterTts();
    await flutterTts.setLanguage('es-MX'); // Establece el idioma
    await flutterTts
        .setSpeechRate(0.46); //0.53 Establece la velocidad del habla
    await flutterTts.setVolume(1); // Establece el volumen
  }

  initRive(String riv) {
    //rootBundle.load('assets/ella1.riv').then(
    rootBundle.load('assets/$riv.riv').then(
      (data) async {
        // se guarda en la variable file
        final file = RiveFile.import(data);
        //se guarda el artboard del archivo
        final artboard = file.mainArtboard;
        //se crea un controlador de la statemachine tomandola del artboard y por su nombre con el constructor fromArtboard
        var controller = StateMachineController.fromArtboard(artboard, 'Habla');
        //se controla que exista la statemachine
        if (controller != null) {
          //se debe agregar el controller al artboard (la variable)
          artboard.addController(controller);

          //se especifica el input
          visemaNum = controller.findInput('VisemaNum');
          visemaNum?.value = 0;
          gestoNum = controller.findInput('gesto');
          gestoNum?.value = 0;
          miradaNum = controller.findInput('mirada');
          miradaNum?.value = -1;

          /*Timer.periodic(const Duration(seconds: 5), (timer) {

            setState(() {
              print('parpadea');
              miradaNum?.value = 5;
              print(miradaNum?.value);
            });
            Future.delayed(Duration(seconds: 4), () {
               miradaNum?.value = 0;
            });
          });*/
        }

        setState(() => riveArtboard = artboard);
      },
    );
  }

  //############### FUNCIONES DE INTERFAZ##############

  Widget gui(BuildContext context) {
    //esta funcion devuelve el widget raiz y por ende la interfaz
    return StatsFl(
      align: Alignment.bottomRight,
      child: MaterialApp(
        //es una interfaz prediseñada estilo material design
        title: 'Material App',
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Agente 2D - Visemas y expresiones'),
          ),
          body: Column(children: [
            Expanded(
              //la cara
              flex: 7,
              child: SizedBox(
                  width: 500,
                  height: 500,
                  child: Rive(
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      artboard: riveArtboard!)),
            ),
            Expanded(
              //el texto
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                    onChanged: (String value) {
                      _onChange(value);
                    },
                    maxLines: null,
                    controller: textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ingrese el texto deseado',
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                    )),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //String emoji = '\u{1F60A}';
                children: [
                  FloatingActionButton(
                    //cambio cara
                    onPressed: () {
                      if(cara<2)
                        cara++;
                      else cara = 0;
                      switch (cara) {
                        case 0:
                          riv = 'ella1';
                          break;
                        case 1:
                          riv = 'rubia';
                          break;
                        case 2:
                          riv = 'nene';
                          break;
                      }
                      initRive(riv);
                    },
                    child:
                        const Text('\u{1F5FF}', style: TextStyle(fontSize: 30)),
                  ),
                  FloatingActionButton(
                    //HABLAR
                    onPressed: () {
                      flutterTts.getEngines;
                      hablaSSML(texto);
                    },
                    child:
                        const Text('\u{1F5E3}', style: TextStyle(fontSize: 30)),
                  ),
                  /*FloatingActionButton(//  INTERACTUAR
                    onPressed: () async {

                      var res = await sendTextCompletionRequest(texto);
                      print("res:"+res.toString());
                      response =res["choices"][0]["text"];
                      print("response:"+response);
                      String textoDecodificado = utf8.decode(response.codeUnits);
                      print(textoDecodificado);
                      pressHablar(textoDecodificado);

                    },
                    child: Text('\u{1F5E8}', style: TextStyle(fontSize: 30)),
                  )*/
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  /*Widget _buildEmotionButton(String emoji, int value) {
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(70, 70),
          shape: const CircleBorder(),
          elevation: selectedEmotion == value ? 8 : 2,
          backgroundColor: selectedEmotion == value
              ? Colors.blue
              : const Color.fromARGB(181, 150, 255, 194),
        ),
        onPressed: () {
          setState(() {

            printLanguages();
            selectedEmotion = value;
            //gestoNum?.value = selectedEmotion.toDouble();
            //visemaNum?.value = selectedEmotion as double;
          });
        },
        child: Text(
          emoji,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
*/
  //################# FUNCIONES QUE ACTUALIZAN ESTADO###################

  pressHablar(String texto) {
    //se acomoda el texto para poder convertirlo a visemas
    //texto=remplazarNumerosEnPalabras(texto);
    texto = limpiaTexto(texto);
    textoDividido = splitPorPunto(texto);
    for (int j = 0; j < textoDividido.length; j++) {
      print(textoDividido[j]);
    }
    recorrerArregloDeStrings(textoDividido);
  }

  recorrerArregloDeStrings(List<String> textoCompleto) async {
    for (int i = 0; i < textoCompleto.length; i++) {
      recorrerTexto(textoCompleto[i]);
      await habla(textoCompleto[i]);
    }
  }

  Future<void> habla(String C) async {
    await flutterTts.awaitSpeakCompletion(true);
    if (C.isNotEmpty) {
      await flutterTts.speak(C);
      await flutterTts.awaitSpeakCompletion(true);
      hablando = false;
      await Future.delayed(const Duration(milliseconds: 1000));
      visemaNum?.value = -1;
    }
  }

// se actualiza el texto q se esta ingresando, se invoca cuando el campo de texto cambia
  void _onChange(String text) {
    setState(() {
      texto = text;
    });
  }

//hace que mueva la boca basicamente
  void recorrerTexto(String texto) async {
    RegExp regExp = RegExp(r'[;:?!]');
    //se recorre el texto para pasar de caracter a visema

    for (int i = 0; i < texto.length; i++) {
      //este if controla que si es el primer caracter no espere
      if (i == 0) {
        esperaVisemas = 0;
      } else {
        esperaVisemas = 70; //este tiempo deberia ser una variable
      }
      if (texto[i] == ',') {
        //flutterTts.pause();
        await Future.delayed(const Duration(milliseconds: 750));
        //await flutterTts.speak(texto.substring(i));
      }
      if (regExp.hasMatch(texto[i])) {
        //flutterTts.pause();
        await Future.delayed(const Duration(milliseconds: 850));
        //await flutterTts.speak(texto.substring(i));
      }
      await Future.delayed(Duration(milliseconds: esperaVisemas), () {
        if(cara!=2){
          visemaNum?.value = charToVisema(texto[i]).toDouble();

        }
        else visemaNum?.value = charToVisemaGenerico(texto[i]).toDouble();

      });
    }
  }

  //
  void recorrerTextoSSML(String texto) async {
    //se recorre el texto para pasar de caracter a visema
    for (int i = 0; i < texto.length; i++) {
      //este if controla que si es el primer caracter no espere
      if (i == 0) {
        esperaVisemas = 0;
      } else {
        esperaVisemas = 65; //este tiempo deberia ser una variable
      }
      switch (texto[i]) {
        case '.':
          await Future.delayed(const Duration(milliseconds: 500));
          break;
        case ',':
          await Future.delayed(const Duration(milliseconds: 300));
          break;
        case ';':
          await Future.delayed(const Duration(milliseconds: 400));
          break;
        case '?':
          await Future.delayed(const Duration(milliseconds: 800));
          break;
        case '!':
          await Future.delayed(const Duration(milliseconds: 800));
          break;
        case ':':
          await Future.delayed(const Duration(milliseconds: 400));
          break;
        case '\n': // Nueva línea
          await Future.delayed(const Duration(milliseconds: 500));
          break;
        case '-': // Guion
          await Future.delayed(const Duration(milliseconds: 200));
          break;
      }
      await Future.delayed(Duration(milliseconds: esperaVisemas), () {
        visemaNum?.value = charToVisema(texto[i]).toDouble();
      });
      //recorro la cadena entre signos de puntuacion
      if (texto[i] == '.' ||
          texto[i] == ',' ||
          texto[i] == ';' ||
          texto[i] == '?' ||
          texto[i] == '!' ||
          texto[i] == ':' ||
          i == 0) {
        // Detectar el próximo texto hasta el siguiente signo de puntuación
        String proximoTexto = '';
        for (int j = i + 1; j < texto.length; j++) {
          if (texto[j] == '.' ||
              texto[j] == ',' ||
              texto[j] == ';' ||
              texto[j] == '?' ||
              texto[j] == '!' ||
              texto[j] == ':') {
            break;
          }
          proximoTexto += texto[j];
        }
        if (proximoTexto.isNotEmpty) {
          Emocion emocionProximoTexto =
              analizarSentimiento(proximoTexto.trim());
          gestoNum?.value = asignarValorEmocion(emocionProximoTexto);
        }
      }
    }
  }

  Future<void> hablaSSML(String txt) async {
    txt = remplazarNumerosEnPalabras(txt);
    String txtSSML = convertToSSML(txt); //se prepara el texto para el tts
    String txtLimpio =
        limpiaTexto(txt); //se prepara el texto para el ttv (text to visem)
    recorrerTextoSSML(txtLimpio);
    habla(txtSSML);
  }

  //################# FUNCIONES AUXILIARES TTS  ###################
  void printLanguages() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    print("Lenguajes soportados:");
    print(languages.toString());
  }

  void printVoices() async {
    List<dynamic> voices = await flutterTts.getVoices;
    print("Voces disponibles:");
    for (dynamic voice in voices) {
      print(
          " - ${voice['name']}, ${voice['language']}, ${voice['quality']}, ${voice['phonetics']}");
    }
  }
}
