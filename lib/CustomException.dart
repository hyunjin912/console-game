class Customexception implements Exception {
  String message;

  Customexception(this.message);

  @override
  String toString() => message;
}
