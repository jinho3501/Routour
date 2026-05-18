import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;           // Firebase Auth UID
  final String name;          // 사용자 이름
  final String email;         // 이메일
  final DateTime createdAt;   // 가입일
  final DateTime? lastLoginAt; // 마지막 로그인
  final List<String> likedPlaces;   // 좋아요한 장소 ID
  final List<String> recentViews;   // 최근 본 장소 ID
  final Map<String, dynamic> preferences; // 사용자 설정/선호

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    DateTime? createdAt,
    this.lastLoginAt,
    this.likedPlaces = const [],
    this.recentViews = const [],
    this.preferences = const {},
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': lastLoginAt != null ? Timestamp.fromDate(lastLoginAt!) : null,
      'likedPlaces': likedPlaces,
      'recentViews': recentViews,
      'preferences': preferences,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: (map['uid'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp?)?.toDate(),
      likedPlaces: List<String>.from(map['likedPlaces'] ?? const []),
      recentViews: List<String>.from(map['recentViews'] ?? const []),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? const {}),
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? likedPlaces,
    List<String>? recentViews,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      likedPlaces: likedPlaces ?? this.likedPlaces,
      recentViews: recentViews ?? this.recentViews,
      preferences: preferences ?? this.preferences,
    );
  }

  // 편의 메서드
  bool hasLiked(String placeId) => likedPlaces.contains(placeId);
  bool hasViewed(String placeId) => recentViews.contains(placeId);
}
