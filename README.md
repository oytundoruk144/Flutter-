# 🩺 Bulanık Mantık Tabanlı Klinik Karar Destek Sistemi

Bu proje, **Flutter** ile geliştirilen bir mobil uygulama ve **Python (Flask)** tabanlı bir API’den oluşmaktadır.  
Uygulama, hastanın yaş, nabız, tansiyon, ağrı düzeyi, solunum sayısı, SpO₂ gibi temel verilerini alarak **bulanık mantık** yöntemi ile uygun tedavi/girişim önerisinde bulunur.

📌 **Not:** Bu sistem, eğitim ve araştırma amaçlıdır. Tıbbi kararlar için profesyonel sağlık personeline danışılmalıdır.

---

## 🚀 Özellikler
- 📱 **Flutter** ile modern, kullanıcı dostu mobil arayüz
- 🎨 Gradient arka plan tasarımı ile estetik görünüm
- 🌐 **Flask REST API** ile veri alışverişi
- 🧠 **Bulanık mantık tabanlı** karar desteği
- 📊 Tek bir net girişim önerisi sunma
- 🔗 Yerel ağ üzerinden API ile bağlantı

---

## 🛠 Kullanılan Teknolojiler
- **Flutter (Dart)**
- **Python (Flask)**
- **scikit-fuzzy** (Bulanık mantık)
- JSON tabanlı veri iletişimi

---

## 📂 Proje Yapısı
/lib -> Flutter uygulaması
/api -> Python Flask API kodları
/assets -> Görseller (logo, ikon vb.)
README.md -> Proje açıklaması



---

## ⚙️ Kurulum ve Çalıştırma

### 1️⃣ Flask API’yi başlat
```bash
cd api
python api.py
2️⃣ Flutter uygulamasında API adresini güncelle
lib/girisim_onerisi.dart dosyasında:


final url = Uri.parse('http://<ip-adresiniz>:5000/girisim');
💡 <ip-adresiniz> yerine terminalde Flask çalıştığında görünen 192.168.x.x şeklindeki adresi yazın.
Telefon ile bilgisayar aynı Wi-Fi ağında olmalıdır.

3️⃣ Flutter uygulamasını çalıştır

flutter run
📌 API Örnek İstek / Yanıt
İstek (POST /girisim)


{
  "yas": 45,
  "agri": 6,
  "skb": 120,
  "dkb": 80,
  "nbz": 90,
  "spo2": 95,
  "ss": 18
}
Yanıt


{
  "girisim": 2
}
📌 Yanıt değerleri:

1 → Nonfarmakolojik girişimler

2 → Nonfarmakolojik + Nonopioid analjezikler

3 → Opioid grubu analjezikler

🖼 Ekran Görüntüleri
Buraya uygulama ekran görüntülerini ekleyebilirsiniz:


![Ana Sayfa](assets/screenshot_home.png)
![Sonuç Sayfası](assets/screenshot_result.png)
📜 Lisans
Bu proje MIT lisansı ile lisanslanmıştır.



---

