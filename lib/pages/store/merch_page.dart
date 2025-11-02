// lib/pages/store/merch_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '/models/merch_model.dart';
import '/config/theme.dart'; // Sesuaikan path theme kamu

// ===============================================
// HALAMAN UTAMA (STATEFUL)
// ===============================================
class MerchPage extends StatefulWidget {
  @override
  _MerchPageState createState() => _MerchPageState();
}

class _MerchPageState extends State<MerchPage> {
  List<MerchModel> _merchList = [];
  Map<String, dynamic> _exchangeRates = {};
  bool _isLoading = true;
  String? _errorMessage;

  //
  // ⛔️ PENTING: GANTI DENGAN API KEY KAMU ⛔️
  //
  final String _apiKey = "ddc9ecdd08f7748bae04d190";
  //
  //

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _merchList = MerchModel.getAllMerch();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("https://v6.exchangerate-api.com/v6/$_apiKey/latest/JPY"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['result'] == 'success') {
          _exchangeRates = data['conversion_rates'];
        } else {
          throw Exception(data['error-type'] ?? 'Gagal mengambil data kurs');
        }
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      _errorMessage = "Gagal memuat data kurs: ${e.toString()}";
    }
    
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scout Regiment Store", style: AppTheme.headingMedium),
        backgroundColor: AppTheme.backgroundColor,
        foregroundColor: AppTheme.primaryColor,
        elevation: 1,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.accentColor),
          ),
        ),
      );
    }

    // Tampilkan daftar merchandise
    // Kita kirim _exchangeRates (data kurs) ke setiap card
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _merchList.length,
      itemBuilder: (context, index) {
        final merch = _merchList[index];
        return MerchCard(
          merch: merch,
          rates: _exchangeRates, 
        );
      },
    );
  }
}

// ===============================================
// WIDGET CARD (DIUBAH JADI STATEFUL)
// ===============================================
class MerchCard extends StatefulWidget {
  final MerchModel merch;
  final Map<String, dynamic> rates; // Data kurs dari API

  MerchCard({required this.merch, required this.rates});

  @override
  _MerchCardState createState() => _MerchCardState();
}

class _MerchCardState extends State<MerchCard> {
  // --- State untuk menyimpan pilihan dropdown ---
  String _selectedCurrency = 'IDR'; // Default mata uang
  String _selectedTimezone = 'Asia/Jakarta'; // Default zona waktu

  // --- Daftar Opsi Dropdown ---
  final Map<String, String> _currencyOptions = {
    'IDR': 'Rupiah (IDR) 🇮🇩',
    'USD': 'Dolar (USD) 🇺🇸',
    'EUR': 'Euro (EUR) 🇪🇺',
    'SGD': 'Dolar (SGD) 🇸🇬',
  };

  final Map<String, String> _timezoneOptions = {
    'Asia/Jakarta': 'WIB (Jakarta) 🇮🇩',
    'Asia/Makassar': 'WITA (Makassar) 🇮🇩',
    'Asia/Jayapura': 'WIT (Jayapura) 🇮🇩',
    'Europe/London': 'London (GMT) 🇬🇧',
    'America/New_York': 'New York (EST) 🇺🇸',
  };

  // --- FUNGSI KONVERSI WAKTU (sekarang dinamis) ---
  String _getConvertedTime() {
    try {
      final location = tz.getLocation(_selectedTimezone);
      final tzTime = tz.TZDateTime.from(widget.merch.releaseDateUtc, location);
      return DateFormat('d MMM yyyy, HH:mm').format(tzTime);
    } catch (e) {
      print("Error konversi waktu: $e");
      return "Invalid Timezone";
    }
  }

  // --- FUNGSI KONVERSI MATA UANG (sekarang dinamis) ---
  String _getConvertedCurrency() {
    final rates = widget.rates; // Ambil data kurs dari widget
    
    if (rates.isEmpty || !rates.containsKey(_selectedCurrency)) {
      return "Loading...";
    }
    
    final rate = rates[_selectedCurrency];
    final convertedAmount = widget.merch.priceJpy * rate;
    
    if (_selectedCurrency == 'IDR') {
      return NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0,
      ).format(convertedAmount);
    }
    
