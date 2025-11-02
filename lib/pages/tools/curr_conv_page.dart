// lib/pages/tools/currency_converter_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/config/theme.dart';

class CurrencyConverterPage extends StatefulWidget {
  @override
  _CurrencyConverterPageState createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final _amountController = TextEditingController();

  String _fromCurrency = 'IDR';
  String _toCurrency = 'USD';
  double _result = 0.0;

  final Map<String, double> _exchangeRates = {
    'IDR': 1.0,
    'USD': 0.000064,
    'EUR': 0.000059,
    'JPY': 0.0095,
  };

  final Map<String, String> _currencyNames = {
    'IDR': 'Rupiah Indonesia',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'JPY': 'Japanese Yen',
  };

  final Map<String, String> _currencySymbols = {
    'IDR': 'Rp',
    'USD': '\$',
    'EUR': '€',
    'JPY': '¥',
  };

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _convert() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showSnackBar('Masukkan jumlah yang valid!', isError: true);
      return;
    }

    setState(() {
      final amountInIDR = amount / _exchangeRates[_fromCurrency]!;
      _result = amountInIDR * _exchangeRates[_toCurrency]!;
    });
  }

  void _swap() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      if (_amountController.text.isNotEmpty) {
        _convert();
      }
    });
  }

  void _clear() {
    setState(() {
      _amountController.clear();
      _result = 0.0;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor:
            isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    final symbol = _currencySymbols[currency]!;
    if (currency == 'IDR') {
      return '$symbol ${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      )}';
    } else if (currency == 'JPY') {
      return '$symbol ${amount.toStringAsFixed(0)}';
    } else {
      return '$symbol ${amount.toStringAsFixed(2)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.currency_exchange,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Currency Converter',
                    style: AppTheme.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Exchange rates made simple.',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Jumlah',
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.attach_money),
                hintText: 'Masukkan jumlah',
                suffixIcon: _amountController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),

            const SizedBox(height: 24),

            _buildCurrencySelector(
              label: 'Dari',
              value: _fromCurrency,
              onChanged: (value) {
                setState(() {
                  _fromCurrency = value!;
                  if (_amountController.text.isNotEmpty) _convert();
                });
              },
            ),

            const SizedBox(height: 16),

            Center(
              child: InkWell(
                onTap: _swap,
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildCurrencySelector(
              label: 'Ke',
              value: _toCurrency,
              onChanged: (value) {
                setState(() {
                  _toCurrency = value!;
                  if (_amountController.text.isNotEmpty) _convert();
                });
              },
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _convert,
                icon: const Icon(Icons.calculate),
                label: const Text('Convert'),
              ),
            ),

            const SizedBox(height: 24),

            if (_result > 0) _buildResultCard(),

            const SizedBox(height: 24),

            _buildExchangeRateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: AppTheme.cardDecoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down,
                  color: AppTheme.primaryColor),
              items: _exchangeRates.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _currencySymbols[currency]!,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currency,
                                style: AppTheme.bodyMedium
                                    .copyWith(fontWeight: FontWeight.w600)),
                            Text(_currencyNames[currency]!,
                                style: AppTheme.caption),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Text('Hasil Konversi',
              style: AppTheme.bodySmall.copyWith(
                  color: Colors.white70, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(
            _formatCurrency(_result, _toCurrency),
            style: AppTheme.headingLarge.copyWith(
              color: AppTheme.secondaryColor,
              fontSize: 36,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currencyNames[_toCurrency]!,
            style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeRateInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline,
                  size: 20, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text('Exchange Rates (Base: IDR)',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          ..._exchangeRates.entries.where((e) => e.key != 'IDR').map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1 IDR = ',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textColor.withOpacity(0.7),
                      )),
                  Text(
                    '${_currencySymbols[entry.key]} ${entry.value}',
                    style: AppTheme.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 8),
          Text('* Rates updated: November 2024',
              style: AppTheme.caption.copyWith(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}
