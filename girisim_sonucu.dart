import 'package:flutter/material.dart';
import 'main.dart'; // Ana sayfaya dönebilmek için
import 'gradient_background.dart'; // GradientBackground widget'ını içeri aktar

class GirisSonucSayfasi extends StatelessWidget {
  final int girisim;

  const GirisSonucSayfasi({Key? key, required this.girisim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Renkler ve mesajlar için veri yapısı
    final Map<int, Map<String, dynamic>> treatmentData = {
      1: {
        "message": "Bu hastaya nonfarmakolojik girişimler öneriliyor.",
        "color": Colors.green,
        "icon": Icons.nature_people,
        "details": "Dinlenme, fizik tedavi, masaj, sıcak/soğuk uygulama gibi yöntemler içerir."
      },
      2: {
        "message": "Bu hastaya nonfarmakolojik girişimler ve nonopioid analjezikler öneriliyor.",
        "color": Colors.orange,
        "icon": Icons.medical_services,
        "details": "Parasetamol, NSAID'ler (ibuprofen) gibi hafif ağrı kesicilerle kombine tedavi."
      },
      3: {
        "message": "Bu hastaya opioid grubu analjezikler öneriliyor.",
        "color": Colors.red,
        "icon": Icons.warning_rounded,
        "details": "Morfin, tramadol gibi güçlü ağrı kesiciler. Yan etkilere dikkat edilmeli!"
      },
    };

    // Seçilen tedaviye göre verileri al
    final data = treatmentData[girisim] ?? {
      "message": "Girişim önerisi bulunamadı.",
      "color": Colors.grey,
      "icon": Icons.error,
      "details": "Lütfen geçerli bir hasta verisi giriniz."
    };

    return Scaffold(
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TEDAVİ KARTI
              GestureDetector(
                onTap: () => _showDetailsDialog(context, data),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: data["color"], width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(data["icon"], size: 50, color: data["color"]),
                        SizedBox(height: 15),
                        Text(
                          data["message"],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: data["color"],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Detaylar için dokunun",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ANA SAYFA BUTONU
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // primary yerine
                  foregroundColor: Colors.black, // onPrimary yerine
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AnaSayfa()),
                        (route) => false,
                  );
                },
                child: Text("Ana Sayfaya Dön"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // DETAY DİYALOGU
  void _showDetailsDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Tedavi Detayları",
          style: TextStyle(color: data["color"]),
        ),
        content: Text(data["details"]),
        actions: [
          TextButton(
            child: Text("Tamam", style: TextStyle(color: data["color"])),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}