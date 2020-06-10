class BankCode {
  final String id;
  final String slug;
  final String code;
  final String longcode;
  final String name;
  final String active;
  BankCode({
    this.id,
    this.slug,
    this.code,
    this.longcode,
    this.name,
    this.active,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      'name': name,
      'active': active,
    };
  }

  factory BankCode.fromMap(Map<String, dynamic> map) {
    return BankCode(
      id: map['id'],
      slug: map['slug'],
      code: map['code'],
      longcode: map['longcode'],
      name: map['name'],
      active: map['active'],
    );
  }
}
