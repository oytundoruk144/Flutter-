from flask import Flask, request, jsonify
import numpy as np

app = Flask(__name__)

def yas_genc(x):return max(0, min((x - 7) / (20 - 7), (48 - x) / (48 - 20)))   # 7-20-48
def yas_orta(x):return max(0, min((x - 42) / (55 - 42), (68 - x) / (68 - 55)))
def yas_yasli(x):return max(0, min((x - 62) / (73 - 62), (83 - x) / (83 - 73)))
def yas_uzun_omur(x):return max(0, min((x - 77) / (99 - 77), 1))

def agri_hafif(x): return max(0, min((4.6 - x) / (4.6 - 1), 1))
def agri_orta(x):return max(0, min((x - 4.4) / (5 - 4.4), (6.6 - x) / (6.6 - 5)))
def agri_siddetli(x): return max(0, min((x - 6.4) / (10 - 6.4), 1))

def skb_dusuk(x):    return max(0, min((89.6 - x) / (89.6 - 60), 1))
def skb_normal(x):    return max(0, min((x - 89.4) / (105 - 89.4), (120.6 - x) / (120.6 - 105)))
def skb_preht(x):    return max(0, min((x - 120.4) / (130 - 120.4), (139.6 - x) / (139.6 - 130)))
def skb_ht(x):    return max(0, min((x - 139.4) / (300 - 139.4), 1))

def dkb_dusuk(x):    return max(0, min((59.6 - x) / (59.6 - 0), 1))
def dkb_normal(x):    return max(0, min((x - 59.4) / (70 - 59.4), (80.6 - x) / (80.6 - 70)))
def dkb_preht(x):    return max(0, min((x - 80.4) / (85 - 80.4), (89.6 - x) / (89.6 - 85)))
def dkb_ht(x):    return max(0, min((x - 89.4) / (170 - 89.4), 1))

def nbz_dusuk(x):   return max(0, min((59.6 - x) / (59.6 - 0), 1))
def nbz_normal(x): return max(0, min((x - 59.4) / (80 - 59.4), (100.6 - x) / (100.6 - 80)))
def nbz_yuksek(x):return max(0, min((x - 100.4) / (300 - 100.4), 1))

def spo2_dusuk(x): return max(0, min((x - 0) / (94.6 - 0), 1))
def spo2_normal(x):return max(0, min((x - 94.4) / (97 - 94.4), (100 - x) / (100 - 97)))

def ss_dusuk(x):return max(0, min((11.6 - x) / (11.6 - 0), 1))
def ss_normal(x): return max(0, min((x - 11.4) / (16 - 11.4), (20.6 - x) / (20.6 - 16)))
def ss_yuksek(x): return max(0, min((x - 20.4) / (60 - 20.4), 1))

def girisim_1(x):return max(0, min((x - 0.4) / (1 - 0.4), (1.6 - x) / (1.6 - 1)))
def girisim_2(x):return max(0, min((x - 1.4) / (2 - 1.4), (2.6 - x) / (2.6 - 2)))
def girisim_3(x):return max(0, min((x - 2.4) / (3 - 2.4), (3.6 - x) / (3.6 - 3)))

def girisim_karar(yas, agri, skb, dkb, nbz, spo2, ss):

    # Üyelik derecelerini hesapla

    g_g = yas_genc(yas)
    g_o = yas_orta(yas)
    g_y = yas_yasli(yas)
    g_u = yas_uzun_omur(yas)

    a_h = agri_hafif(agri)
    a_o = agri_orta(agri)
    a_s = agri_siddetli(agri)

    s_d = spo2_dusuk(spo2)
    s_n = spo2_normal(spo2)

    ss_d = ss_dusuk(ss)
    ss_n = ss_normal(ss)
    ss_y = ss_yuksek(ss)

    n_d = nbz_dusuk(nbz)
    n_n = nbz_normal(nbz)
    n_y = nbz_yuksek(nbz)

    sk_d = skb_dusuk(skb)
    sk_n = skb_normal(skb)
    sk_p = skb_preht(skb)
    sk_h = skb_ht(skb)

    dk_d = dkb_dusuk(dkb)
    dk_n = dkb_normal(dkb)
    dk_p = dkb_preht(dkb)
    dk_h = dkb_ht(dkb)


