import 'package:flutter/material.dart';
import '../../services/api/tourism_api_service.dart';

class ApiTestPage extends StatefulWidget {
  const ApiTestPage({Key? key}) : super(key: key);

  @override
  State<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends State<ApiTestPage> {
  final TourApiService _apiService = TourApiService();
  Map<String, dynamic>? _result;
  String _error = '';
  bool _isLoading = false;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final result = await _apiService.getAreaBasedList(
        pageNo: 1,
        numOfRows: 10,
        contentTypeId: "12",  // 관광지
      );
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 테스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('데이터 가져오기'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Text('에러: $_error', style: const TextStyle(color: Colors.red))
            else if (_result != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _result.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}