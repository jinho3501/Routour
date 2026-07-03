import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routour/viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:routour/views/login/signup_page.dart' show PolicyPage;
enum LocationAccessOption { none, wifi, always }

// ===== 약관 전문 (Settings에서 재사용) =====
const String kTOS_TEXT = '''
서비스 이용약관

제1조(목적)
본 약관은 Routour(이하 “회사”)가 제공하는 Routour 서비스(이하 “서비스”)의 이용조건과 회사와 이용자 간 권리·의무 및 책임사항을 규정함을 목적으로 합니다.

제2조(정의)
“서비스”란 여행지 정보 제공, 개인화 추천, 일정 관리, 위치 기반 탐색 등 회사가 제공하는 일체의 서비스·콘텐츠를 말합니다.
“이용자”란 본 약관에 동의하고 서비스를 이용하는 회원 및 비회원을 말합니다.
“회원”이란 계정을 생성하여 서비스를 지속적으로 이용하는 자를 말합니다.
“콘텐츠”란 이용자 또는 회사가 서비스에 게시·저장하는 텍스트, 이미지, 리뷰, 일정, 북마크 등 일체의 자료를 말합니다.
“유료서비스”란 구독, 프리미엄 추천, 광고 제거 등 대가를 지급하고 이용하는 기능을 말합니다.

제3조(약관의 게시와 변경)
회사는 약관을 서비스 내에 게시합니다.
법령 개정, 정책 변경 또는 서비스 개선을 위해 약관을 변경할 수 있습니다.
약관 변경 시 시행일 7일 전(이용자 권리 중대한 변경은 30일 전) 고지합니다.
이용자가 변경 약관에 동의하지 않는 경우 서비스 이용을 중단하고 탈퇴할 수 있습니다.

제4조(약관 외 준칙)
본 약관에서 정하지 않은 사항은 「전자상거래법」, 「개인정보보호법」, 「위치정보법」, 「저작권법」 등 관계 법령과 운영정책을 따릅니다.

제5조(계정 및 보안)
회원가입은 본인 소유 연락처·계정으로 진행합니다.
계정·비밀번호 관리 책임은 회원에게 있으며, 분실·도용 등의 사고 발생 시 즉시 회사에 통지해야 합니다.
회사는 계정 보안을 위해 본인확인, 이중인증 등 추가 절차를 요구할 수 있습니다.

제6조(서비스의 제공·변경)
회사는 다음 기능을 제공합니다: 여행지·코스 정보, 맞춤 추천, 일정 작성·공유, 위치 기반 탐색, 즐겨찾기, 리뷰·평가.
회사는 운영상·기술상 필요 시 서비스의 전부 또는 일부를 변경할 수 있으며, 중요 변경은 사전 고지합니다.
오픈베타·실험 기능은 안정성이 보장되지 않을 수 있습니다.

제7조(개인화 알고리즘 고지)
회사는 서비스 개인화를 위해 선호 태그, 검색·클릭 로그, 위치정보(선택), 기기 식별자 등 처리 사실을 고지하며, 영업비밀을 해치지 않는 범위에서 설명을 제공합니다.

제8조(위치기반서비스)
위치 기반 기능은 별도의 「위치정보 이용약관」과 동의 절차에 따릅니다.

제9조(유료서비스·결제·청약철회·환불)
결제수단: 앱마켓 결제, 신용·체크카드, 간편결제 등.
정기구독은 기간 만료 시 자동 갱신될 수 있으며, 갱신일 전 해지 시 다음 결제 주기부터 중단됩니다.
디지털 콘텐츠 특성상 사용 개시 후 청약철회가 제한될 수 있습니다. 다만 제공 지연, 중대한 하자 등 「전자상거래법」상 환불 사유에 해당하는 경우 환불합니다.
앱마켓(구글/애플 등)을 통한 결제는 각 마켓 약관·정책이 우선합니다.
가격·과금정책 변경 시 사전 고지합니다.

제10조(이용자의 의무)
법령·약관·운영정책 준수.
다음 행위 금지: 타인 정보 도용, 불법 프로그램 사용, 리버스 엔지니어링, 서버 공격, 스팸·어뷰징, 허위 리뷰, 저작권·초상권 침해, 음란·혐오·차별·폭력 조장, 위치정보 부정수집·공유 등.
위반 시 게시물 삭제, 이용 제한, 계약 해지, 손해배상 청구가 가능합니다.

제11조(게시물의 관리 및 권리)
게시물의 저작권은 원칙적으로 게시자에게 귀속됩니다.
회원은 회사에 대해 서비스 운영·노출·홍보 목적의 범위에서 게시물의 비독점적, 무상, 지역무제한 이용권을 허여합니다. 회원 탈퇴 후에도 백업·분쟁 대응 등 필수 범위 내 보관이 가능합니다.
권리침해 신고가 합리적으로 소명되면 회사는 임시조치·삭제 등 필요한 조치를 취할 수 있습니다.

제12조(지식재산권)
서비스와 관련된 소프트웨어, 데이터베이스, 디자인, 상표 등 일체의 권리는 회사 또는 정당한 권리자에게 귀속됩니다. 약관에 따른 이용허락 외 소유권은 이전되지 않습니다.

제13조(제3자 서비스·링크)
서비스에는 제3자 사이트·API·SDK가 포함될 수 있습니다. 제3자 서비스는 해당 제공자의 약관·정책이 적용되며, 회사는 그로 인한 법률상 책임을 지지 않습니다.

제14조(서비스 중단)
천재지변, 정전, 설비 장애, 과도한 트래픽, 외부 플랫폼·API 장애 등 불가피한 사유로 서비스가 중단될 수 있습니다. 회사는 지체 없이 복구에 노력합니다.

제15조(보증의 부인)
회사는 공공데이터 및 제3자 데이터의 완전성·정확성·최신성을 보증하지 않습니다.
서비스는 “있는 그대로” 제공되며 특정 목적 적합성·비침해성 등에 대한 명시적·묵시적 보증을 하지 않습니다.

제16조(책임의 한계)
법령이 허용하는 최대 범위 내에서, 회사의 귀책이 없는 간접·특별·결과적 손해에 대한 책임을 부담하지 않으며, 유료서비스 관련 회사의 총 배상책임은 최근 3개월 간 이용자가 회사에 지급한 금액을 한도로 합니다.

제17조(계약 해지)
이용자는 언제든지 탈퇴할 수 있습니다.
회사는 약관·정책 위반 시 상당한 기간을 정하여 시정 요구 후 해지할 수 있으며, 중대한 위반은 즉시 해지할 수 있습니다.

제18조(공지 및 통지)
회사의 공지는 서비스 내 게시로 갈음할 수 있습니다.
개별 통지는 회원이 마지막으로 제공한 연락처로 합니다.

제19조(준거법 및 관할)
본 약관은 대한민국 법률에 따르며, 분쟁은 회사 주소지 관할 법원을 전속 관할로 합니다.

부칙
시행일: 2025-08-19
버전: v1.0
''';

