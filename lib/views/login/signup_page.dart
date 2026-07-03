import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routour/viewmodels/auth_viewmodel.dart';
import 'package:routour/views/settings/settings_page.dart' show kTOS_TEXT, kPRIVACY_TEXT, kMARKETING_TEXT, kLOCATION_TEXT, kOSS_TEXT, kSERVICE_POLICY_TEXT;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController(); // 표시 이름
  final nicknameController = TextEditingController(); // 닉네임(유니크 권장)

  bool agreeTos = false;          // [필수]
  bool agreePrivacy = false;      // [필수]
  bool agreeMarketing = false;    // [선택]
  bool agreeLocation = false;     // [선택]
  bool agreeOss = false;          // [선택] 열람 체크용
  bool agreeServicePolicy = false; // [선택] 열람 체크용

  Future<bool?> _openPolicyPage({
    required String title,
    required String body,
    required bool initialAgree,
  }) async {
    return await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PolicyPage(title: title, body: body, initialAgree: initialAgree),
        fullscreenDialog: true,
      ),
    );
  }

  bool _submitting = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    nicknameController.dispose();
    super.dispose();
  }

  Future<void> _signUp(AuthViewModel authVM) async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!agreeTos || !agreePrivacy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('필수 약관(서비스 이용약관/개인정보 처리방침)에 동의해야 합니다.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final ok = await authVM.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: nameController.text.trim(),
        nickname: nicknameController.text.trim(),
        agreeTos: agreeTos,
        agreePrivacy: agreePrivacy,
        agreeMarketing: agreeMarketing,
      );
      if (!mounted) return;
      if (ok) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '이름(표시 이름)'),
                  textInputAction: TextInputAction.next,
                  validator: (v) => (v == null || v.trim().isEmpty) ? '이름을 입력하세요' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nicknameController,
                  decoration: const InputDecoration(labelText: '닉네임(2자 이상)'),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return '닉네임을 입력하세요';
                    if (t.length < 2) return '닉네임은 2자 이상이어야 합니다';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: '이메일'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return '이메일을 입력하세요';
                    if (!RegExp(r'^.+@.+\..+$').hasMatch(t)) return '올바른 이메일을 입력하세요';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: '비밀번호(8자 이상)'),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    final t = v ?? '';
                    if (t.isEmpty) return '비밀번호를 입력하세요';
                    if (t.length < 8) return '비밀번호는 8자 이상이어야 합니다';
                    return null;
                  },
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 8),
                Text('약관 동의', style: Theme.of(context).textTheme.titleMedium),
                _PolicyTile(
                  title: '[필수] 서비스 이용약관 동의',
                  agreed: agreeTos,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '서비스 이용약관',
                      body: kTOS_TEXT,
                      initialAgree: agreeTos,
                    );
                    if (r != null) setState(() => agreeTos = r);
                  },
                ),
                _PolicyTile(
                  title: '[필수] 개인정보 처리방침 동의',
                  agreed: agreePrivacy,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '개인정보 처리방침',
                      body: kPRIVACY_TEXT,
                      initialAgree: agreePrivacy,
                    );
                    if (r != null) setState(() => agreePrivacy = r);
                  },
                ),
                _PolicyTile(
                  title: '[선택] 마케팅 수신 동의(푸시/이메일)',
                  agreed: agreeMarketing,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '마케팅 정보 수신 동의',
                      body: kMARKETING_TEXT,
                      initialAgree: agreeMarketing,
                    );
                    if (r != null) setState(() => agreeMarketing = r);
                  },
                ),
                _PolicyTile(
                  title: '[선택] 위치정보 이용약관 동의',
                  agreed: agreeLocation,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '위치정보 이용약관',
                      body: kLOCATION_TEXT,
                      initialAgree: agreeLocation,
                    );
                    if (r != null) setState(() => agreeLocation = r);
                  },
                ),
                _PolicyTile(
                  title: '[선택] 오픈소스 라이선스 고지',
                  agreed: agreeOss,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '오픈소스 라이선스 고지',
                      body: kOSS_TEXT,
                      initialAgree: agreeOss,
                    );
                    if (r != null) setState(() => agreeOss = r);
                  },
                ),
                _PolicyTile(
                  title: '[선택] 서비스 운영정책',
                  agreed: agreeServicePolicy,
                  onTap: () async {
                    final r = await _openPolicyPage(
                      title: '서비스 운영정책',
                      body: kSERVICE_POLICY_TEXT,
                      initialAgree: agreeServicePolicy,
                    );
                    if (r != null) setState(() => agreeServicePolicy = r);
                  },
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitting ? null : () => _signUp(authVM),
                  child: _submitting
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('회원가입'),
                ),
                const SizedBox(height: 12),
                if (authVM.message.isNotEmpty)
                  Text(authVM.message, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PolicyTile extends StatelessWidget {
  final String title;
  final bool agreed;
  final VoidCallback onTap;
  const _PolicyTile({required this.title, required this.agreed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = agreed ? Colors.green : Colors.redAccent;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Text(agreed ? '동의됨' : '미동의', style: TextStyle(color: color, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class PolicyPage extends StatefulWidget {
  final String title;
  final String body;
  final bool initialAgree;
  const PolicyPage({super.key, required this.title, required this.body, required this.initialAgree});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  late bool agreed = widget.initialAgree;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('닫기'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SingleChildScrollView(
                child: Text(
                  widget.body,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).padding.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Checkbox(value: agreed, onChanged: (v) => setState(() => agreed = v ?? false)),
                    const Expanded(child: Text('위 약관을 모두 읽었으며 동의합니다.')),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, agreed),
                  child: const Text('확인'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}