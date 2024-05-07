/*import 'package:postgres/postgres.dart';

void main() async {
  final connection = await Connection.open(
    Endpoint(
      host: '91.225.104.133',
      database: 'homeservice',
      username: 'homeservice',
      password: 'SrVEJGj2DNQo',
    ),
    // The postgres server hosted locally doesn't have SSL by default. If you're
    // accessing a postgres server over the Internet, the server should support
    // SSL and you should swap out the mode with `SslMode.verifyFull`.
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  print('has connection!');

  try {
    // Bağlantı nesnesinin null olmadığını kontrol edin

    // Bağlantıyı açın
    print('PostgreSQL veritabanına bağlandı!');

    // Burada veritabanı işlemlerini gerçekleştirin
    // Örneğin, bir sorgu çalıştırın
    final sonuclar = await connection.execute('SELECT * FROM servicesmodel');
    print('Sorgu sonuçları: $sonuclar');
  } catch (e) {
    print('Veritabanına bağlanırken hata oluştu: $e');
  } finally {
    // İşiniz bittiğinde bağlantıyı kapatmayı unutmayın

    await connection.close();
    print('Bağlantı kapatıldı.');
  }
}
*/