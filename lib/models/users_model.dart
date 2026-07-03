class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String nickname;
  final bool tosAgreed;
  final bool privacyAgreed;
  final bool marketingAgreed;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.nickname,
    required this.tosAgreed,
    required this.privacyAgreed,
    required this.marketingAgreed,
  });

  factory UserProfile.fromMap(String uid, Map<String, dynamic> m) {
    final terms = (m['terms'] as Map<String, dynamic>? ?? {});
    return UserProfile(
      uid: uid,
      email: (m['email'] ?? '') as String,
      displayName: (m['displayName'] ?? '') as String,
      nickname: (m['nickname'] ?? '') as String,
      tosAgreed: (terms['tos']?['agreed'] ?? false) as bool,
      privacyAgreed: (terms['privacy']?['agreed'] ?? false) as bool,
      marketingAgreed: (terms['marketing']?['agreed'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'displayName': displayName,
    'nickname': nickname,
    'terms': {
      'tos': {'agreed': tosAgreed},
      'privacy': {'agreed': privacyAgreed},
      'marketing': {'agreed': marketingAgreed},
    },
  };
}