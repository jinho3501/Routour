import 'package:flutter/material.dart';
import 'magazine.dart'; // MagazineDetailPage가 들어있는 파일 경로 맞춰주세요

/// --- 모델 ---------------------------------------------------
class MagazineItem {
  final String id;
  final String title;
  final String thumb;              // 썸네일 이미지
  final List<String> tags;         // 해시태그(필터용)

  // 상세 페이지용 필드
  final String heroImage;
  final List<String> introParagraphs;
  final String storeSectionTitle;
  final List<String> storeImages;
  final String storeDescription;
  final String openTime;
  final List<String> menuItems;
  final String addressTitle;
  final String addressDetail;

  MagazineItem({
    required this.id,
    required this.title,
    required this.thumb,
    required this.tags,
    required this.heroImage,
    required this.introParagraphs,
    required this.storeSectionTitle,
    required this.storeImages,
    required this.storeDescription,
    required this.openTime,
    required this.menuItems,
    required this.addressTitle,
    required this.addressDetail,
  });
}

/// --- 더미 데이터 ---------------------------------------------
final List<MagazineItem> _dummyMagazines = [
  MagazineItem(
    id: 'm1',
    title: '🥐전국 빵돌이 빵순이 다 모여라',
    thumb: 'assets/Dummy/magazine/m1.png',
    tags: ['여행 꿀팁', '먹거리'],
    heroImage: 'assets/Dummy/magazine/m1.png',
    introParagraphs: const [
      '어느 도시는 골목 어귀에 늘 따뜻한 빵 냄새가 숨어 있습니다.',
      '유난히 바스락 소금빵 하나, 솜사탕만큼 크루아상 안에 담긴 정성, 오래된 기억을 닮은 달콤한 조각이 때로는 하루를 다독이기도 하죠.',
      '이번 매거진에서는 지역 곳곳의 빵집들을 따라 걸어봅니다. 유명보다 진심을 담은 곳, 재료에 진심인 사람들, 그리고 빵이 있는 풍경들을 천천히 기록했습니다.',
    ],
    storeSectionTitle: '궁전제과',
    storeImages: const [
      'assets/Dummy/magazine/b1.png',
      'assets/Dummy/magazine/b2.png',
      'assets/Dummy/magazine/b3.png',
    ],
    storeDescription:
    '궁전제과는 1973년에 설립된 지역 대표 베이커리로, 50년이 넘는 전통을 자랑합니다. 광주 시민들에게는 추억의 빵집으로...',
    openTime: '10:00 ~ 21:30',
    menuItems: const ['공룡알빵', '나비파이', '고구마 브리오슈', '소금빵', '베이글'],
    addressTitle: '궁전제과',
    addressDetail: '광주광역시 동구 충장로 93-6',
  ),
  MagazineItem(
    id: 'm2',
    title: '🌃야경 명소 집합',
    thumb: 'assets/Dummy/magazine/m2.png',
    tags: ['여행 꿀팁', '명소'],
    heroImage: 'assets/Dummy/magazine/m2.png',
    introParagraphs: const [
      '야경은 언제나 옳다!',
      '화려한 불빛 속 걷는 도심 산책 코스 공유합니다.'
    ],
    storeSectionTitle: 'OO 전망대',
    storeImages: const [
      'assets/Dummy/magazine/b1.png',
      'assets/Dummy/magazine/b2.png',
      'assets/Dummy/magazine/b3.png',
    ],
    storeDescription: '도심 속 최고의 야경 포인트를 소개합니다...',
    openTime: '18:00 ~ 24:00',
    menuItems: const ['전망 포인트 1', '포인트 2', '포인트 3'],
    addressTitle: 'OO 전망대',
    addressDetail: '어딘가의 도로 123',
  ),
];

/// --- 화면 ----------------------------------------------------
class MagazineListPage extends StatefulWidget {
  const MagazineListPage({super.key});

  @override
  State<MagazineListPage> createState() => _MagazineListPageState();
}

class _MagazineListPageState extends State<MagazineListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTag = '전체';
  late final List<String> _allTags;

  @override
  void initState() {
    super.initState();
    final tagSet = <String>{};
    for (final m in _dummyMagazines) {
      tagSet.addAll(m.tags);
    }
    _allTags = ['전체', ...tagSet];
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MagazineItem> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    return _dummyMagazines.where((m) {
      final tagOK = _selectedTag == '전체' || m.tags.contains(_selectedTag);
      final searchOK = q.isEmpty || m.title.toLowerCase().contains(q);
      return tagOK && searchOK;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('여행 매거진', style: TextStyle(color: Colors.black)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- 검색창 ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 20, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: '검색',
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- 태그 필터 ---
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  final tag = _allTags[i];
                  final selected = tag == _selectedTag;
                  return ChoiceChip(
                    label: Text(tag),
                    selected: selected,
                    showCheckmark: false,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontSize: 13,
                    ),
                    backgroundColor: const Color(0xFFF0F0F0),
                    selectedColor: const Color(0xFF58BFFF),
                    onSelected: (_) => setState(() => _selectedTag = tag),
                    shape: const StadiumBorder(
                      side: BorderSide(color: Colors.transparent),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: _allTags.length,
              ),
            ),

            const SizedBox(height: 12),

            // --- 목록 ---
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(child: Text('검색 결과가 없어요.'))
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
                itemCount: _filtered.length,
                itemBuilder: (_, index) => _magazineCard(_filtered[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _magazineCard(MagazineItem m) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MagazineDetailPage(
              heroImage: m.heroImage,
              title: m.title,
              hashtags: m.tags.map((t) => '#$t').toList(),
              introParagraphs: m.introParagraphs,
              storeSectionTitle: m.storeSectionTitle,
              storeImages: m.storeImages,
              storeDescription: m.storeDescription,
              openTime: m.openTime,
              menuItems: m.menuItems,
              addressTitle: m.addressTitle,
              addressDetail: m.addressDetail,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(m.thumb, height: 120, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          Text(
            m.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 4,
            runSpacing: -4,
            children: m.tags
                .map((t) => Text('#$t', style: const TextStyle(fontSize: 11, color: Colors.blueGrey)))
                .toList(),
          ),
          const SizedBox(height: 4),
          Image.asset('assets/Logo/routour.png', width: 32),
        ],
      ),
    );
  }
}