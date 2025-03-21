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

  // 생성자. 캐릭터와 몬스터의 데이터를 가져오며 해당되는 인스턴스 변수에 값을 초기화한다.
  Game() {
    String characterData = getData('lib/assets/characters.txt');
    String monsterData = getData('lib/assets/monsters.txt');
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

  /// 사용자의 입력 값을 받아 전투를 시작하기 위한 메서드
  void startGame() {
    stdout.write('\n캐릭터의 이름을 영어로 입력하세요: ');
    String characterName = stdin.readLineSync()!;
    RegExp nameRegexp = RegExp(r'^[a-zA-Z]+$');

    try {
      // 인코딩 문제로 영어만 입력 받기 위한 조건문
      // 영어 외에는 커스텀 예외를 발생시킴
      if (!nameRegexp.hasMatch(characterName)) {
        throw Customexception('\n캐릭터의 이름이 영어가 아니므로 재시작합니다.');
      }

      // 캐릭터 이름과 랜덤 몬스터 설정
      character.name = characterName;
      currentMonster = getRandomMonster();

      print('\n게임을 시작합니다!');
      character.getLockyHp(); // 30%확률로 체력 보너스 제공
      character.showStatus();
      print('\n새로운 몬스터가 나타났습니다!');
      currentMonster.showStatus();

      // 전투 시작
      battle();
    } catch (e) {
      print(e);

      // 예외로 인한 재시작
      startGame();
    }
  }

  /// 턴을 교환해가며 전투가 진행되게 하는 메서드
  void battle() {
    String nextStage;
    int halfTurnCount = 0;

    // 특정 조건이 성립하기 전까지 무한 loop를 돌면서 전투를 진행
    while (true) {
      try {
        // 캐릭터의 체력이 0 이하일 때
        if (character.hp <= 0) {
          print('\n\x1B[31m${character.name}\x1B[0m이(가) 사망하여 모험을 종료합니다.');
          saveGame();
          return;
        }

        // 몬스터를 처치하면 monsters에서 삭제하는게 아니라
        // getRandomMonster를 호출할 때 미리 삭제를 하기 때문에
        // monsters.length가 0인 경우에도 동작하면
        // getRandomMonster에서 Random().nextInt(0)을 호출해서 무한 에러가 발생하므로
        // monsters.length가 1 이상 일 때만 동작해야 함
        // 즉, 마지막 몬스터는 도망을 못하게 막기
        if (monsters.isNotEmpty) {
          // 도망을 한 번도 가지 않은 몬스터의 체력이 50% 이하일 때
          if (!currentMonster.isRunaway &&
              currentMonster.hp <= currentMonster.initialHp * 0.5) {
            if (currentMonster.runaway()) {
              print(
                '\n이런! \x1B[32m${currentMonster.name}\x1B[0m이(가) 당신을 피해 도망칩니다!',
              );

              currentMonster = getRandomMonster(prevMonster: currentMonster);
              print('\n새로운 몬스터가 나타났습니다!');
              currentMonster.showStatus();
              halfTurnCount = 0;
            }
          }
        }

        // 몬스터의 체력이 0 이하일 때(=몬스터를 처치했을 때)
        if (currentMonster.hp <= 0) {
          // 턴 초기화
          halfTurnCount = 0;

          // 모든 몬스터를 처치했을 때
          if (monsters.isEmpty) {
            print('\n축하합니다! 모든 몬스터를 물리쳤습니다.');
            saveGame();
            return;
          }

          // 다음 진행을 위해 사용자에게 물어보고, 대답에 대한 상황 작성
          stdout.write('\n다음 몬스터와 싸우시겠습니까? (y/n): ');
          nextStage = stdin.readLineSync()!;

          switch (nextStage) {
            case 'y':
              currentMonster = getRandomMonster();
              print('\n새로운 몬스터가 나타났습니다!');
              currentMonster.showStatus();
              break;
            case 'n':
              print('\n\x1B[31m${character.name}\x1B[0m의 모험이 끝났습니다.');
              saveGame();
              return;
            default:
              throw Customexception(
                '\n\x1B[31m${character.name}\x1B[0m의 의지를 정확히 알려주세요.',
              );
          }
        }

        // 캐릭터의 턴일 때의 기본 동작
        print('\n\x1B[31m${character.name}\x1B[0m의 턴');
        if (character.isItemActive) {
          // 아이템 사용 후
          stdout.write('행동을 선택하세요 (1: 공격, 2: 방어): ');
        } else {
          // 아이템 사용 전
          stdout.write('행동을 선택하세요 (1: 공격, 2: 방어, 3: 아이템 사용): ');
        }
        String actionNumber = stdin.readLineSync()!;

        if (halfTurnCount >= 3) {
          currentMonster.increaseDef(amount: 2);
          halfTurnCount = 0;
        }

        switch (actionNumber) {
          case '1':
            character.attackMonster(monster: currentMonster);
            if (currentMonster.hp <= 0) {
              // 도망가기를 사용하지 않은 몬스터가 처치됐으면
              // true로 변경해야 도망기능이 동작하지 않는다
              currentMonster.isRunaway = true;
              continue;
            }
            break;
          case '2':
            character.defend(currentMonster);
            if (character.hp <= 0) continue;
            break;
          case '3':
            if (!character.isItemActive) {
              // 아이템 사용 전
              character.isItemActive = true;
              character.attackMonster(monster: currentMonster, increase: 2);
              if (currentMonster.hp <= 0) {
                // 도망가기를 사용하지 않은 몬스터가 처치됐으면
                // true로 변경해야 도망기능이 동작하지 않는다
                currentMonster.isRunaway = true;
                continue;
              }
            } else {
              throw Customexception(
                '\n\x1B[31m${character.name}\x1B[0m의 의지를 정확히 알려주세요.',
              );
            }
            break;
          default:
            throw Customexception(
              '\n\x1B[31m${character.name}\x1B[0m의 의지를 정확히 알려주세요.',
            );
        }

        // 사용자의 턴이 끝났으니 카운트 증가
        // 사용자 턴 시작일 때 증가하면 안됨
        // 이유는 사용자 턴에서 에러가 생기면 재시작 후에 턴이 다시 시작되니까
        // 그때마다 증가하는 것을 방지해야함
        halfTurnCount++;

        // 몬스터의 턴일 때의 기본 동작
        print('\n\x1B[32m${currentMonster.name}\x1B[0m의 턴');
        if (halfTurnCount >= 3) {
          currentMonster.increaseDef(amount: 2);
          halfTurnCount = 0;
        }
        currentMonster.attackCharacter(character);

        // 몬스터의 턴이 끝났으니 카운트 증가
        halfTurnCount++;

        // 턴을 교환한 후의 상태를 보여줌
        print('\n[ 진행상황 ]');
        character.showStatus();
        currentMonster.showStatus();
        print('-----------------------------------');
      } catch (e) {
        print(e);
      }
    }
  }

  /// 랜덤한 몬스터를 뽑기 위한 메서드
  Monster getRandomMonster({Monster? prevMonster}) {
    // 0 <= random < monsters.length
    int random = prevMonster == null ? 0 : Random().nextInt(monsters.length);
    Monster currentMonster = monsters[random];
    monsters.removeAt(random);

    if (prevMonster != null && !prevMonster.isRunaway) {
      prevMonster.isRunaway = true;
      monsters.add(prevMonster);
    }

    return currentMonster;
  }

  /// 게임 결과를 저장하기 위한 메서드
  void saveGame() {
    String resultStage;

    stdout.write('모험을 저장하시겠습니까? (y/n): ');
    resultStage = stdin.readLineSync()!;

    switch (resultStage) {
      case 'y':
        String re = monsters.isEmpty ? '승리' : '실패';
        createData('이름: ${character.name}, 체력: ${character.hp}, 결과: $re');
        break;
      case 'n':
        print('\n비록, 모험의 기록은 남지 않더라도 당신의 모험은 구전될 것입니다.');
        break;
      default:
        throw Customexception(
          '\n\x1B[31m${character.name}\x1B[0m의 의지를 정확히 알려주세요.',
        );
    }
  }
}
