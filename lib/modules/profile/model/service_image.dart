class ServiceImage {
  final String id;
  final String mobile;
  final String imageFileName;
  final String status;
  ServiceImage({
    this.id,
    this.mobile,
    this.imageFileName,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mobile': mobile,
      'imageFileName': imageFileName,
      'status': status,
    };
  }

  ServiceImage fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServiceImage(
      id: map['id'],
      mobile: map['mobile'],
      imageFileName: map['imageFileName'],
      status: map['status'],
    );
  }
}
