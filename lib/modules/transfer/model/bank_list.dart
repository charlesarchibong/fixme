class BankList {
  final int id;
  final String name;
  final String slug;
  final String code;
  final String longcode;
  final String gateway;

  BankList({
    this.id,
    this.name,
    this.slug,
    this.code,
    this.longcode,
    this.gateway,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      'gateway': gateway,
    };
  }

  factory BankList.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return BankList(
      id: map['id'],
      name: map['name'],
      slug: map['slug'],
      code: map['code'],
      longcode: map['longcode'],
      gateway: map['gateway'],
    );
  }
}
