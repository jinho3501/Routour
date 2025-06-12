import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 필요시 배경색 지정
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 타이틀
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text → Logo 이미지로 교체
                    Image.asset(
                      'assets/Logo/routour.png',
                      width: 120,  // 원하는 크기로 조절
                      height: 40,
                    ),

                    Row(
                      children: [
                        Image.asset('assets/Icon/planner.png', width: 24, height: 24),
                        const SizedBox(width: 12),
                        Image.asset('assets/Icon/search.png', width: 24, height: 24),
                        const SizedBox(width: 12),
                        Image.asset('assets/Icon/menu.png', width: 24, height: 24),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text("지금 인기 있는 여행지", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // 추천 이미지 카드들 (Stack)
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

                const SizedBox(height: 20),
                const Text("내가 원하는 여행의 컨셉", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // 카테고리 버튼
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(6, (i) {
                    return Image.asset('assets/Ellipse ${7 + i}.png', width: 56, height: 56);
                  }),
                ),

                const SizedBox(height: 24),
                const Text("여행 매거진", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                buildMagazineCard(
                  "🥐전국 빵돌이 빵순이 다 모여라",
                  "전국에서 내놓으라는 빵집들은 다 모였다.",
                  "assets/image.png",
                ),
                buildMagazineCard(
                  "야경 명소 집합",
                  "까만 밤속 화려한 불빛들을 보러...",
                  "assets/image.png",
                ),

                const SizedBox(height: 40),

                // 하단 버튼
                Center(
                  child: Container(
                    width: 160,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/Planner.png', width: 20, height: 20),
                        const SizedBox(width: 8),
                        const Text(
                          "여행 일정 짜기",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRecommendationCard(String title, String location, String imagePath) {
    return Container(
      width: 200, // 고정된 너비 추천
      margin: const EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          Image.asset(imagePath, width: double.infinity, height: 154, fit: BoxFit.cover),
          Positioned(
            bottom: 16,
            left: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}