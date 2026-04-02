# 1. Kapak Sayfası
**KASTAMONU ÜNİVERSİTESİ**
**MÜHENDİSLİK MİMARLIK FAKÜLTESİ**
**BİLGİSAYAR MÜHENDİSLİĞİ**

**DERS ADI VE KODU:** Nesneye Yönelik Programlama
**PROJE BAŞLIĞI:** C# .NET Kullanılarak Olay Güdümlü Bir İşletim Sistemi Çekirdeği ve Masaüstü Arayüzü (GUI) Simülasyonu Tasarımı (ElifOS)
**HAZIRLAYAN:** [Ad-Soyad], [Öğrenci No]
**TARİH:** 01.04.2026

---

# 2. Özet (Abstract)
Bu proje kapsamında; masaüstü işletim sistemi mimarisini, çoklu pencereleme (WM) mekanizmalarını ve temel sistem bileşenlerini uygulamalı olarak incelemek amacıyla C# programlama dili ve .NET Framework kullanılarak "ElifOS" adlı bir işletim sistemi (OS) simülasyonu geliştirilmiştir. Projede, saf donanım ve Assembly seviyesine inmek yerine, daha yüksek seviyeli bir dilde görev yönetimi (process management), bellek yönetimi (garbage collection & object disposal), kullanıcı etkileşimleri (interrupt mapping via event handling) ve sanal dosya sistemi (virtual in-memory file system) gibi çekirdek kavramlar nesne yönelimli programlama (OOP) teknikleriyle simüle edilmiştir. Proje, standart bir derleyici aracılığıyla (ms-csc) inşa edilmiş olup Windows ortamında direkt çalıştırılabilir çoklu bir işlem tabanı oluşturmaktadır.

# 3. Giriş
## Projenin Amacı
Bu projenin temel hedefi; dosya yöneticisi, görev yöneticisi, komut istemcisi (shell), medya oynatıcı ve web tarayıcı gibi tipik bir işletim sistemi bileşenlerinin çekirdek ile nasıl iletişim kurduğunu interaktif şekilde öğrenmektir. Teorik OS tasarımlarını (zamanlayıcılar, pencere form hiyerarşisi, sistem çağrıları) grafik tabanlı ve olay güdümlü bir ortamda pratiğe dökmek amaçlanmıştır.

## Kapsam
ElifOS; sadece 32/64-bit Windows mimarisi (CLR) üzerinde koşabilen, baştan sona grafiksel bir kullanıcı arayüzü (GUI) barındıran kompleks bir simülasyon platformudur.
İçerisinde:
* Dinamik çoklu görev destekleyen pencere yöneticisi (WM)
* Tema motoruna bağlı UI yönetimi (Koyu/Açık mod)
* Terminal üzerinden metin tabanlı komut işleme özelliği
* Sanal dosya oluşturma/okuma desteği ve gömülü sistem uygulamaları bulunmaktadır.

## Kullanılan Teknolojiler
* **Programlama Dili:** C# (C-Sharp) ve nesne yönelimli paradigması.
* **Geliştirme Ortamı ve Kütüphaneler:** .NET Framework, System.Windows.Forms (Çerçeve tamponu ve Canvas Render için), System.Threading.Tasks (Asenkron süreçler).
* **Derleyici:** Microsoft Command-line Compiler (`csc.exe`) aracılığıyla `build.bat` ile otomatik çevrim.

# 4. Sistem Mimarisi (System Architecture)
ElifOS, yapısal olarak "Olay-Güdümlü (Event-Driven) Özel Mikro-Çekirdek Simülasyonu" üzerine kuruludur.
## Çekirdek (Kernel) Yapısı
Projede çekirdek (`os_ui.cs` ana bloğu), klasik monolitik işletim sistemlerinden ziyade mikro-çekirdek felsefesine benzer. Temel donanım dinleme ve GUI işleme yükü ana bir döngüde tutulurken; hesap makinesi, oyunlar, terminal ve dosya gezgini gibi sistem hizmetleri, sadece çağrıldıklarında RAM üzerinde dinamik Control obijeleri olarak varlık gösteren ayrı alt-süreçler gibi ele alınır. 

