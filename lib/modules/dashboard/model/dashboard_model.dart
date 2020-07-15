class DashboardModel {
  final int profileViews;
  final double ratings;
  final int reviews;
  final double totalRevenue;
  final double accountBalance;
  final int serviceRequest;
  final int completedJobs;
  final int projectBids;

  DashboardModel({
    this.profileViews,
    this.ratings,
    this.reviews,
    this.totalRevenue,
    this.accountBalance,
    this.serviceRequest,
    this.completedJobs,
    this.projectBids,
  });

  Map<String, dynamic> toMap() {
    return {
      'profile_views': profileViews,
      'ratings': ratings,
      'reviews': reviews,
      'total_revenue': totalRevenue,
      'account_balance': accountBalance,
      'service_request': serviceRequest,
      'completed_jobs': completedJobs,
      'project_bids': projectBids,
    };
  }

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return DashboardModel(
      profileViews: map['profile_views'],
      ratings: map['ratings'],
      reviews: map['reviews'],
      totalRevenue: map['total_revenue'],
      accountBalance: map['account_balance'],
      serviceRequest: map['service_request'],
      completedJobs: map['completed_jobs'],
      projectBids: map['project_bids'],
    );
  }

  @override
  String toString() {
    return 'DashboardModel(profileViews: $profileViews, ratings: $ratings, reviews: $reviews, totalRevenue: $totalRevenue, accountBalance: $accountBalance, serviceRequest: $serviceRequest, completedJobs: $completedJobs, projectBids: $projectBids)';
  }
}
