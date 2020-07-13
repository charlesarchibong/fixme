class ServiceRequest {
  final int sn;
  final String requestedMobile;
  final String requestingMobile;
  final int serviceId;
  final String status;
  final String dateRequested;
  ServiceRequest({
    this.sn,
    this.requestedMobile,
    this.requestingMobile,
    this.serviceId,
    this.status,
    this.dateRequested,
  });

  Map<String, dynamic> toMap() {
    return {
      'sn': sn,
      'requestedMobile': requestedMobile,
      'requestingMobile': requestingMobile,
      'serviceId': serviceId,
      'status': status,
      'dateRequested': dateRequested,
    };
  }

  factory ServiceRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServiceRequest(
      sn: map['sn'],
      requestedMobile: map['requestedMobile'],
      requestingMobile: map['requestingMobile'],
      serviceId: map['serviceId'],
      status: map['status'],
      dateRequested: map['dateRequested'],
    );
  }
}
