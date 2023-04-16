class Validation {
  static isDigit(String s) => (s.codeUnitAt(0) >= 48 && s.codeUnitAt(0) <= 57);

  static soloNumeros(String cad) {
    for (var i = 0; i < cad.length; i++) {
      if (!isDigit(cad[i])) return false;
    }
    return true;
  }

  static cantCaracteres(String str, int cant) {
    if (str.length >= cant) return true;
    return false;
  }
}
