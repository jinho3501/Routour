import "package:cloud_firestore/cloud_firestore.dart";

/// ▼ 지역 선택지
enum Destination {
  gwangju('광주광역시', 'gwangju'),
  jeonnam('전라남도', 'jeonnam'),
  jeonbuk('전라북도', 'jeonbuk');

  final String label; // UI 표기용
  final String code;  // DB 저장용(불변 키)
  const Destination(this.label, this.code);

  static Destination fromCode(String? code) {
    return Destination.values.firstWhere(
          (e) => e.code == code,
      orElse: () => Destination.gwangju,
    );
  }
}

/// ▼ 동행인 선택지
enum Companion {
  alone('혼자', 'alone'),
  friend('친구', 'friend'),
  pet('반려동물', 'pet'),
  family('가족', 'family'),
  couple('연인', 'couple'),
  foreigner('외국인', 'foreigner');

  final String label;
  final String code;
  const Companion(this.label, this.code);

  static Companion fromCode(String? code) {
    return Companion.values.firstWhere(
          (e) => e.code == code,
      orElse: () => Companion.alone,
    );
  }
}

/// ▼ 여행 기간 선택지
enum TravelDuration {
  oneDay('당일치기', '1d'),
  twoDays('1박2일', '2d1n'),
  threeDays('2박3일', '3d2n'),
  fourDays('3박4일', '4d3n'),
  fiveDays('4박5일', '5d4n'),
  moreDays('5박이상', '5dplus');

  final String label;
  final String code;
  const TravelDuration(this.label, this.code);

  static TravelDuration fromCode(String? code) {
    return TravelDuration.values.firstWhere(
          (e) => e.code == code,
      orElse: () => TravelDuration.oneDay,
    );
  }
}

/// ▼ 여행 컨셉 선택지
enum TravelConcept {
  sports('스포츠', 'sports'),
  culture('문화', 'culture'),
  food('먹거리', 'food'),
  nature('자연', 'nature'),
  tourist('관광', 'tourist'),
  photo('사진', 'photo');

  final String label;
  final String code;
  const TravelConcept(this.label, this.code);

  static TravelConcept fromCode(String? code) {
    return TravelConcept.values.firstWhere(
          (e) => e.code == code,
      orElse: () => TravelConcept.tourist,
    );
  }
}

/// ▼ 여행 스타일 선택지
enum TravelStyle {
  activity('액티비티', 'activity'),
  relaxed('여유로운', 'relaxed'),
  intensive('빡빡한', 'intensive'),
  healing('힐링', 'healing'),
  nightLife('야간여행', 'night_life'),
  cultural('문화체험', 'cultural');

  final String label;
  final String code;
  const TravelStyle(this.label, this.code);

  static TravelStyle fromCode(String? code) {
    return TravelStyle.values.firstWhere(
          (e) => e.code == code,
      orElse: () => TravelStyle.relaxed,
    );
  }
}

/// ▼ 이동수단 선택지
enum Transport {
  walking('도보', 'walking'),
  car('자동차', 'car'),
  bicycle('자전거', 'bicycle'),
  motorcycle('오토바이', 'motorcycle'),
  publicTransport('대중교통', 'public_transport');

  final String label;
  final String code;
  const Transport(this.label, this.code);

  static Transport fromCode(String? code) {
    return Transport.values.firstWhere(
          (e) => e.code == code,
      orElse: () => Transport.car,
    );
  }
}

class SurveyResult {
  final Destination destination;
  final Companion companion;
  final TravelDuration duration;
  final TravelConcept concept;
  final TravelStyle style;
  final Transport transport;

  /// 선택 장소 ID들(초기엔 String ID 유지. 추후 DocumentReference로 전환 고려 가능)
  final List<String> selectedPlaces;

  /// Firestore Timestamp ↔ DateTime 변환 안전하게
  final DateTime createdAt;
  final DateTime? modifiedAt;

  SurveyResult({
    required this.destination,
    required this.companion,
    required this.duration,
    required this.concept,
    required this.style,
    required this.transport,
    required this.selectedPlaces,
    DateTime? createdAt,
    this.modifiedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      // DB에는 code 저장 (라벨 변경 시에도 안정)
      'destination': destination.code,
      'companion': companion.code,
      'duration': duration.code,
      'concept': concept.code,
      'style': style.code,
      'transport': transport.code,
      'selectedPlaces': selectedPlaces,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': modifiedAt != null ? Timestamp.fromDate(modifiedAt!) : null,
    };
  }

  factory SurveyResult.fromMap(Map<String, dynamic> map) {
    return SurveyResult(
      destination: Destination.fromCode(map['destination'] as String?),
      companion: Companion.fromCode(map['companion'] as String?),
      duration: TravelDuration.fromCode(map['duration'] as String?),
      concept: TravelConcept.fromCode(map['concept'] as String?),
      style: TravelStyle.fromCode(map['style'] as String?),
      transport: Transport.fromCode(map['transport'] as String?),
      selectedPlaces: List<String>.from(map['selectedPlaces'] ?? const []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modifiedAt: (map['modifiedAt'] as Timestamp?)?.toDate(),
    );
  }

  SurveyResult copyWith({
    Destination? destination,
    Companion? companion,
    TravelDuration? duration,
    TravelConcept? concept,
    TravelStyle? style,
    Transport? transport,
    List<String>? selectedPlaces,
    DateTime? createdAt,
    DateTime? modifiedAt,
  }) {
    return SurveyResult(
      destination: destination ?? this.destination,
      companion: companion ?? this.companion,
      duration: duration ?? this.duration,
      concept: concept ?? this.concept,
      style: style ?? this.style,
      transport: transport ?? this.transport,
      selectedPlaces: selectedPlaces ?? this.selectedPlaces,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }
}
