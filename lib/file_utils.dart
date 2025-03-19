import 'dart:io';

/// 파일을 읽어오기 위한 함수
String getData(String path) {
  try {
    String file = File(path).readAsStringSync();
    return file;
  } catch (e) {
    print('영웅을 불러오는데 실패했습니다.');
    exit(1); // 터미널 실행 종료 함수(에러일 때 매개변수 1)
  }
}

void createData(String contents) async {
  try {
    File file = await File('lib/result.txt').writeAsString(contents);
    print('당신의 모험을 기록으로 남겼습니다.');
  } catch (e) {
    print('모험의 기록을 실패했습니다.');
    exit(1); // 터미널 실행 종료 함수(에러일 때 매개변수 1)
  }
}
