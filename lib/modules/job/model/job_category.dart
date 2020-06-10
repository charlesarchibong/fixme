class JobCategory {
  final String service;
  final int id;

  JobCategory({this.service, this.id});

  Map<String, dynamic> toMap() {
    return {
      'service': service,
      'sn': id,
    };
  }

  factory JobCategory.fromMap(Map<String, dynamic> map) {
    return JobCategory(
      service: map['service'],
      id: map['sn'],
    );
  }
}
