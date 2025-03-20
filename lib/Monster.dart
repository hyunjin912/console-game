import 'dart:math';
import 'package:console_game/Character.dart';

/// 몬스터를 만들기 위한 클래스
class Monster {
  String name;
  int hp;
  int def = 0;
  int atk = 0;
  int characterDef;
  int maxAtk;

  Monster({
    required this.name,
    required this.hp,
    required this.characterDef,
    required this.maxAtk,
  }) {
    int random = Random().nextInt(maxAtk - characterDef + 1) + characterDef;
    atk = random;
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

  // print()로 몬스터의 속성을 보기 위해 오버라이딩
  @override
  String toString() {
    return 'Monster {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
