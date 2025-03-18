import 'dart:io';
import 'package:console_game/Character.dart';
import 'package:console_game/CustomException.dart';
import 'package:console_game/Monster.dart';
import 'package:console_game/file_utils.dart';

class Game {
  late Character character;
  List<String> characterInitialValue = [];
  List<Monster> monsters = [];
  int huntingCount = 0;

  Game() {
    String characterData = getData('lib/characters.txt');
    String monsterData = getData('lib/monsters.txt');
    RegExp monsterRegexp = RegExp(r'^[a-zA-Z]+,\d+,\d+$', multiLine: true);
    characterInitialValue = characterData.split(',');

    List<RegExpMatch> mInfo = monsterRegexp.allMatches(monsterData).toList();

    for (var i = 0; i < mInfo.length; i++) {
      List<String> monsterInfo = mInfo[i].group(0)!.split(',');

      monsters.add(
        Monster(
          name: monsterInfo[0],
          hp: int.parse(monsterInfo[1]),
          characterDef: int.parse(characterInitialValue[2]),
          maxAtk: int.parse(monsterInfo[2]),
        ),
      );
    }
  }

  void startGame() {
    bool isStart = true;
    RegExp nameRegexp = RegExp(r'^[a-zA-Z]+$');

    while (isStart) {
      stdout.write('캐릭터의 이름을 영어로 입력하세요: ');
      String characterName = stdin.readLineSync()!;

      try {
        if (!nameRegexp.hasMatch(characterName)) {
          throw Customexception('캐릭터의 이름이 영어가 아니므로 재시작합니다.');
        }

        character = Character(
          name: characterName,
          hp: int.parse(characterInitialValue[0]),
          atk: int.parse(characterInitialValue[1]),
          def: int.parse(characterInitialValue[2]),
        );

        print('게임을 시작합니다!');
        print(
          '$characterName - 체력: ${characterInitialValue[0]}, 공격력: ${characterInitialValue[1]}, 방어력: ${characterInitialValue[2]}',
        );
      } catch (e) {
        print(e);
      }
    }
  }

  void battle() {}

  void getRandomMonster() {}
}
