String convertToSSML(String text) {
  // Definir los signos de puntuación que agregarán pausas
  final punctuationMarks = ['.', ',', ';', '?', '!', ':','-'];

  // Definir la duración de las pausas para cada tipo de signo de puntuación
  final pauseDurations = {
    '.': '500ms',
    ',': '300ms',
    ';': '400ms',
    '?': '800ms',
    '!': '800ms',
    ':': '400ms',
  };

  // Reemplazar signos de puntuación y saltos de línea con SSML que incluye pausas
  String ssmlText = text.replaceAllMapped(RegExp(r'[\.\,\;\?\!\:\-]|\n'), (match) {
    final punctuation = match.group(0);
    final pauseDuration = pauseDurations[punctuation] ?? '500ms';
    return '<break time="$pauseDuration"/>$punctuation';
  });

  // Envolver el texto en la etiqueta <speak>
  ssmlText = '<speak>$ssmlText</speak>';

  return ssmlText;
}
enum Emocion {
  Positivo,
  Negativo,
  Neutral,
  Tristeza,
  MiedoInseguridad,
}

Map<Emocion, List<String>> palabrasClave = {
  Emocion.Positivo: [
    'feliz', 'alegre', 'bueno', 'maravilloso', 'amor', 'divertido', 'éxito',
    'sonrisa', 'agradable', 'todo va bien', 'me siento genial', 'maravilloso día',
    'hola', 'buenos días', 'buenas tardes', 'buenas noches', 'gracias', 'amistad', 'disfrutar'
  ],
  Emocion.Negativo: [
    'triste', 'enojado', 'malo', 'terrible', 'odio', 'frustrado', 'desastroso',
    'enfurecido', 'desesperado', 'todo va mal', 'me siento horrible', 'día terrible',
    'no', 'problema', 'error', 'trabajo difícil', 'discusiones'
  ],
  Emocion.Neutral: [
    'normal', 'indiferente', 'neutro', 'aburrido', 'común', 'equilibrado', 'sereno',
    'ni bien ni mal', 'no pasa nada', 'no tengo opinión', 'quizás', 'rutina', 'normalidad'
  ],
  Emocion.Tristeza: [
    'llorar', 'desconsolado', 'melancolía', 'desánimo', 'desilusión', 'angustia',
    'soledad', 'pena', 'nostalgia', 'no tengo ganas de nada', 'me siento vacío',
    'nada tiene sentido', 'todo me duele', 'despedida', 'desilusionado'
  ],
  Emocion.MiedoInseguridad: [
    'miedo', 'inseguridad', 'preocupación', 'temor', 'ansiedad', 'pánico',
    'aterrorizado', 'desconfianza', 'vulnerable', 'no puedo confiar en nadie',
    'me siento amenazado', 'siento que algo malo va a pasar', 'no puedo dormir por las noches',
    'precaución', 'incertidumbre', 'riesgo', 'peligro'
  ],
};

Emocion analizarSentimiento(String texto) {
  texto = texto.toLowerCase();

  // Verificar las palabras clave para cada emoción
  for (Emocion emocion in palabrasClave.keys) {
    List<String> palabras = palabrasClave[emocion]!;
    for (String palabra in palabras) {
      if (texto.contains(palabra)) {
        return emocion;
      }
    }
  }

  // Si no se encontraron palabras clave, se considera neutral
  return Emocion.Neutral;
}