const String kPRIVACY_TEXT = '''
개인정보 처리방침

1. 총칙
Routour는 「개인정보보호법」 등 관련 법령을 준수하며, 본 방침을 서비스 내에 상시 공개합니다.

2. 처리하는 개인정보 항목
필수 항목: 이메일 또는 휴대전화, 비밀번호(해시 처리), 닉네임, 국가/언어, 앱 내부 식별자, 기기정보(OS/모델/앱버전), 접속 IP·로그, 쿠키/광고식별자(ADID/IDFA), 이용 기록(검색·클릭·조회)
선택 항목: 성별, 생년, 관심사/선호 태그, 동행 유형, 프로필 이미지, 위치정보(실시간/방문 이력), 여행 일정, 북마크, 리뷰·사진
결제 시: 결제수단 식별정보(마켓 토큰/PG 식별값), 결제·취소·환불 내역, 영수증 번호(신용카드 실정보는 PG/마켓이 처리)
고객센터: 문의 내용, 첨부 파일, 기기·앱 정보

3. 수집 방법
회원가입 및 서비스 이용 과정, 자동수집도구(SDK/쿠키/로그), 제3자 로그인(선택 시)으로부터 동의 범위 내 수집합니다.

4. 처리 목적
회원관리 및 본인확인, 부정이용 방지, 서비스 제공(여행지 정보·개인화 추천·일정 관리·알림), 통계·분석·A/B 테스트, 유료결제 정산, 법령 준수 및 분쟁 대응, 시스템 보안 강화.

5. 보유·이용 기간
원칙: 회원탈퇴 또는 목적 달성 시 지체 없이 파기
예외(법령에 따른 보존):
계약·대금결제·재화 공급 기록: 5년
소비자 불만·분쟁처리 기록: 3년
표시·광고에 관한 기록: 6개월
접속 로그 등 통신사실확인자료: 3개월
위치정보 이용·제공 사실 확인자료: 6개월

6. 파기 절차 및 방법
목적 달성 시 별도 DB로 이동 후 법정 보존기간 경과 즉시 파기합니다. 전자파일은 복구 불가능한 방법으로 삭제하고, 출력물은 분쇄 또는 소각합니다.

7. 제3자 제공
원칙적으로 동의 없는 제3자 제공은 하지 않습니다. 다만 법령에 의한 요청 또는 이용자 동의가 있는 경우 제공할 수 있으며, 제공받는 자·목적·항목·보유기간을 사전 고지합니다.

8. 처리위탁
서비스 운영을 위해 다음 업무를 위탁할 수 있습니다(예시, 선정 시 업데이트):
클라우드/백업: [예: 네이버클라우드, AWS]
푸시/알림: [예: Firebase Cloud Messaging]
분석/로그: [예: Amplitude, Sentry]
결제/정산: [예: 앱마켓, 국내 PG]
위탁 시 개인정보 보호 관련 계약을 체결하고 수탁자 명칭·업무·보유기간을 공지합니다.

9. 국외 이전
국외 사업자 서비스 사용 시 다음 사항을 고지하고 동의를 받습니다: 이전받는 자, 국가, 이전 항목, 이전 시점·방법, 보유·이용 기간.

10. 이용자 권리와 행사 방법
이용자는 개인정보 열람·정정·삭제·처리정지·동의 철회를 요구할 수 있습니다. 앱 내 메뉴 또는 고객센터(연락처: 없음, 개설 예정)로 신청할 수 있습니다. 대리인 행사 시 위임장을 제출할 수 있습니다.

11. 자동화된 의사결정(프로파일링)
개인화 추천에 자동화 처리가 포함될 수 있습니다. 이용자는 설명 요구, 이의 제기, 수동처리를 요구할 수 있습니다.

12. 쿠키 및 광고식별자
쿠키/ADID는 로그인 유지, 개인화, 성과 측정에 사용됩니다. 이용자는 브라우저·단말 설정에서 거부할 수 있습니다.

13. 안전성 확보조치
관리적: 권한 최소화, 정기 교육, 내부 규정. 기술적: 암호화(전송·저장), 접근통제, 취약점 점검, 로그 모니터링. 물리적: 전산실 출입통제, 백업.

14. 아동의 개인정보
만 14세 미만 아동의 가입·처리는 법정대리인 동의를 필요로 하며, 회사는 원칙적으로 아동 대상 서비스를 제공하지 않습니다.

15. 개인정보 보호책임자(DPO)
성명: 지정 예정
연락처: 없음(개설 예정)
주소: 광주광역시

16. 고지의 의무
본 방침은 2025-08-19 제정되었습니다. 변경 시 사전 공지합니다. 버전: v1.0
''';

