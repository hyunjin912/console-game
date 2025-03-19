import 'dart:io';
import 'dart:math';
import 'package:console_game/Character.dart';
import 'package:console_game/CustomException.dart';
import 'package:console_game/Monster.dart';
import 'package:console_game/file_utils.dart';

class Game {
  late Character character;
  List<Monster> monsters = [];
  late Monster currentMonster;
  int huntingCount = 0;
  late String characterName;

  // 생성자. 캐릭터와 몬스터의 데이터를 가져오며 해당되는 인스턴스 변수에 값을 초기화 한다.
  Game() {
    String characterData = getData('lib/characters.txt');
    String monsterData = getData('lib/monsters.txt');
    RegExp monsterRegexp = RegExp(r'^[a-zA-Z]+,\d+,\d+$', multiLine: true);
    List<String> characterInitialValue = characterData.split(',');
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

    character = Character(
      hp: int.parse(characterInitialValue[0]),
      atk: int.parse(characterInitialValue[1]),
      def: int.parse(characterInitialValue[2]),
    );
  }

  void startGame() {
    stdout.write('\n캐릭터의 이름을 영어로 입력하세요: ');
    String characterName = stdin.readLineSync()!;
    RegExp nameRegexp = RegExp(r'^[a-zA-Z]+$');

    try {
      if (!nameRegexp.hasMatch(characterName)) {
        throw Customexception('\n캐릭터의 이름이 영어가 아니므로 재시작합니다.');
      }

      character.name = characterName;
      currentMonster = getRandomMonster();

      print('\n게임을 시작합니다!');
      character.showStatus();
      print('\n새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();

      battle();
    } catch (e) {
      print(e);
      startGame();
    }
  }

  void battle() {
    bool isBattle = true;
    String nextStage;
    String resultStage;

    while (isBattle) {
      try {
        if (character.hp <= 0) {
          print('${character.name}이(가) 사망하였습니다.');
          return;
        }

        if (currentMonster.hp <= 0) {
          if (monsters.isEmpty) {
            print('\n축하합니다! 모든 몬스터를 물리쳤습니다.');
            stdout.write('모험을 저장하시겠습니까? (y/n): ');

            resultStage = stdin.readLineSync()!;
            switch (resultStage) {
              case 'y':
                createData('${character.name}, ${character.hp}, 승리');
                return;
              case 'n':
                print('\n${character.name}의 모험이 끝났습니다.');
                print('비록, 모험의 기록은 남지 않더라도 당신의 모험은 구전될 것입니다.');
                return;
              default:
                throw Customexception('\n${character.name}의 의지를 정확히 알려주세요.');
            }
          }

          stdout.write('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
          nextStage = stdin.readLineSync()!;

          switch (nextStage) {
            case 'y':
              currentMonster = getRandomMonster();
              print('\n새로운 몬스터가 나타났습니다!');
              currentMonster.showStatus();
              break;
            case 'n':
              print('\n${character.name}의 모험이 끝났습니다.');
              return;
            default:
              throw Customexception('\n${character.name}의 의지를 정확히 알려주세요.');
          }
        }

        print('\n${character.name}의 턴');
        stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
        String actionNumber = stdin.readLineSync()!;

        switch (actionNumber) {
          case '1':
            character.attackMonster(currentMonster);
            if (currentMonster.hp == 0) continue;
            break;
          case '2':
            print('${character.name}이(가) 방어 태세를 취하여 0 만큼 체력을 얻었습니다.');
            break;
          default:
            throw Customexception('\n일치하는 행동이 없습니다.\n');
        }

        print('\n${currentMonster.name}의 턴');
        currentMonster.attackCharacter(character);
        print('\n[ 진행상황 ]');
        character.showStatus();
        currentMonster.showStatus();
        print('-----------------------------------');
      } catch (e) {
        print(e);
      }
    }
  }

  Monster getRandomMonster() {
    int random = Random().nextInt(monsters.length);
    Monster currentMonster = monsters[random];
    monsters.removeAt(random);

    return currentMonster;
  }
}
