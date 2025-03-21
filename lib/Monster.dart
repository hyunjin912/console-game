import 'dart:math';
import 'package:console_game/Character.dart';

/// 몬스터를 만들기 위한 클래스
class Monster {
  String name;
  int hp;
  late int initialHp;
  int def = 0;
  int atk = 0;
  int characterDef;
  int maxAtk;
  bool isRunaway = false; // 도망 가능 여부. false = 도망 불가능 상태

  Monster({
    required this.name,
    required this.hp,
    required this.characterDef,
    required this.maxAtk,
  }) {
    int random = Random().nextInt(maxAtk - characterDef + 1) + characterDef;
    atk = random;
    initialHp = hp;
  }

  /// 캐릭터를 공격하는 메서드
  void attackCharacter(Character character) {
    int realAtk = atk - character.def;
    character.hp -= realAtk;

    print(
      '\x1B[32m$name\x1B[0m이(가) \x1B[31m${character.name}\x1B[0m에게 $realAtk의 데미지를 입혔습니다.',
    );
  }

  /// 행동(턴)이 끝난 후 몬스터의 상태를 보여주기 위한 메서드
  void showStatus() {
    print('\x1B[32m$name\x1B[0m - 체력: $hp, 공격력: $atk, 방어력: $def');
  }

  /// 몬스터의 방어력을 증가시키는 메서드
  void increaseDef({required int amount}) {
    def += amount;
    print('\n\x1B[32m$name\x1B[0m의 방어력이 증가했습니다! 현재 방어력: $def');
  }

  /// 몬스터가 체력이 50%이하로 떨어질 경우 60%의 확률로 도망치게 하는 메서드
  bool runaway() {
    // 도망은 한 번만 가능
    if (!isRunaway) {
      int random = Random().nextInt(10);

      // 0 ~ 5 = 60%
      if (random < 6) {
        return true;
      }
    }

    return false;
  }

  // print()로 몬스터의 속성을 보기 위해 오버라이딩
  @override
  String toString() {
    return 'Monster {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
