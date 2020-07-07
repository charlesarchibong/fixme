class Job {
  final int id;
  final String jobTitle;
  final int serviceCategory;
  final int price;
  final String address;
  final String description;
  final double latitude;
  final double longitude;
  final String status;
  final String datePosted;
  Job({
    this.id,
    this.jobTitle,
    this.serviceCategory,
    this.price,
    this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.status,
    this.datePosted,
  });

  Map<String, dynamic> toMap() {
    return {
      'sn': id,
      'job_title': jobTitle,
      'service_category': serviceCategory,
      'status': status,
      'budget': price,
      'job_description': description,
      'latitude': latitude,
      'longitude': longitude,
      'date_oppened': datePosted,
      'job_address': address,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['sn'],
      jobTitle: map['job_title'],
      serviceCategory: map['service_category'],
      status: map['status'],
      price: map['budget'],
      description: map['job_description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['job_address'],
      datePosted: map['date_oppened'],
    );
  }
}
