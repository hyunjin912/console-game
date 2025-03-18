import 'dart:io';
import 'dart:math';
import 'package:console_game/Character.dart';
import 'package:console_game/CustomException.dart';
import 'package:console_game/Monster.dart';
import 'package:console_game/file_utils.dart';

class Game {
  late Character character;
  List<String> characterInitialValue = [];
  List<Monster> monsters = [];
  int huntingCount = 0;
  late String characterName;

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
    // bool isStart = true;
    RegExp nameRegexp = RegExp(r'^[a-zA-Z]+$');

    // while (isStart) {
    stdout.write('캐릭터의 이름을 영어로 입력하세요: ');
    characterName = stdin.readLineSync()!;

    try {
      if (!nameRegexp.hasMatch(characterName)) {
        throw Customexception('\n캐릭터의 이름이 영어가 아니므로 재시작합니다.\n');
      }

      character = Character(
        name: characterName,
        hp: int.parse(characterInitialValue[0]),
        atk: int.parse(characterInitialValue[1]),
        def: int.parse(characterInitialValue[2]),
      );

      print('\n게임을 시작합니다!');
      character.showStatus();

      battle();
    } catch (e) {
      print(e);
      startGame();
    }
    // }
  }

  void battle() {
    Monster currentMonster = getRandomMonster();
    Map<String, String> turn = {'who': 'character'};

    print('새로운 몬스터가 나타났습니다!');
    currentMonster.showStatus();

    // while 쓰지말고 여기는 캐릭터의 턴만 쓰고
    // 대신 몬스터의 메서드는 빼고
    print('$characterName의 턴');

    while (true) {
      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
      String actionNumber = stdin.readLineSync()!;

      switch (actionNumber) {
        case '1':
          print('\n여기는 1번입니다.\n');
          character.attackMonster(currentMonster);
          currentMonster.attackCharacter(character);

          character.showStatus();
          currentMonster.showStatus();
          break;
        case '2':
          print('$characterName이(가) 방어 태세를 취하여 0 만큼 체력을 얻었습니다.\n');
          break;
        default:
          print('\n일치하는 행동이 없습니다.\n');
      }
    }

    // 여기는 몬스터의 턴만 쓰면 되지 않나?
    // 위에서 캐릭터 턴이 끝나면 이 부분이 시작되면 되고

    // 이 부분 통째로 반복만 하면 되니
    // 60라인에서 battle()를 while문으로 감싸면 되지 않나?
    // 그리고 72,73을 59로 잘라내기 하면 되지 않나?
  }

  Monster getRandomMonster() {
    int random = Random().nextInt(monsters.length);
    Monster currentMonster = monsters[random];
    monsters.removeAt(random);

    return currentMonster;
  }
}
