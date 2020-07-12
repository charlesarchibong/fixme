import 'dart:convert';

class ProjectBid {
  final int sn;
  final int jobId;
  final String uploaderMobile;
  final String bidderMobile;
  final int distance;
  final double biddingPrice;
  final String status;
  final String dateBidded;
  final String dateApproved;
  final String dateRejected;
  ProjectBid({
    this.sn,
    this.jobId,
    this.uploaderMobile,
    this.bidderMobile,
    this.distance,
    this.biddingPrice,
    this.status,
    this.dateBidded,
    this.dateApproved,
    this.dateRejected,
  });

  Map<String, dynamic> toMap() {
    return {
      'sn': sn,
      'job_id': jobId,
      'uploader_mobile': uploaderMobile,
      'bidder_mobile': bidderMobile,
      'distance': distance,
      'bidding_price': biddingPrice,
      'status': status,
      'date_bidded': dateBidded,
      'date_approved': dateApproved,
      'date_rejected': dateRejected,
    };
  }

  factory ProjectBid.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return ProjectBid(
      sn: map['sn'],
      jobId: map['job_id'],
      uploaderMobile: map['uploader_mobile'],
      bidderMobile: map['bidder_mobile'],
      distance: map['distance'],
      biddingPrice: map['bidding_price'],
      status: map['status'],
      dateBidded: map['date_bidded'],
      dateApproved: map['date_approved'],
      dateRejected: map['date_rejected'],
    );
  }

  String toJson() => json.encode(toMap());
}