# Kural 1: Girişim = 1*
    puan1 = g_g + a_h + sk_n + dk_n + n_n + s_n + ss_n
# Kural 2: Girişim = 1*
    puan2 = g_o + a_h + sk_n + dk_n + n_y + s_d + ss_n
# Kural 3: Girişim = 1*
    puan3 = g_u + a_h + sk_n + dk_d + n_y + s_n + ss_y
# Kural 4: Girişim = 1*
    puan4 = g_g + a_h + sk_n + dk_n + n_n + s_n + ss_y
# Kural 5: Girişim = 1*
    puan5 = g_g + a_h + sk_p + dk_p + n_n + s_d + ss_y
# Kural 6: Girişim = 2*
    puan6 = g_o + a_o + sk_n + dk_n + n_y + s_d + ss_y
# Kural 7: Girişim = 2*
    puan7 = g_y + a_o + sk_p + dk_n + n_n + s_d + ss_n
# Kural 8: Girişim = 2*
    puan8 = g_u + a_o + sk_p + dk_p + n_y + s_d + ss_y
# Kural 9: Girişim = 2*
    puan9 = g_y + a_o + sk_h + dk_h + n_n + s_n + ss_y
# Kural 10: Girişim = 2*
    puan10 = g_u + a_o + sk_h + dk_n + n_n + s_d + ss_n
# Kural11: Girişim = 2*
    puan11 = g_u + a_o + sk_n + dk_d + n_n + s_d + ss_y
# Kural 12: Girişim = 2*
    puan12 = g_u + a_o + sk_h + dk_p + n_n + s_d + ss_n
# Kural 13: Girişim = 2*
    puan13 = g_u + a_o + sk_h + dk_d + n_n + s_d + ss_y
# Kural 14: Girişim = 3
    puan14 = g_y + a_s + sk_p + dk_p + n_n + s_n + ss_y
# Kural 15: Girişim = 3
    puan15 = g_o + a_s + sk_p + dk_p + n_y + s_d + ss_y
# Kural 16: Girişim = 3
    puan16 = g_u + a_s + sk_h + dk_n + n_y + s_n + ss_y
# Kural 17: Girişim = 3
    puan17 = g_y + a_s + sk_h + dk_d + n_n + s_n + ss_y
# Kural 18: Girişim = 3
    puan18 = g_y + a_s + sk_n + dk_n + n_n + s_n + ss_y
# Kural 19: Girişim = 3
    puan19 = g_u + a_s + sk_p + dk_n + n_n + s_n + ss_y



    # En yüksek puanı al
    puanlar = [puan1, puan2, puan3, puan4, puan5, puan6, puan7, puan8, puan9, puan10, puan11, puan12, puan13, puan14, puan15, puan16, puan17, puan18, puan19]
    max_index = np.argmax(puanlar)
    girisim = [1, 1,1,1,1, 2, 2, 2 , 2,  2, 2, 2, 2,3, 3 ,3, 3,3,3][max_index]
    return girisim


@app.route('/girisim', methods=["POST"])
def girisim_api():
    data = request.json

    try:
        yas = float(data["yas"])
        agri = float(data["agri"])
        skb = float(data["skb"])
        dkb = float(data["dkb"])
        nbz = float(data["nbz"])
        spo2 = float(data["spo2"])
        ss = float(data["ss"])

        sonuc = girisim_karar(yas, agri, skb, dkb, nbz, spo2, ss)
        return jsonify({"giris_durumu": sonuc})
    except Exception as e:
        return jsonify({"hata": str(e)}), 400


if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=5000)