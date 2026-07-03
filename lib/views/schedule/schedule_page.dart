import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routour/viewmodels/schedule_viewmodel.dart';

/// ----- 단계 목록 -----
/// 0 시작 → 1 지역 → 2 동행 → 3 기간 → 4 컨셉 → 5 스타일 → 6 교통 → 7 좋아요 → (조건) 8 공유

// 0. 시작
class ScheduleStartPage extends StatelessWidget {
  const ScheduleStartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 90),
              Image.asset(
                'assets/Icon/schedule/robot.png',
                width: 135,
                height: 135,
              ),
              const SizedBox(height: 24),
              const Text(
                'AI 일정 짜기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Pretendard'),
              ),
              const SizedBox(height: 8),
              Text(
                '사용자 맞춤형 여행 일정짜기',
                style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500, fontFamily: 'Pretendard').copyWith(color: Colors.grey[600]),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    final vm = context.read<ScheduleViewModel>();
                    vm.reset();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegionPage()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF84D6FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    '일정 짜기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Pretendard'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// 1. 떠나는 여행지는?
class RegionPage extends StatelessWidget {
  const RegionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['광주광역시', '전라남도', '전라북도'];
    return _SurveyScaffold(
      icon: 'map.png',
      title: '떠나는 여행지는?',
      description: '여행 하는 지역을 선택해주세요\n다중 선택이 가능해요',
      children: options.map((o) {
        final selected = vm.region == o;
        return _SurveyButton(
          label: o,
          isSelected: selected,
          onTap: () => vm.setRegion(o),
        );
      }).toList(),
      onNext: vm.region != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CompanionPage()))
          : null,
      currentStep: 0,
      totalStep: 8,
    );
  }
}

/// 2. 누구와 함께?
class CompanionPage extends StatelessWidget {
  const CompanionPage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['혼자', '가족', '친구', '연인'];
    return _SurveyScaffold(
      icon: 'family.png',
      title: '누구와 함께 가나요?',
      description: '함께 여행할 대상을 선택하세요',
      children: options.map((o) {
        final selected = vm.companion == o;
        return _SurveyButton(
          label: o,
          isSelected: selected,
          onTap: () => vm.setCompanion(o),
        );
      }).toList(),
      onNext: vm.companion != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PeriodPage()))
          : null,
      currentStep: 1,
      totalStep: 8,
    );
  }
}

/// 3. 기간
class PeriodPage extends StatelessWidget {
  const PeriodPage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['1박2일', '2박3일', '3박4일', '4박5일'];
    return _SurveyScaffold(
      icon: 'schedule.png',
      title: '여행 기간은 몇일인가요?',
      description: '여행 일정을 선택하세요',
      children: options
          .map((o) => _SurveyButton(
                label: o,
                isSelected: vm.period == o,
                onTap: () => vm.setPeriod(o),
              ))
          .toList(),
      onNext: vm.period != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConceptPage()))
          : null,
      currentStep: 2,
      totalStep: 8,
    );
  }
}

/// 4. 컨셉
class ConceptPage extends StatelessWidget {
  const ConceptPage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['스포츠', '문화', '영화', '자연'];
    return _SurveyScaffold(
      icon: 'movie.png',
      title: '여행 컨셉은 뭔가요?',
      description: '여행의 테마를 골라주세요',
      children: options
          .map((o) => _SurveyButton(
                label: o,
                isSelected: vm.concept == o,
                onTap: () => vm.setConcept(o),
              ))
          .toList(),
      onNext: vm.concept != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StylePage()))
          : null,
      currentStep: 3,
      totalStep: 8,
    );
  }
}

/// 5. 스타일
class StylePage extends StatelessWidget {
  const StylePage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['휴식', '액티비티', '맛집'];
    return _SurveyScaffold(
      icon: 'mask.png',
      title: '여행 스타일은 뭔가요?',
      description: '여행에서 중요하게 생각하는 점을 골라주세요',
      children: options
          .map((o) => _SurveyButton(
                label: o,
                isSelected: vm.style == o,
                onTap: () => vm.setStyle(o),
              ))
          .toList(),
      onNext: vm.style != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransportPage()))
          : null,
      currentStep: 4,
      totalStep: 8,
    );
  }
}

