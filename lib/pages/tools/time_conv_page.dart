import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/config/theme.dart';

class TimeConverterPage extends StatefulWidget {
  @override
  _TimeConverterPageState createState() => _TimeConverterPageState();
}

class _TimeConverterPageState extends State<TimeConverterPage> {
  DateTime _selectedDateTime = DateTime.now();
  String _baseTimezone = 'WIB';

  // Time zone offsets from UTC
  final Map<String, int> _timezoneOffsets = {
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
    'London': 0,
  };

  final Map<String, String> _timezoneNames = {
    'WIB': 'Waktu Indonesia Barat',
    'WITA': 'Waktu Indonesia Tengah',
    'WIT': 'Waktu Indonesia Timur',
    'London': 'Greenwich Mean Time',
  };

  final Map<String, String> _timezoneLocations = {
    'WIB': 'Jakarta, Medan, Pontianak',
    'WITA': 'Makassar, Denpasar, Balikpapan',
    'WIT': 'Jayapura, Ambon, Manokwari',
    'London': 'London, United Kingdom',
  };

  DateTime _convertTime(String targetTimezone) {
    final baseOffset = _timezoneOffsets[_baseTimezone]!;
    final targetOffset = _timezoneOffsets[targetTimezone]!;
    final offsetDiff = targetOffset - baseOffset;
    return _selectedDateTime.add(Duration(hours: offsetDiff));
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundColor,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundColor,
              onSurface: AppTheme.textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _setToNow() {
    setState(() {
      _selectedDateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Time Converter'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.secondaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showInfoDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.access_time,
                      size: 48,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Scout Mission Timer',
                    style: AppTheme.headingMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Survey Corps Time Coordination',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            _buildCurrentTimeCard(),
            SizedBox(height: 24),

            Text(
              'Base Timezone',
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            _buildTimezoneSelector(),

            SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectDateTime,
                    icon: Icon(Icons.calendar_today, size: 20),
                    label: Text('Pilih Waktu'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _setToNow,
                    icon: Icon(Icons.refresh, size: 20),
                    label: Text('Sekarang'),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            Text(
              'Converted Times',
              style: AppTheme.headingSmall,
            ),
            SizedBox(height: 16),

            ..._timezoneOffsets.keys.map((timezone) {
              return _buildTimeCard(timezone);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTimeCard() {
    final formatter = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');
    final timeFormatter = DateFormat('HH:mm:ss');

    return Container(
      padding: EdgeInsets.all(24),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Text(
            'Selected Time',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textColor.withOpacity(0.7),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 12),
          Text(
            timeFormatter.format(_selectedDateTime),
            style: AppTheme.headingLarge.copyWith(
              color: AppTheme.accentColor,
              fontSize: 40,
            ),
          ),
          SizedBox(height: 8),
          Text(
            formatter.format(_selectedDateTime),
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$_baseTimezone (${_timezoneNames[_baseTimezone]})',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimezoneSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _baseTimezone,
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryColor),
          items: _timezoneOffsets.keys.map((String timezone) {
            return DropdownMenuItem<String>(
              value: timezone,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$timezone (UTC${_timezoneOffsets[timezone]! >= 0 ? '+' : ''}${_timezoneOffsets[timezone]})',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _timezoneNames[timezone]!,
                    style: AppTheme.caption,
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _baseTimezone = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTimeCard(String timezone) {
    final convertedTime = _convertTime(timezone);
    final timeFormatter = DateFormat('HH:mm:ss');
    final dateFormatter = DateFormat('dd MMM yyyy');
    final isBase = timezone == _baseTimezone;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBase
            ? AppTheme.secondaryColor.withOpacity(0.2)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBase
              ? AppTheme.accentColor
              : AppTheme.primaryColor.withOpacity(0.2),
          width: isBase ? 2 : 1,
        ),
        boxShadow: [
          if (isBase)
            BoxShadow(
              color: AppTheme.accentColor.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.public,
                      size: 20,
                      color: isBase
                          ? AppTheme.accentColor
                          : AppTheme.primaryColor,
                    ),
                    SizedBox(width: 8),
                    Text(
                      timezone,
                      style: AppTheme.headingSmall.copyWith(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    if (isBase)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'BASE',
                            style: AppTheme.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(_timezoneNames[timezone]!, style: AppTheme.caption),
                Text(
                  _timezoneLocations[timezone]!,
                  style: AppTheme.caption.copyWith(
                    fontSize: 10,
                    color: AppTheme.textColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeFormatter.format(convertedTime),
                  style: AppTheme.headingSmall.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  dateFormatter.format(convertedTime),
                  style: AppTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.access_time, color: AppTheme.accentColor),
            SizedBox(width: 8),
            Text('About Time Converter'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Konverter waktu untuk koordinasi misi Survey Corps di berbagai zona waktu.',
              style: AppTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Text(
              'Supported Timezones:',
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            ..._timezoneNames.entries.map((e) {
              final offset = _timezoneOffsets[e.key]!;
              return Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${e.key} - ${e.value} (UTC${offset >= 0 ? '+' : ''}$offset)',
                  style: AppTheme.bodySmall,
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
