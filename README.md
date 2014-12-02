makam-symbolic-phrase-segmentation
==================================

Automatic Phrase Segmentation on symbolic scores for Ottoman-Turkish makam music





Türk Makam Müziği ezgi bölütleme Matlab araçları derlemesi
Barış Bozkurt, Bilge Karaçalı, M. Kemal Karaosmanoğlu
-----------------------------------------------------------------
Bu araç kullanıcıya Bahcesehir Universitesi'nin sağladığı site üzerinden sunulmuştur.

Bu araçları indirecek kullanıcı aşağıdaki koşullara uymayı kabul 
eder.

Bu derlemede sunulan araçlar:
- Ticari amaçla kullanılamaz: satılamaz, ticari bir ürün içerisinde veya ticari bir ürünün oluşturulmasında kullanılamaz.
- Dağıtım yetkisi sadece yazarlara aittir.  Kullanıcı dosyaları sadece araştırma amaçlı olarak kişisel kullanım için indirebilir, başka bir servis sunucu  üzerinden paylaşıma açamaz. 
- Kullanılırken oluşan tüm riskler kullanıcıya aittir.

Burada sunulan araçlar hiçbir ticari amaç güdülmeden kullanıma açılmıştır. Hazırlanmasına emek  harcayanlar bunun karşılığında 
araçların kullanıldığı yerlerde ve sonuçlandırılan çalışmaların rapor ve makalelerinde  aşağıda belirtilen makaleye referans verilmesini beklemektedirler:

B. Bozkurt, M. K. Karaosmanoglu, B. Karacali, E. Unal, Usul and Makam driven automatic melodic segmentation for Turkish music, submitted to Journal of New Music Research, 2013.

Dağıtım adresi: 
http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html

TESEKKUR
Bu araçlar, TUBITAK tarafından desteklenen 112E162 numaralı 1001 araştırma projesinde oluşturulmuştur. 

------------------------------------------------------------------
Istanbul                                               Subat, 2014
------------------------------------------------------------------

Kullanımla ilgili özet bilgiler: 

Kullanıcı “train_applySegmentation.m” fonksiyonunda bütün veri isleme adımlarını bulabilir. 

Kullanıma başlamadan once MIDI Toolbox: https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox indirilip kurulmalıdır çünkü bu araç kutusu içerisinden LBDM ve Tenney-Polansky algoritmaları öznitelik hesaplarında kullanılmaktadır. 

“train_applySegmentation.m” fonksiyonun üst satırında belirtilen klasör bilgilerini kendi bilgisayarındaki klasör bilgileriyle değiştiren kullanıcı bu fonksiyonu çağırdığında öğrenme, test ve uygulama adımların hepsinin uygulamasını yapabilecektir. Önerimiz ilk testlerin bu klasör içerisinde bulunan sampleData klasöründe sunulmuş verilerle yapılmasıdır. 