const String kMARKETING_TEXT = '''
마케팅 수신 동의

회사는 서비스 개선 및 신규 서비스 안내를 위해 이메일, SMS, 푸시 알림 등을 통해 마케팅 정보를 발송할 수 있습니다.

수신에 동의하지 않으셔도 서비스 이용에는 제한이 없습니다.

... (이하 생략)
''';

const String kLOCATION_TEXT = '''
위치정보 이용약관

제1조(목적)
본 약관은 회사가 제공하는 위치기반서비스의 이용조건 및 절차에 관한 사항을 규정합니다.

제2조(위치정보의 수집·이용)
수집항목: GPS, 기지국, Wi‑Fi 기반 위치 좌표, 시간 정보, 이동 경로.
이용목적: 주변 명소·음식점·숙소 추천, 동선 기반 일정 제안, 현 위치 기반 알림 제공.

제3조(동의 및 철회)
회사는 개인위치정보 주체의 동의를 얻어 위치기반서비스를 제공합니다.
이용자는 언제든지 동의를 철회할 수 있으며, 철회 시 관련 서비스 제공이 제한될 수 있습니다.

제4조(보유 및 파기)
개인위치정보는 이용목적 달성 후 지체 없이 파기합니다.
「위치정보법」에 따라 위치정보 이용·제공 사실 확인자료는 최소 6개월 보관합니다.

제5조(제3자 제공)
원칙적으로 제공하지 않으며, 필요 시 제공받는 자·목적·항목·보유기간을 개별 동의 후 제공합니다.

제6조(권리)
이용자 및 법정대리인은 개인위치정보 열람·고지 요구, 정정·삭제, 동의 철회를 요구할 수 있습니다.

제7조(손해배상)
회사가 법령을 위반하여 손해가 발생한 경우 손해를 배상합니다. 배상책임의 범위·한도는 이용약관의 규정을 따릅니다.

제8조(분쟁조정)
위치정보와 관련한 분쟁은 협의로 해결하며, 불성립 시 방송통신위원회 또는 한국인터넷진흥원 위치정보분쟁조정위원회에 조정을 신청할 수 있습니다.

부칙
시행일: 2025-08-19, 버전: v1.0
''';

