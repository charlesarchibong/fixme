class RateArtisan {
  final String artisanMobile;
  final String ratedBy;
  final int serviceRequestId;
  final int rating;
  final int jobId;
  RateArtisan({
    this.artisanMobile,
    this.ratedBy,
    this.serviceRequestId,
    this.rating,
    this.jobId,
  });

  Map<String, dynamic> toMap() {
    return {
      'mobile': artisanMobile,
      'rated_by': ratedBy,
      'service_request_id': serviceRequestId,
      'rating': rating,
      'job_id': jobId,
    };
  }

  factory RateArtisan.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return RateArtisan(
      artisanMobile: map['mobile'],
      ratedBy: map['rated_by'],
      serviceRequestId: map['service_request_id'],
      rating: map['rating'],
      jobId: map['job_id'],
    );
  }
}
