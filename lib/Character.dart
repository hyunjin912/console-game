import 'package:console_game/Monster.dart';

/// 캐릭터를 만들기 위한 클래스
class Character {
  String? name;
  int hp;
  int atk;
  int def;

  Character({required this.hp, required this.atk, required this.def});

  /// 몬스터를 공격하는 메서드
  void attackMonster(Monster monster) {
    monster.hp -= atk;
    print('$name이(가) ${monster.name}에게 $atk의 데미지를 입혔습니다.');

    if (monster.hp == 0) {
      print('${monster.name}을(를) 물리쳤습니다!');
    }
  }

  /// 몬스터의 공격으로부터 방어를 하기 위한 메서드
  void defend() {}

  /// 행동(턴)이 끝난 후 캐릭터의 상태를 보여주기 위한 메서드
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $atk, 방어력: $def');
  }

  // print()로 캐릭터의 속성을 보기 위해 오버라이딩
  @override
  String toString() {
    return 'Character {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
