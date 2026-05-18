import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:share_plus/share_plus.dart';
class MagazineDetailPage extends StatefulWidget {
  final String heroImage; // 상단 큰 이미지
  final String title; // 매거진 제목
  final List<String> hashtags; // 해시태그들
  final List<String> introParagraphs; // 본문 소개 문단들

  // 가게(섹션) 정보
  final String storeSectionTitle;
  final List<String> storeImages; // 가게 사진 3장
  final String storeDescription;
  final String openTime;
  final List<String> menuItems;
  final String addressTitle;
  final String addressDetail;

  const MagazineDetailPage({
    super.key,
    required this.heroImage,
    required this.title,
    required this.hashtags,
    required this.introParagraphs,
    required this.storeSectionTitle,
    required this.storeImages,
    required this.storeDescription,
    required this.openTime,
    required this.menuItems,
    required this.addressTitle,
    required this.addressDetail,
  });

  @override
  State<MagazineDetailPage> createState() => _MagazineDetailPageState();
}

class _MagazineDetailPageState extends State<MagazineDetailPage> {
  final PageController _storePageController = PageController();

  @override
  void dispose() {
    _storePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== 상단 이미지 & 뒤로가기 / 공유 =====
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Image.asset(widget.heroImage, fit: BoxFit.cover),
                  ),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _iconButton(context, Icons.arrow_back, () => Navigator.pop(context)),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: _iconButton(
                      context,
                      Icons.ios_share_outlined,
                      () async {
                        final box = context.findRenderObject() as RenderBox?;
                        final Uri uri = Uri.parse('https://routour.app/magazine?title=${Uri.encodeComponent(widget.title)}');
                        await Share.share(
                          '이 매거진을 확인해보세요!\n$uri',
                          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                        );
                      },
                    ),
                  ),
                ],
              ),

              // ===== 제목 & 해시태그 =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: widget.hashtags
                          .map((t) => Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey)))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // ===== 소개 본문 =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.introParagraphs
                      .map((p) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(p, style: const TextStyle(fontSize: 13, height: 1.6)),
                          ))
                      .toList(),
                ),
              ),

              // 라인
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
              ),

              // ===== 섹션 타이틀 =====
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Text(widget.storeSectionTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ),

              // 사진 슬라이더
              SizedBox(
                height: 140,
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _storePageController,
                        itemCount: widget.storeImages.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(widget.storeImages[index], fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SmoothPageIndicator(
                      controller: _storePageController,
                      count: widget.storeImages.length,
                      effect: WormEffect(
                        dotHeight: 6,
                        dotWidth: 6,
                        activeDotColor: Colors.black,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // 설명 텍스트
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(widget.storeDescription, style: const TextStyle(fontSize: 13, height: 1.6)),
              ),

              // 운영시간 & 메뉴 리스트
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(height: 6),
                          Text(widget.openTime, style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.menuItems.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text('${i + 1}. ${widget.menuItems[i]}', style: const TextStyle(fontSize: 12)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 주소 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.addressTitle, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Text(widget.addressDetail, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}