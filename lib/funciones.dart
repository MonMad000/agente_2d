

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
String numeroEnPalabras(int numero) {
  final _unidades = [
    'cero', 'uno', 'dos', 'tres', 'cuatro', 'cinco', 'seis', 'siete', 'ocho',
    'nueve', 'diez', 'once', 'doce', 'trece', 'catorce', 'quince', 'dieciséis',
    'diecisiete', 'dieciocho', 'diecinueve'
  ];

  final _decenas = [
    '', '', 'veinte', 'treinta', 'cuarenta', 'cincuenta', 'sesenta', 'setenta',
    'ochenta', 'noventa'
  ];

  final _centenas = [
    '', 'ciento', 'doscientos', 'trescientos', 'cuatrocientos', 'quinientos',
    'seiscientos', 'setecientos', 'ochocientos', 'novecientos'
  ];

  if (numero == 0) {
    return 'cero';
  }

  if (numero < 0) {
    return 'menos ${numeroEnPalabras(-numero)}';
  }

  if (numero < 20) {
    return _unidades[numero];
  }

  if (numero < 100) {
    var decena = _decenas[numero ~/ 10];
    var unidad = numero % 10;
    if (unidad > 0) {
      return '$decena y ${_unidades[unidad]}';
    } else {
      return decena;
    }
  }
  if (numero == 100) {
    return 'cien';
  }
  if (numero < 1000) {
    var centena = _centenas[numero ~/ 100];
    var decena = numeroEnPalabras(numero % 100);
    if (decena == 'cero') {
      return centena;
    } else if (numero % 100 < 10) {
      return '$centena $decena';
    } else {
      return '$centena  $decena';
    }
  }

  if (numero == 1000) {
    return 'mil';
  }

  if (numero < 1000000) {
    var miles = numeroEnPalabras(numero ~/ 1000);
    var resto = numero % 1000;
    var sufijo = resto == 0 ? '' : ' ${numeroEnPalabras(resto)}';
    var mil = miles == 'uno' && resto < 100 && resto > 0 ? 'mil' : 'mil';
    var resultado = '$miles $mil$sufijo';
    if (miles == 'uno' && resto != 0) {
      resultado = 'mil$sufijo';
    }
    return resultado;
  }

  return 'Número muy grande';
}

String remplazarNumerosEnPalabras(String texto) {
  RegExp regex = RegExp(r'\d+');
  return texto.replaceAllMapped(regex, (match) => numeroEnPalabras(int.parse(match.group(0)!)));
}