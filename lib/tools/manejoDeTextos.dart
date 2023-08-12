String convertToSSML(String text) {
  // Definir la expresión regular para los signos de puntuación que agregarán pausas
  final punctuationRegex = RegExp(r'[.,;?!:\-\n]');

  // Definir la duración de las pausas para cada tipo de signo de puntuación
  final pauseDurations = {
    '.': '500ms',
    ',': '300ms',
    ';': '400ms',
    '?': '800ms',
    '!': '800ms',
    ':': '400ms',
    '-': '200ms',
    '\n': '500ms'
  };

  // Reemplazar signos de puntuación y saltos de línea con SSML que incluye pausas
  String ssmlText = text.replaceAllMapped(punctuationRegex, (match) {
    final punctuation = match.group(0);
    final pauseDuration = pauseDurations[punctuation] ?? '500ms';
    return '$punctuation<break time="$pauseDuration"/>';
  });

  // Envolver el texto en la etiqueta <speak> si no está vacío
  if (ssmlText.isNotEmpty) {
    ssmlText = '<speak>$ssmlText</speak>';
  }
  print(ssmlText);
  return ssmlText;
}



enum Emocion {
  Felicidad,
  Enojo,
  Neutral,
  Tristeza,
  Asco,
  MiedoInseguridad,
}

Map<Emocion, List<String>> palabrasClave = {
  Emocion.Felicidad: [
    '¿','feliz', 'alegre', 'bueno', 'maravilloso', 'amor', 'divertido', 'éxito',
    'sonrisa', 'agradable', 'positivo', 'contento', 'optimismo', 'gratitud',
    'festejar', 'alegrarse', 'emocionante', 'satisfactorio', 'entusiasmado', 'alegremente',
    'hola',  'buenas','gracias', 'amistad', 'ayuda', 'amo', 'extraño', 'deseo', 'gusto', 'encantado', 'bienvenido',
    'genial', 'fantástico', 'brillante', 'increíble', 'celebrar', 'felicitar'
  ],
  Emocion.Enojo: [
    'enojado', 'malo','enojada', 'mala', 'terrible', 'odio', 'frustrado', 'desastroso',
    'enfurecido', 'desesperado', 'negativo', 'irritado', 'rabia', 'irritante',
    'impotencia', 'descontento', 'furioso', 'enfadado', 'resentido', 'indignado', 'agresión',
    'problema', 'error', 'injusticia', 'molestia', 'insoportable',
    'horrible', 'enfadar', 'gritar', 'insultar', 'odiar' , 'tonto', 'iluso'
  ],
  Emocion.Neutral: [
    'normal', 'indiferente', 'neutro', 'aburrido', 'común', 'equilibrado', 'sereno',
    'tranquilo', 'relajado', 'pasivo', 'apático', 'resignado', 'imparcial', 'desapegado',
    'plácido', 'serenidad', 'calma', 'equilibrio', 'estable', 'impersonal', 'invariable',
    'quizás', 'rutina', 'normalidad', 'vale', 'supongo', 'entendido', 'acuerdo', 'correcto'
  ],
  Emocion.Tristeza: [
    'triste', 'llorar', 'desconsolado', 'melancolía', 'desánimo', 'desilusión', 'angustia',
    'soledad', 'pena', 'nostalgia', 'vacío', 'dolor', 'desesperanza', 'desgarrador',
    'desolación', 'aflicción', 'abatido', 'lágrimas', 'desamparo', 'melancólico',
    'despedida', 'desilusionado', 'extraño', 'deseo', 'menos',
    'deprimido', 'apenado', 'abrumado', 'desconsuelo', 'fracaso'
  ],
  Emocion.Asco: [
    'asco', 'repugnante', 'desagradable', 'repulsión', 'asqueroso', 'repulsivo',
    'desprecio', 'aversión', 'desagradecido', 'suciedad', 'vómito', 'náusea',
    'aborrecimiento', 'repelente', 'desdén', 'indignante', 'desencanto', 'repeler', 'antipatía',
    'desaire', 'indigno', 'repugnar', 'repulsión', 'desagrado', 'despreciar'
  ],
  Emocion.MiedoInseguridad: [
    'miedo', 'inseguridad', 'preocupación', 'temor', 'ansiedad', 'pánico',
    'aterrorizado', 'desconfianza', 'vulnerable', 'peligro', 'aterrador',
    'amenaza', 'incertidumbre', 'inseguro', 'paranoia', 'aterrorizante', 'angustiante', 'inquietud',
    'aprensión', 'nerviosismo', 'fobia', 'pavor', 'terror', 'desasosiego',
    'asustado', 'precaución', 'cuidado', 'temeroso', 'desconfiado',
    'amenazante', 'intimidante', 'preocupante', 'horripilante', 'horroroso'
  ],
};

Emocion analizarSentimiento(String texto) {
  Map<Emocion, int> emocionesContador = {
    Emocion.Felicidad: 0,
    Emocion.Enojo: 0,
    Emocion.Neutral: 0,
    Emocion.Tristeza: 0,
    Emocion.Asco: 0,
    Emocion.MiedoInseguridad: 0,
  };

  // Convertir el texto a minúsculas para hacer coincidencias sin distinción de mayúsculas y minúsculas
  texto = texto.toLowerCase();

  palabrasClave.forEach((emocion, palabras) {
    palabras.forEach((palabra) {
      if (texto.contains(palabra)) {
        emocionesContador[emocion] = emocionesContador[emocion]! + 1;
        print("palabra clave $palabra");
        print("emocion"+emocion.toString());
        print("emocionesContador[emocion]) "+ emocionesContador[emocion].toString());
      }
    });
  });

  // Encontrar la emoción predominante
  Emocion emocionPredominante = Emocion.Neutral;
  int maxContador = 0;

  emocionesContador.forEach((emocion, contador) {
    if (contador > maxContador) {
      emocionPredominante = emocion;
      maxContador = contador;
    }
  });
  print("emocion final $emocionPredominante");
  return emocionPredominante;
}
double asignarValorEmocion(Emocion emocion) {
  if (emocion == Emocion.Felicidad) {
    return 1.0;
  } else if (emocion == Emocion.Tristeza) {
    return 2.0;
  } else if (emocion == Emocion.MiedoInseguridad) {
    return 3.0;
  } else if (emocion == Emocion.Enojo) {
    return 4.0;
  } else if (emocion == Emocion.Asco) {
    return 5.0;
  } else {
    // Emoción Neutral o cualquier otro caso
    return 0.0;
  }
}