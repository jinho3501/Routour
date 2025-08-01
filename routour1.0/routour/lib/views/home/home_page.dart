import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:routour/views/infomation/info_page.dart';
import 'package:routour/views/popular/popular_page.dart';
import 'package:routour/views/magazine/magazine.dart';
import 'package:routour/views/settings/settings_page.dart';
import 'package:routour/views/magazine/magazine_page.dart';
import '../../../../viewmodels/home_viewmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:math' as math;

import '../test/apii_test_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey<ScaffoldState>();
  final PageController _recentPageController = PageController(viewportFraction: 0.6);
  final PageController _infoPageController   = PageController();
  final ScrollController _scrollController   = ScrollController();

  bool _compactFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final shouldCompact = _scrollController.offset > 160; // threshold
      if (shouldCompact != _compactFab) {
        setState(() => _compactFab = shouldCompact);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _recentPageController.dispose();
    _infoPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        key: _drawerKey,
        backgroundColor: Colors.white,
        endDrawer: _buildEndDrawer(context),
        body: SafeArea(
          child: Builder(
            builder: (context) => SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/Logo/routour.png', width: 120, height: 40),
                        Row(
                          children: [
                            Image.asset('assets/Icon/planner.png', width: 24, height: 24),
                            const SizedBox(width: 12),
                            Image.asset('assets/Icon/search.png', width: 24, height: 24),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const ApiTestPage()),
                                );
                              },
                              child: Image.asset('assets/Icon/menu.png', width: 24, height: 24),
                            ),
                            // GestureDetector(
                            //   onTap: () => Scaffold.of(context).openEndDrawer(),
                            //   child: Image.asset('assets/Icon/menu.png', width: 24, height: 24),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("지금 인기 있는 여행지", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PopularPage()),
                            );
                          },
                          child: const Text("더보기", style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildRecommendationCard("ACC 투어", "광주광역시", "assets/Dummy/dum1.png"),
                          const SizedBox(width: 10),
                          buildRecommendationCard("기아 타이거즈 투어", "광주광역시", "assets/Dummy/dum2.png"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("내가 원하는 여행의 컨셉", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate(5, (index) {
                            final imagePath = 'assets/Dummy/category/ca_${index + 1}.svg';
                            final labels = ['스포츠', '문화', '식도락', '자연', '관광'];
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey[200],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(labels[index], style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[200],
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.arrow_forward, size: 24, color: Color(
                                        0xDD494949)),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text("더보기", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("당신만의 정보와 혜택", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const InfoPage()),
                              );
                          },
                          child: const Text("더보기", style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 160,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/Dummy/Event/event_${index + 1}.png',
                              width: 200,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("여행 매거진", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MagazineListPage()),
                            );
                          },
                          child: const Text("더보기", style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildMagazineCard("🥐전국 빵돌이 빵순이 다 모여라", "전국에서 내놓으라는 빵집들은 다 모였다.", "assets/Dummy/magazine/m1.png"),
                          buildMagazineCard("야경 명소 집합", "까만 밤속 화려한 불빛들을 보러...", "assets/Dummy/magazine/m2.png"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: _plannerFab(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildEndDrawer(BuildContext context) {
    return Drawer(
      width: 320,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero, // 양옆 여백 제거
            children: [
              // ===== 상단 아이콘 행 (닫기 / 알림 / 설정) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, size: 25),
                    ),
                    const Spacer(),
                    Image.asset('assets/Icon/bell.png', width: 20, height: 20),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SettingsPage()),
                        );
                      },
                      child: Image.asset('assets/Icon/settings.png', width: 20, height: 20),
                    ),
                  ],
                ),
              ),

              // ===== 프로필 영역 =====
              const SizedBox(height: 8),
              Center(
                child: Column(
                  children: const [
                    CircleAvatar(radius: 42, backgroundColor: Color(0xFFD9D9D9)),
                    SizedBox(height: 12),
                    Text('진호', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text(
                      '프로필 편집',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w200,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== 4개 바로가기 버튼 =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shortcutBox(iconPath: 'assets/Icon/suitcase.png', label: '내 여행'),
                    _shortcutBox(iconPath: 'assets/Icon/heart.png', label: '좋아요'),
                    _shortcutBox(iconPath: 'assets/Icon/gallery.png', label: '나의 앨범'),
                    _shortcutBox(iconPath: 'assets/Icon/suitcase.png', label: '내 여행'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== 포인트 / 쿠폰 카드 =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Container(
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: Border.all(width: 0.5, color: Color(0xFFC0C0C0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('포인트', style: TextStyle(fontSize: 16)),
                          Row(
                            children: [
                              const Text('1,300', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              const SizedBox(width: 4),
                              Image.asset('assets/Icon/point.png', width: 26, height: 26),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5, color: Color(0xFFC0C0C0)),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('쿠폰', style: TextStyle(fontSize: 13)),
                          Text('13', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ===== 회색 구분선 (최근 본 항목 위) =====
              const SizedBox(height: 24),
              Container(height: 10, color: Color(0xFFF0F0F0)),

              // ===== 최근 본 항목 =====
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 18, 0, 12),
                child: const Text('최근 본 항목', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 28),
                  children: [
                    _buildRecentThumbnailWithText('기아 타이거즈..', '광주광역시', 'assets/Dummy/dum2.png'),
                    const SizedBox(width: 12),
                    _buildRecentThumbnailWithText('ACC 투어', '광주광역시', 'assets/Dummy/dum1.png'),
                    const SizedBox(width: 12),
                  ],
                ),
              ),

              // ===== 회색 구분선 (최근 본 항목 아래) =====
              const SizedBox(height: 16),
              Container(height: 10, color: Color(0xFFF0F0F0)),

              // ===== 정보 배너 & 인디케이터 =====
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _infoPageController,
                        itemCount: 3,
                        itemBuilder: (_, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              'assets/Dummy/Event/event_${index + 1}.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SmoothPageIndicator(
                      controller: _infoPageController,
                      count: 3,
                      effect: const WormEffect(
                        dotHeight: 7,
                        dotWidth: 7,
                        activeDotColor: Colors.black,
                        dotColor: Color(0xFFB9B8B8),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // ===== 공지/고객센터 버튼 =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCF9F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Center(
                          child: Text('공지 사항', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      VerticalDivider(width: 1, thickness: 1, color: Color(0xFFBFBFBF)),
                      Expanded(
                        child: Center(
                          child: Text('고객 센터', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12))
      ],
    );
  }

  Widget _shortcutBox({required String iconPath, required String label}) {
    return Column(
      children: [
        Container(
          width: 59,
          height: 59,
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Center(child: Image.asset(iconPath, width: 30, height: 30)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
      ],
    );
  }

  Widget _buildRecentThumbnail(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(imagePath, width: 60, height: 60, fit: BoxFit.cover),
    );
  }

  Widget _buildRecentThumbnailWithText(String title, String subtitle, String imagePath) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(imagePath, width: 100, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis),
        Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget buildRecommendationCard(String title, String location, String imagePath) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMagazineCard(String title, String description, String imagePath) {
    return InkWell(
      onTap: () {
        Navigator.push(
          _drawerKey.currentContext!,
          MaterialPageRoute(
            builder: (_) => MagazineDetailPage(
              heroImage: imagePath,
              title: title,
              hashtags: ['#빵순이', '#빵돌이', '#베이커리'],
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
                  '궁전제과는 1973년에 설립된 지역 대표 베이커리로, 50년이 넘는 전통을 자랑합니다. 광주 시민들에게는 추억의 빵집으로, 외지인들에게는 “광주의 성심당”이라 불릴 정도로 유명한 곳입니다. 본점은 동구 충장로에 있으며, 1층은 베이커리 매장, 2층은 카페 공간으로 운영되어 빵과 음료를 즐길 수 있습니다.',
              openTime: '10:00 ~ 21:30',
              menuItems: const ['공룡알빵', '나비파이', '고구마 브리오슈', '소금빵', '베이글'],
              addressTitle: '궁전제과',
              addressDetail: '광주광역시 동구 충장로 93-6',
            ),
          ),
        );
      },
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 240,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Image.asset('assets/Logo/routour.png', width: 30),
          ],
        ),
      ),
    );
  }

  Widget _plannerFab() {
    final double maxWidth = math.min(MediaQuery.of(context).size.width - 32, 180);
    final double minWidth = 56;

    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        width: _compactFab ? minWidth : maxWidth,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // 더 사진(이미지) 같은 느낌의 그라데이션 & 그림자
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF7DD5FF), Color(0xFF3BB9FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              offset: const Offset(0, 6),
              blurRadius: 18,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _onPlannerTap,
            child: Row(
              mainAxisAlignment:
                  _compactFab ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                const SizedBox(width: 18),
                Image.asset('assets/Icon/planner2.png', width: 22, height: 22),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  child: _compactFab
                      ? const SizedBox(width: 0)
                      : const SizedBox(width: 8),
                ),
                // 텍스트 페이드 인/아웃
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _compactFab ? 0 : 1,
                    duration: const Duration(milliseconds: 160),
                    child: _compactFab
                        ? const SizedBox.shrink()
                        : const Text(
                            '여행 일정 짜기',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPlannerTap() {
    // TODO: Navigate to planner page
  }
}