/// 6. 이동수단
class TransportPage extends StatelessWidget {
  const TransportPage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    const options = ['자동차', '버스', '기차', '비행기'];
    return _SurveyScaffold(
      icon: 'bus.png',
      title: '무엇을 타고 여행하나요?',
      description: '여행 시 주로 이용할 교통수단을 선택하세요',
      children: options
          .map((o) => _SurveyButton(
                label: o,
                isSelected: vm.transport == o,
                onTap: () => vm.setTransport(o),
              ))
          .toList(),
      onNext: vm.transport != null
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LikePage()))
          : null,
      currentStep: 5,
      totalStep: 8,
    );
  }
}

/// 7. 좋아요 장소
class LikePage extends StatelessWidget {
  const LikePage({super.key});
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScheduleViewModel>();
    // TODO: DB 연결 전까지 더미
    const dummy = ['월드컵 경기장', '기아 챔피언스 필드', '명화 식당', '궁전제과', '패밀리 랜드', '아시아 문화 전당(ACC)'];
    return _SurveyScaffold(
      icon: 'heart.png',
      title: '좋아요 중 꼭 가보고 싶은 곳',
      description: '마음에 드는 곳을 모두 선택하세요',
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              child: Column(
                children: dummy.map((place) {
                  final picked = vm.liked.contains(place);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    child: FractionallySizedBox(
                      widthFactor: 0.83,
                      child: _SurveyButton(
                        label: place,
                        isSelected: picked,
                        onTap: () => vm.toggleLike(place),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
      onNext: () {
        if (vm.companion != '혼자') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SharePage()));
        } else {
          _finish(context, vm);
        }
      },
      nextLabel: '다음',
      currentStep: 6,
      totalStep: 8,
    );
  }

  void _finish(BuildContext context, ScheduleViewModel vm) {
    // TODO: DB 전송 or 알고리즘 호출
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}

/// 8. 공유
class SharePage extends StatelessWidget {
  const SharePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/Icon/schedule/share.png',
                width: 135,
                height: 135,
              ),
              const SizedBox(height: 24),
              const Text(
                '일정 짜기를 공유할까요?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '24시간 내 일정 짜기를 하면 결과들을 가지고 일정짜기',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  fontFamily: 'Pretendard',
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: share logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBCE4FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '공유하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF84D6FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '일정 짜기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----- 공통 위젯 -----
class _SurveyScaffold extends StatelessWidget {
  final String icon;
  final String title;
  final String? description;
  final List<Widget> children;
  final bool showNext;
  final VoidCallback? onNext;
  final String nextLabel;
  final int currentStep;
  final int totalStep;
  const _SurveyScaffold({
    required this.icon,
    required this.title,
    this.description,
    required this.children,
    this.showNext = true,
    this.onNext,
    this.nextLabel = '다음',
    required this.currentStep,
    required this.totalStep,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, leading: const BackButton(), backgroundColor: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    Image.asset('assets/Icon/schedule/$icon', height: 120),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Pretendard'),
                      textAlign: TextAlign.center,
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        description!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.normal, fontFamily: 'Pretendard'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 40),
                    // If LikePage's single Container was passed, render it directly (it has its own scroll)
                    if (children.length == 1 && children.first is Container)
                      Expanded(child: children.first)
                    else
                      ...[
                        if (children.length <= 3)
                          Column(
                            children: children.map((child) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                width: double.infinity,
                                height: 50,
                                child: child,
                              );
                            }).toList(),
                          )
                        else
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: children.map((child) {
                              return SizedBox(
                                width: (MediaQuery.of(context).size.width - 24 * 2 - 12) / 2,
                                height: 50,
                                child: child,
                              );
                            }).toList(),
                          ),
                      ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (showNext) ...[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalStep, (i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == currentStep ? const Color(0xFF7DD5FF) : const Color(0xFFE0E0E0),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: onNext != null ? const Color(0xFF7DD5FF) : const Color(0xFFE5E1E8),
                          foregroundColor: onNext != null ? Colors.white : const Color(0xFFA39EA8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(nextLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Pretendard')),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SurveyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  const _SurveyButton({required this.label, required this.onTap, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: isSelected ? const Color(0xFF84D6FF) : Colors.transparent, width: 2),
        backgroundColor: isSelected ? Colors.white : const Color(0xFFF4F4F4),
        foregroundColor: isSelected ? const Color(0xFF84D6FF) : Colors.grey[800],
        textStyle: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w500, fontSize: 16),
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}