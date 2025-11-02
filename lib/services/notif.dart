// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Inisialisasi database timezone
    tz_data.initializeTimeZones();

    // 2. Settingan Inisialisasi Android
    // Ganti 'notification_icon' dengan nama file .png kamu
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@drawable/notification_icon');

    // 3. Settingan Inisialisasi iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // 4. Gabungkan settings
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 5. Inisialisasi plugin
    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  // Callback saat notifikasi diterima (hanya untuk iOS versi lama)
  static void _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // (Bisa dikosongkan)
  }

  // Callback saat notifikasi DI-KLIK
  static void _onDidReceiveNotificationResponse(NotificationResponse response) async {
    // Di sini kamu bisa atur navigasi
    // 'payload' adalah data yg kamu kirim, misal: 'merch_page'
    if (response.payload != null) {
      print('Notification Payload: ${response.payload}');
      // Contoh: if (response.payload == 'merch_page') { ... navigasi ... }
    }
  }

  // --- FUNGSI UTAMA ---

  /// 1. Meminta Izin (WAJIB untuk iOS & Android 13+)
  Future<void> requestPermissions() async {
    // Untuk Android 13+
    if (await _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>() !=
        null) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    // Untuk iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// 2. Menampilkan Notifikasi Sederhana (Instan)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload, // Data opsional saat di-klik
  }) async {
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_1', // ID channel
        'Channel Name', // Nama channel
        channelDescription: 'Deskripsi channel',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/notification_icon',
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// 3. Menjadwalkan Notifikasi (Ini yang kamu mau!)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required Duration delay, // Waktu tunda dari sekarang
    String? payload,
  }) async {
    
    // Tentukan waktu (Sekarang + durasi tunda)
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.now(tz.local).add(delay);

    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id_2', // ID channel (harus beda)
        'Scheduled Channel', // Nama channel
        channelDescription: 'Channel untuk notifikasi terjadwal',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@drawable/notification_icon',
      ),
      iOS: DarwinNotificationDetails(
        sound: 'default.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime, // Waktu penjadwalan
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}