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
  late Monster currentMonster;
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
    stdout.write('\n캐릭터의 이름을 영어로 입력하세요: ');
    String characterName = stdin.readLineSync()!;

    try {
      if (!nameRegexp.hasMatch(characterName)) {
        throw Customexception('\n캐릭터의 이름이 영어가 아니므로 재시작합니다.');
      }

      character = Character(
        name: characterName,
        hp: int.parse(characterInitialValue[0]),
        atk: int.parse(characterInitialValue[1]),
        def: int.parse(characterInitialValue[2]),
      );

      currentMonster = getRandomMonster();

      print('\n게임을 시작합니다!');
      character.showStatus();
      print('새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();

      battle(); // 이 메서드에 while로 랩핑하면 battle내에서 에러가 뜨면 지금 여기의 catch문이 동작해서 startGame이 다시 시작되므로 하면 안될 듯
    } catch (e) {
      print(e);
      startGame();
    }
    // }
  }

  void battle() {
    try {
      print('${character.name}의 턴');

      stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
      String actionNumber = stdin.readLineSync()!;

      switch (actionNumber) {
        case '1':
          print('\n여기는 1번입니다.\n');
          character.attackMonster(currentMonster);
          break;
        case '2':
          print('${character.name}이(가) 방어 태세를 취하여 0 만큼 체력을 얻었습니다.\n');
          break;
        default:
          throw Customexception('\n일치하는 행동이 없습니다.\n');
      }

      print('\n${currentMonster.name}의 턴');
      currentMonster.attackCharacter(character);
      print('[ 진행상황 ]');
      character.showStatus();
      currentMonster.showStatus();
      print('-----------------------------------');

      battle();
    } catch (e) {
      print(e);
      battle();
    }
  }

  Monster getRandomMonster() {
    int random = Random().nextInt(monsters.length);
    Monster currentMonster = monsters[random];
    monsters.removeAt(random);

    return currentMonster;
  }
}