## Önyükleme (Bootloading) Süreci
Sistemin ilk açılış süreci (`Program.cs` tetiklenmesi), ana pencerenin BSS ve Heap belleklerini tahsis etmesi ile başlar. İşletim sistemi devreye girdiğinde siyah bir önyükleme (login ekranı) penceresi başlatılır. İnternet modülleri asenkron olarak arka planda indirilirken (multithreaded fetch), UI iş parçacığında boot/clock animasyonu akar. Giriş sonrasında masaüstü yöneticisi `SetupDesktop()` başlatılır.

## Bellek Yönetimi (Memory Management)
Belirli bir Sayfalama (Paging) algoritmask yazmak yerine, .NET'in sunduğu CLR (Common Language Runtime) üzerinden Heap bellek haritası dinamik olarak tahsis edilmektedir. "Sistem kapat" tetiklenmediği sürece pencereler (process panel objeleri) ayrılan bellek diliminde yaşar. Bir uygulama (örneğin Dosya İşlemleri) sonlandırıldığında, işletim sistemi bilinçli bir biçimde `.Dispose()` yöntemini çağırıp pencereleri Çöp Toplayıcıya (Garbage Collector) göndererek RAM sızıntılarını (memory leak) önler.

# 5. Temel Bileşenler ve Tasarım Kararları
## Süreç Yönetimi (Process Management)
ElifOS'ta süreçler (processes), birer `Panel` ve arkaplanda çalışan `Task` blokları olarak ifade edilir. Tam anlamlı bir Round Robin scheduling (zamanlayıcı) algoritması yerine; Threading API üzerinden zaman dilimli (time-sliced) Olay Zamanlayıcıları (Timers) kullanılmıştır. (Örn: Yılan oyunu mantığının işletim sistemi ana thread'ini  dondurmaması için 110ms'lik bir Tick Timer scheduling'i kullanılarak bağımsız işleme alınmıştır.)

## Kesme Yönetimi (Interrupt Handling)
ElifOS donanım IDT tabloları tutmak yerine, farenin hareketi ve klavye tuş basımları (Event Listeners / Handlers) sistemi için Windows Mesaj Döngüsü'nü (Window Message Loop) kesme (interrupt) olarak simüle eder. Örneğin, `e.KeyCode == Keys.Enter` algılandığında sistem akışı kesilir ve Terminal komutu değerlendirilip donanıma GUI bazlı bir yanıt verilir.

## Dosya Sistemi (File System)
Büyük ve karmaşık bir depolama mimarisi (FAT32/NTFS) tasarlamak yerine, sistemin çekirdeğinde `Dictionary<string, string> virtualDesktopFiles` adı verilen, **Bellek İçi Sanal Dosya Sistemi (In-Memory VFS)** tercih edilmiştir. Not Defteri ile oluşturulan dosyalar diskte fiziki yer kaplamaz, doğrudan sistemin VFS hafızasında düğümlenir. Sistem kapatıldığında yapı sıfırlanır.

## Sistem Çağrıları (System Calls)
Kullanıcı alanındaki bir form tıklama işleminin çekirdeğe ait pencere taşıma (Drag & Drop) fonksiyonlarını tetikleyebilmesi için platform çağrıları (`DllImport`) kullanılmıştır:
Pencere yöneticisi `ReleaseCapture()` ve `SendMessage()` sistem çağrılarıyla doğrudan Kernel32 / User32 seviyesine inerek pencerelerin ekran üzerindeki Z-Matrix katmanını günceller.

