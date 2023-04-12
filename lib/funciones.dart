import 'dart:async';

import 'package:diacritic/diacritic.dart';


String limpiaTexto(String texto) {
  texto=texto.toLowerCase();
  for (int i = 0; i < texto.length; i++) {
    if (i == 0 && texto[i] == 'h') {
      texto = replaceCharAt(texto, i, '');
    }
    if (i - 1 >= 0 && i + 1 <= texto.length) {
      //cambio las h por espacios en blanco
      if (texto[i] == 'h') {
        if (!(texto[i - 1] == 'c') &&
            !(texto[i - 1] == 's') &&
            (texto[i + 1] != 'í')) {
          texto = replaceCharAt(texto, i, '');
        }
      }
      //cambio qu por k
      if (texto[i - 1] == 'q' && texto[i] == 'u') {
        texto = replaceCharAt(texto, i - 1, ' ');
        texto = replaceCharAt(texto, i, 'k');
      }
      //cambio qu por k
      if (texto[i - 1] == 'q') {
        texto = replaceCharAt(texto, i - 1, 'k');
      }
      //cambiar gu por g
      /*if (texto[i - 1] == 'g' &&
          texto[i] == 'u' &&
          (texto[i + 1] == 'i' || texto[i + 1] == 'e')) {
        texto = replaceCharAt(texto, i, '');
      }*/
      //cambiar ci o ce por si o se
      if (texto[i - 1] == 'c' && (texto[i] == 'e' || texto[i] == 'i')) {
        texto = replaceCharAt(texto, i - 1, 's');
      }
      //cambiar ll por y
      /*if (texto[i - 1] == 'l' && texto[i] == 'l') {
        texto = replaceCharAt(texto, i - 1, ' ');
        texto = replaceCharAt(texto, i, 'y');
      }*/
      //cambiar y por i
      if (texto[i - 1] == 'y' && texto[i] == '') {
        texto = replaceCharAt(texto, i - 1, 'i');
      }
      //cambiar , por ¬
      if (texto[i] == ',') {
        //texto = replaceCharAt(texto, i, '¬');
      }
    }
  }
  return texto;
}

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

int charToVisemaGenerico(String C) {
  C = C.toLowerCase();
  switch (C) {
    case "a":
    case "e":
    case "i":
      return 1;
    case "o":
      return 2;
    case "u":
    case "w":
      return 3;
    case "l":
      return 4;
    case "y":
      return 5;
    case "c":
    case "d":
    case "g":
    case "k":
    case "n":
    case "ñ":
    case "s":
    case "t":
    case "x":
    case "z":
    case "q":
    case "j":
      return 5;
    case "m":
    case "b":
    case "p":
      return 6;
    case "f":
    case "v":
      return 7;
    case "r":
      return 8;
    case ".":
    case "\n":
      return -2;
    case ",":
    case ";":
    case ":":
      return -1;
    default:
      return 0;
  }
}

int charToVisema(String C) {
  C = C.toLowerCase();
  C = removeDiacritics(C);
  switch (C) {
    case "a":
      return 3;
    case "b":
      return 9;
    case "c":
      return 14;
    case "d":
      return 7;
    case "e":
      return 2;
    case "f":
      return 11;
    case "g":
      return 15;
    case "i":
      return 1;
    case "j":
      return 16;
    case "k":
      return 14;
    case "l":
      return 7;
    case "m":
      return 9;
    case "n":
    case "ñ":
      return 10;
    case "o":
      return 4;
    case "p":
      return 9;
    case "q":
      return 14;
    case "r":
      return 8;
    case "s":
      return 13;
    case "t":
      return 7;
    case "u":
      return 5;
    case "v":
      return 11;
    case "w":
      return 5;
    case "x":
      return 14;
    case "y":
      return 6;
    case "z":
      return 13;
    default:
      return 0;
  }
}

dynamic splitPorPunto(String texto) {
  var arr = texto.split(RegExp(r'(\n|\.)'));
  return arr;
}

