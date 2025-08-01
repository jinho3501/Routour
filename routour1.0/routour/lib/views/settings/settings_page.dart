import 'package:flutter/material.dart';
enum LocationAccessOption { none, wifi, always }


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
          _ArrowTile(title: '서비스 이용약관', onTap: () {}),
          _ArrowTile(title: '개인정보 처리방침', onTap: () {}),
          _ArrowTile(title: '위치정보 이용약관', onTap: () {}),
          _ArrowTile(title: '서비스 운영정책', onTap: () {}),

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
              onPressed: () {},
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