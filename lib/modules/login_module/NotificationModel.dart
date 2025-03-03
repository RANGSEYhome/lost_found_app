class NotificationModel {
  final String id;
  final String userId;
  final String postId;
  final String reason;
  final String postTitle;
  final String postDescription;
  final String postCategory;
  final String postLocation;
  final String postImages;
  final String postDate;
  final String postPhone;
  final String createdDate;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.reason,
    required this.postTitle,
    required this.postDescription,
    required this.postCategory,
    required this.postLocation,
    required this.postImages,
    required this.postDate,
    required this.postPhone,
    required this.createdDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      userId: json['userId'],
      postId: json['postId'],
      reason: json['reason'],
      postTitle: json['postTitle'],
      postDescription: json['postDescription'],
      postCategory: json['postCategory'],
      postLocation: json['postLocation'],
      postImages: json['postImages'],
      postDate: json['postDate'],
      postPhone: json['postPhone'],
      createdDate: json['createdDate'],
    );
  }
}