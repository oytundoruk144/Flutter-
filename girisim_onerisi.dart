import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart'; // SystemChrome için eklendi
import 'girisim_sonucu.dart';
import 'gradient_background.dart';

class GirisimOnerisiSayfasi extends StatefulWidget {
  @override
  _GirisimOnerisiSayfasiState createState() => _GirisimOnerisiSayfasiState();
}

class _GirisimOnerisiSayfasiState extends State<GirisimOnerisiSayfasi> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  int? _painLevel;
  int _age = 0;
  int? _skb;
  int? _dkb;
  int? _nabiz;
  int? _spo2;
  int? _ss;

  @override
  void initState() {
    super.initState();
    // Status bar rengini ayarla
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    // Orijinal status bar ayarlarına dön
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < 7) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex++);
    } else {
      _sendData();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentIndex--);
    }
  }

  // API KODU
  Future<void> _sendData() async {
    final url = Uri.parse('http://<<ip-adresin>>:5000/girisim');
    final body = jsonEncode({
      "yas": _age,
      "agri": _painLevel,
      "skb": _skb,
      "dkb": _dkb,
      "nbz": _nabiz,
      "spo2": _spo2,
      "ss": _ss
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        int girisimDegeri = decoded['giris_durumu'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GirisSonucSayfasi(girisim: girisimDegeri),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bağlantı hatası: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar'ı gradientin üstüne yerleştir
      appBar: AppBar(
        title: Text("Hasta Değerleri", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top), // Status bar yüksekliği kadar boşluk
          child: Column(
            children: [
              // İlerleme çubuğu
              LinearProgressIndicator(
                value: (_currentIndex + 1) / 7,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 4,
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    _buildQuestion("Hastanın yaşını giriniz.", Icons.person, (value) => _age = int.tryParse(value) ?? 0),
                    _buildDropdownQuestion("Hastanın ağrı derecesini giriniz (1-10).", Icons.medical_services,
                        List.generate(10, (i) => (i + 1).toString()), (value) => _painLevel = int.tryParse(value)),
                    _buildQuestion("Hastanın sistolik kan basıncı (Büyük Tansiyon) değerini giriniz (60-160).",
                        Icons.monitor_heart, (value) => _skb = int.tryParse(value) ?? 0),
                    _buildQuestion("Hastanın diyastolik kan basıncı değerini giriniz (Küçük Tansiyon)(50-90).",
                        Icons.monitor_heart_outlined, (value) => _dkb = int.tryParse(value) ?? 0),
                    _buildQuestion("Hastanın nabız değerini giriniz (50-110).",
                        Icons.favorite, (value) => _nabiz = int.tryParse(value) ?? 0),
                    _buildQuestion("Hastanın oksijen satürasyonu değerini giriniz (90-100).",
                        Icons.bubble_chart, (value) => _spo2 = int.tryParse(value) ?? 0),
                    _buildQuestion("Hastanın dakikadaki solunum sayısını giriniz (10-28).",
                        Icons.air, (value) => _ss = int.tryParse(value) ?? 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(String question, IconData icon, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 20),
          Text(
            question,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: onChanged,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                hintText: "Değer girin",
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentIndex > 0)
                _buildNavigationButton("Geri", _previousPage, Icons.arrow_back),
              SizedBox(width: 20),
              _buildNavigationButton(
                _currentIndex == 6 ? "Sonuçları Gönder" : "İleri",
                _nextPage,
                _currentIndex == 6 ? Icons.send : Icons.arrow_forward,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownQuestion(String question, IconData icon, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.white),
          SizedBox(height: 20),
          Text(
            question,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            width: 200,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
              dropdownColor: Colors.white,
              icon: Icon(Icons.arrow_drop_down),
              items: options
                  .map((opt) => DropdownMenuItem(
                value: opt,
                child: Text(opt, textAlign: TextAlign.center),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() => onChanged(value!));
                _nextPage();
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 40),
          if (_currentIndex > 0)
            _buildNavigationButton("Geri", _previousPage, Icons.arrow_back),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(String text, VoidCallback onPressed, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue[800],
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
    );
  }
}