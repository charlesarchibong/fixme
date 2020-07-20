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
      'requested_mobile': requestedMobile,
      'requesting_mobile': requestingMobile,
      'service_id': serviceId,
      'status': status,
      'date_requested': dateRequested,
    };
  }

  factory ServiceRequest.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ServiceRequest(
      sn: map['sn'],
      requestedMobile: map['requested_mobile'],
      requestingMobile: map['requesting_mobile'],
      serviceId: map['service_id'],
      status: map['status'],
      dateRequested: map['date_requested'],
    );
  }
}
