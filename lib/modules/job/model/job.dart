import 'dart:convert';

class Job {
  final int id;
  final String jobTitle;
  final String serviceCategory;
  final String price;
  final String description;
  final double latitude;
  final double longitude;
  Job({
    this.id,
    this.jobTitle,
    this.serviceCategory,
    this.price,
    this.description,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'sn': id,
      'job_title': jobTitle,
      'service_category': serviceCategory,
      'budget': price,
      'job_description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['sn'],
      jobTitle: map['job_title'],
      serviceCategory: map['service_category'],
      price: map['budget'],
      description: map['job_description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
