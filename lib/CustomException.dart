/// 예외 처리 메시지를 커스텀하기 위한 클래스
class Customexception implements Exception {
  String message;

  Customexception(this.message);

  @override
  String toString() => message;
}