    if (_selectedCurrency == 'USD') {
      return NumberFormat.currency(
        locale: 'en_US', symbol: '\$ ', decimalDigits: 2,
      ).format(convertedAmount);
    }
    
    // Default (EUR, SGD, dll)
    return NumberFormat.currency(
      symbol: '${_selectedCurrency} ', decimalDigits: 2,
    ).format(convertedAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      color: AppTheme.secondaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- GAMBAR BARANG ---
          Image.network(
            widget.merch.imagePath,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) { /* ... (kode loading tetap sama) ... */
              return progress == null
                  ? child
                  : Container(
                      height: 200,
                      color: AppTheme.backgroundColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                          value: progress.expectedTotalBytes != null
                              ? progress.cumulativeBytesLoaded /
                                  progress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
            },
            errorBuilder: (context, error, stackTrace) { /* ... (kode error tetap sama) ... */
              return Container(
                height: 200,
                color: AppTheme.secondaryColor,
                child: Center(
                  child: Icon(
                    Icons.broken_image, 
                    color: AppTheme.textColor,
                    size: 40,
                  ),
                ),
              );
            },
          ),
          
          // --- BAGIAN DETAIL (TEKS) ---
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- NAMA BARANG & DESKRIPSI ---
                Text(
                  widget.merch.name, 
                  style: AppTheme.headingSmall.copyWith(color: AppTheme.primaryColor)
                ),
                SizedBox(height: 8),
                Text(widget.merch.description, style: AppTheme.bodyMedium),
                
                Divider(height: 32, color: AppTheme.primaryColor),

                // --- BAGIAN KONVERSI MATA UANG (DINAMIS) ---
                Text(
                  "Price (Estimate)", 
                  style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 8),
                // Harga Asli (tetap)
                _buildStaticRow(
                  "JPY 🇯🇵", 
                  NumberFormat.currency(
                    locale: 'ja_JP', symbol: '¥', decimalDigits: 0
                  ).format(widget.merch.priceJpy)
                ),
                SizedBox(height: 8),
                // Dropdown Pilihan Mata Uang
                _buildCurrencyDropdown(),
                SizedBox(height: 8),
                // Hasil Konversi
                _buildResultRow(_getConvertedCurrency()),

                SizedBox(height: 20),

                // --- BAGIAN KONVERSI WAKTU (DINAMIS) ---
                Text(
                  "Release Date (Pre-Order)", 
                  style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 8),
                // Waktu Asli Rilis (tetap)
                _buildStaticRow(
                  "JST 🇯🇵", 
                  tz.TZDateTime.from(widget.merch.releaseDateUtc, tz.getLocation('Asia/Tokyo'))
                      .toString().substring(0, 16) // Format simpel
                ),
                SizedBox(height: 8),
                // Dropdown Pilihan Zona Waktu
                _buildTimezoneDropdown(),
                SizedBox(height: 8),
                // Hasil Konversi
                _buildResultRow(_getConvertedTime()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  // Baris statis (untuk JPY dan JST)
  Widget _buildStaticRow(String label, String value) {
    return Row(
      children: [
        Container(
          width: 80, // Samakan lebar
          child: Text(label, style: AppTheme.bodyMedium),
        ),
        Text(value, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  // Baris hasil konversi (yang besar)
  Widget _buildResultRow(String result) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result,
        style: AppTheme.bodyMedium.copyWith(
          fontWeight: FontWeight.bold, 
          color: AppTheme.primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Dropdown untuk Mata Uang
  Widget _buildCurrencyDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCurrency,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          style: AppTheme.bodyMedium,
          isDense: true,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCurrency = newValue;
              });
            }
          },
          items: _currencyOptions.entries
              .map<DropdownMenuItem<String>>((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Dropdown untuk Zona Waktu
  Widget _buildTimezoneDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.primaryColor, width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedTimezone,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          style: AppTheme.bodyMedium,
          isDense: true,
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedTimezone = newValue;
              });
            }
          },
          items: _timezoneOptions.entries
              .map<DropdownMenuItem<String>>((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
      ),
    );
  }
}