const String kOSS_TEXT = '''
Routour 오픈소스 라이선스 고지

본 서비스는 다음 오픈소스 소프트웨어를 사용하며, 각 라이선스 조건을 준수합니다.
Flutter
License: BSD 3-Clause License
Copyright © 2013–현재, The Flutter Authors
License 전문: https://github.com/flutter/flutter/blob/master/LICENSE
Dart
License: BSD 3-Clause License
Copyright © 2012–현재, The Dart Project Authors
License 전문: https://github.com/dart-lang/sdk/blob/main/LICENSE
Firebase SDKs (Authentication, Firestore Database, Storage 등)
License: Apache License 2.0
Copyright © Google LLC
License 전문: https://github.com/firebase/firebase-ios-sdk/blob/main/LICENSE
''';

const String kSERVICE_POLICY_TEXT = '''
서비스 운영정책

1. 계정 정책
가입 요건: 본인 소유 연락처·이메일 사용. 다중 계정·대여·양도 금지.
휴면: 12개월 이상 미접속 시 휴면 전환 및 별도 고지 후 분리 보관.
탈퇴: 앱 내에서 즉시 가능. 탈퇴 후 재가입 제한 기간을 둘 수 있음(예: 30일).

2. 등급·제재 체계
경미 위반: 경고·게시물 숨김.
반복·중대 위반: 일정 기간 이용정지(예: 3/7/30일) 또는 영구 제한.
위반 예: 스팸, 욕설·혐오표현, 음란·노출, 불법정보, 권리침해, 허위 리뷰·조작, 크롤링·스크래핑, 자동화 도구 사용.

3. 콘텐츠 가이드라인
리뷰는 직접 경험 기반, 사실과 의견을 구분할 것.
저작권·초상권이 있는 콘텐츠는 권리자의 허락 없이 게시 금지.
공공데이터 인용 시 출처 명기 권장(예: TourAPI).

4. 신고·이의제기 절차
앱 내 신고 버튼 또는 이메일(연락처: 없음). 접수→임시조치→심사→결과 통보.
임시조치 기간 중 게시자는 이의 신청 가능.

5. 광고·프로모션
광고성 정보 발송은 이용자의 사전 동의를 받은 채널에 한함(푸시/이메일/문자).
수신 철회는 설정에서 즉시 가능.

6. 포인트·쿠폰(도입 시)
유효기간, 사용 조건, 소멸 규정을 명시. 부정 적립·사용 시 회수 가능.

7. 청약철회·환불(유료 기능 운영 시)
제공 시작 전: 전액 환불.
제공 시작 후: 법령 및 마켓 정책에 따름. 하자·미제공 시 환불.

8. 서비스 가용성
정기 점검: 필요 시 사전 공지(예: 매주 수요일 02:00–04:00 KST).
장애 공지: 심각도 기준에 따라 신속 공지 및 사후 리포트 제공.

9. 취약점 신고(보안)
비공개 채널로 제보(연락처: 없음). 법 위반 스캐닝·침투 테스트 금지. 합리적 범위 내 감사 표시.

10. 데이터 접근 투명성
마이데이터(내보내기) 및 삭제 요청 경로 제공 예정. 처리 기한 목표 10일.

11. 연락처
고객센터 연락처: 없음(개설 예정). 공지사항으로 대체할 수 있습니다.
''';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool magazineAlarm = true;
  bool infoAlarm = true;

  LocationAccessOption locationAccess = LocationAccessOption.wifi;
  String albumAccess = '모든 사진 허용';

  String _getLocationAccessText(LocationAccessOption option) {
    switch (option) {
      case LocationAccessOption.none:
        return '사용 안함';
      case LocationAccessOption.wifi:
        return 'Wi-Fi 설정시';
      case LocationAccessOption.always:
        return '항상 사용';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('설정', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          const _SectionSpacer(),
          _SectionTitle('프로필 및 계정'),
          _ArrowTile(title: '프로필 및 계정', onTap: () {}),

          const _SectionSpacer(),
          _SectionTitle('알림'),
          _SwitchTile(
            title: '매거진 알림',
            value: magazineAlarm,
            onChanged: (v) => setState(() => magazineAlarm = v),
          ),
          _SwitchTile(
            title: '정보 및 이벤트 알림',
            value: infoAlarm,
            onChanged: (v) => setState(() => infoAlarm = v),
          ),

          const _SectionSpacer(),
          _SectionTitle('서비스'),
          _LinkTile(
            title: '위치 서비스',
            trailingText: _getLocationAccessText(locationAccess),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: LocationAccessOption.values.map((option) {
                      return RadioListTile<LocationAccessOption>(
                        title: Text(_getLocationAccessText(option)),
                        value: option,
                        groupValue: locationAccess,
                        onChanged: (value) {
                          setState(() => locationAccess = value!);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          _LinkTile(
            title: '앨범',
            trailingText: albumAccess,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('사진 선택 허용'),
                      onTap: () {
                        setState(() => albumAccess = '일부 사진만 접근');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('모든 사진 허용'),
                      onTap: () {
                        setState(() => albumAccess = '모든 사진 허용');
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('허용 안함'),
                      onTap: () {
                        setState(() => albumAccess = '허용 안함');
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),

          const _SectionSpacer(),
          _SectionTitle('고객지원'),
          _ArrowTile(title: '공지사항', onTap: () {}),
          _ArrowTile(title: '고객센터', onTap: () {}),

          const _SectionSpacer(),
          _SectionTitle('서비스 약관'),
          _TermsStatusSection(),

          const _SectionSpacer(),
          _VersionTile(
            version: '1.0',
            onTap: () {
              Navigator.pushNamed(context, '/version_info');
            },
          ),

          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () async {
                try {
                  await authVM.signOut();
                } catch (_) {}
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ===== Helper Widgets =====

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
    );
  }
}

class _SectionSpacer extends StatelessWidget {
  const _SectionSpacer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Container(height: 8, color: const Color(0xFFF0F0F0));
}

class _ArrowTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _ArrowTile({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchTile({Key? key, required this.title, required this.value, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  final String title;
  final String trailingText;
  final VoidCallback onTap;
  const _LinkTile({Key? key, required this.title, required this.trailingText, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15))),
            Text(trailingText, style: const TextStyle(color: Colors.lightBlue, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _VersionTile extends StatelessWidget {
  final String version;
  final VoidCallback onTap;
  const _VersionTile({Key? key, required this.version, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            const Expanded(child: Text('버전 정보', style: TextStyle(fontSize: 15))),
            Text(version, style: const TextStyle(color: Colors.lightBlue, fontSize: 14)),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

/// 약관 동의 현황 섹션: Firestore의 users/{uid}/terms 를 읽어와 표시
class _TermsStatusSection extends StatelessWidget {
  Map<String, dynamic> _asMap(dynamic v) {
    if (v is Map) {
      return v.map((k, value) => MapEntry(k.toString(), value));
    }
    return <String, dynamic>{};
  }

  bool _agreed(dynamic node) {
    final m = _asMap(node);
    return (m['agreed'] as bool?) ?? false;
  }

  String _version(dynamic node) {
    final m = _asMap(node);
    return (m['version'] as String?) ?? '';
  }

  String _at(dynamic node) {
    final m = _asMap(node);
    final at = m['at'];
    if (at is Timestamp) {
      final dt = at.toDate();
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }
    return '';
  }
  @override
  Widget build(BuildContext context) {
    final current = FirebaseAuth.instance.currentUser;
    if (current == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('로그인이 필요합니다.', style: TextStyle(color: Colors.grey)),
      );
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(current.uid);

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: docRef.snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: LinearProgressIndicator(minHeight: 2),
          );
        }
        if (!snap.hasData || !snap.data!.exists) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('프로필 정보를 불러올 수 없습니다.', style: TextStyle(color: Colors.redAccent)),
          );
        }

        final data = snap.data!.data()!;
        final terms = _asMap(data['terms']);

        String _status(bool b) => b ? '동의됨' : '미동의';

        final tosNode = _asMap(terms['tos']);
        final priNode = _asMap(terms['privacy']);
        final mktNode = _asMap(terms['marketing']);
        final locNode = _asMap(terms['location']);

        final tos = _status(_agreed(tosNode));
        final privacy = _status(_agreed(priNode));
        final marketing = _status(_agreed(mktNode));
        final location = _status(_agreed(locNode));

        return Column(
          children: [
            _StatusTile(
              title: '서비스 이용약관',
              status: tos,
              sub: _composeSub(_version(tosNode), _at(tosNode)),
              onTap: () async {
                final agreed = _agreed(tosNode);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => PolicyPage(title: '서비스 이용약관', body: kTOS_TEXT, initialAgree: agreed)),
                );
                if (result != null) {
                  await docRef.set({
                    'terms': {
                      'tos': {
                        'agreed': result,
                        'version': 'v1.0',
                        'at': FieldValue.serverTimestamp(),
                      }
                    }
                  }, SetOptions(merge: true));
                }
              },
            ),
            _StatusTile(
              title: '개인정보 처리방침',
              status: privacy,
              sub: _composeSub(_version(priNode), _at(priNode)),
              onTap: () async {
                final agreed = _agreed(priNode);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => PolicyPage(title: '개인정보 처리방침', body: kPRIVACY_TEXT, initialAgree: agreed)),
                );
                if (result != null) {
                  await docRef.set({
                    'terms': {
                      'privacy': {
                        'agreed': result,
                        'version': 'v1.0',
                        'at': FieldValue.serverTimestamp(),
                      }
                    }
                  }, SetOptions(merge: true));
                }
              },
            ),
            _StatusTile(
              title: '마케팅 수신 동의 (선택)',
              status: marketing,
              sub: _composeSub(_version(mktNode), _at(mktNode)),
              onTap: () async {
                final agreed = _agreed(mktNode);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => PolicyPage(title: '마케팅 수신 동의', body: kMARKETING_TEXT, initialAgree: agreed)),
                );
                if (result != null) {
                  await docRef.set({
                    'terms': {
                      'marketing': {
                        'agreed': result,
                        'version': 'v1.0',
                        'at': FieldValue.serverTimestamp(),
                      }
                    }
                  }, SetOptions(merge: true));
                }
              },
            ),
            _StatusTile(
              title: '위치정보 이용약관 (선택)',
              status: location,
              sub: _composeSub(_version(locNode), _at(locNode)),
              onTap: () async {
                final agreed = _agreed(locNode);
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(builder: (_) => PolicyPage(title: '위치정보 이용약관', body: kLOCATION_TEXT, initialAgree: agreed)),
                );
                if (result != null) {
                  await docRef.set({
                    'terms': {
                      'location': {
                        'agreed': result,
                        'version': 'v1.0',
                        'at': FieldValue.serverTimestamp(),
                      }
                    }
                  }, SetOptions(merge: true));
                }
              },
            ),
            const _SectionSpacer(),
            _SectionTitle('법적 고지'),
            _ArrowTile(
              title: '오픈소스 라이선스 고지 (열람)',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PolicyPage(title: '오픈소스 라이선스 고지', body: kOSS_TEXT, initialAgree: true)),
                );
              },
            ),
            _ArrowTile(
              title: '서비스 운영정책 (열람)',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PolicyPage(title: '서비스 운영정책', body: kSERVICE_POLICY_TEXT, initialAgree: true)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _composeSub(String version, String at) {
    if (version.isEmpty && at.isEmpty) return '';
    if (version.isNotEmpty && at.isNotEmpty) return '버전 $version · $at 동의';
    if (version.isNotEmpty) return '버전 $version';
    return '$at 동의';
  }
}

/// 상태가 있는 리스트 타일 (우측에 동의/미동의 표시)
class _StatusTile extends StatelessWidget {
  final String title;
  final String status;
  final String sub;
  final VoidCallback onTap;

  const _StatusTile({
    super.key,
    required this.title,
    required this.status,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == '동의됨' ? Colors.green : Colors.redAccent;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15)),
                  if (sub.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.4)),
              ),
              child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}