# 6. Uygulama ve Kod Yapısı
## Klasör Yapısı
```text
Elif İşletim Sistemi/
├── build.bat         (Compiler Entry Point / Derleme Otomasyonu)
├── os_ui.cs          (Monolithic Main Source Code - Çekirdek + WM + Uygulamalar)
├── os_kernel_elif.exe(Derlenmiş İşletim Sistemi Modülü)
└── Web UI dosyaları  (Eski HTML tabanlı çevresel bileşenler)
```

## Kritik Kod Parçaları
**Context Switching (Pencere Z-Ekseni Geçişi Algoritması):** Arayüz içindeki birden fazla açık pencere arasındaki geçiş sürecini yöneten blok;
```csharp
MouseEventHandler dragHandler = (s, e) => { 
    if (e.Button == MouseButtons.Left) { 
        ReleaseCapture(); 
        SendMessage(win.Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0); 
    } 
    win.BringToFront(); // Eski "PCB" duraklatılıp, odaklanılan Task en öne alınıyor
};
```

# 7. Test ve Analiz
* **Test Senaryoları:** Çoklu Görev Testi başarıyla geçilmiştir (Aynı anda Hem Yılan Oyunu arka planda timer tabanlı çalışırken, ön planda Terminal üzerinden hesaplama işlemlerinin aksamadan yürütülmesi test edilmiştir).
* **Performans Gözlemleri:** Ekran çözünürlüğü ve nesnelerin kalitesine bağlı olarak sistemde ekranda titreşimler (flickering) meydana gelmiş; ancak tüm uygulamaların bulunduğu grafik alanlarına çift-tamponlama (`DoubleBuffered = true`) özelliği yansıtılarak bu darboğaz ortadan kaldırılmıştır.
* **Ekran Görüntüleri:** *(Rapor dökümünde buraya ElifOS masaüstü ve Terminal çıktısı ekran görüntüleri konulacaktır.)*

# 8. Karşılaşılan Zorluklar ve Çözümler
* **Z-Index (Pencere Katmanları) Çatışmaları:** Açılan uygulamaların birbiriyle bütünleşip (child window) hatalı şekilde iç içe geçmesi sorunu yaşandı. Çözüm olarak; masaüstü form objesi mutlak bir parent alınarak her uygulamanın kesin sınırlarla bu alanda başlatılması denetlendi.
* **Kernel Panic (Kilitlenme) Simülasyonu:** Medya tarayıcısının veya kilit ekranı arka plan fotoğrafının bağlanılamayan bir internet sitesinden veri çekerken tüm C# çekirdeğinde Frame Drop yaratması ve kilitlenmesi. Bu zorluk, `async` donanım iş parçacıkları (Task.Run) ve genişletilmiş "try-catch" blokları yazılarak izole edildi ve kilitlenme bertaraf edildi.

# 9. Sonuç
Proje boyunca; karmaşık pencerelendirme motoru (WM), bağımsız olarak yönetilen event-listener mekanizmaları, in-memory dosya yapıları ve asenkron görev çalıştırma süreçleri tasarlanmıştır. Tüm bunlar standart işletim sistemi teorilerinin yüksek dildeki iz düşümlerini anlamamda büyük bir akademik birikim oluşturmuştur. Eğer gelecek sürümlerde ekleme şansım olsaydı; In-Memory olarak duran RAM tabanlı Virtual File System yapısını doğrudan bir SQLite mantığıyla kalıcı depolama bellek mimarisine (Hard disk kalıcılığı) taşımak ilk hedefim olurdu.

# 10. Kaynakça
* [1] Windows API System Calls - https://docs.microsoft.com/en-us/windows/win32/api/
* [2] Tanenbaum, A.S. — Modern Operating Systems (4. Baskı - Kavramların Uyarlanması)
* [3] C# Async/Await Programming Guidelines - Microsoft Docs
* [4] QEMU / OSDev Yaklaşımları — https://wiki.osdev.org/ (Memory ve Boot süreçleri referansı)
* [5] .NET Garbage Collection Fundamentals — Microsoft Core Developer Makaleleri
