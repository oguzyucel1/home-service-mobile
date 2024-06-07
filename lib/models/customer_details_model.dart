import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> fetchUserProfile() async {
  //  Logged-In ullanıcı profili bilgilerini databaseden otomaik olarak getirme
  final SupabaseClient supabaseClient = Supabase.instance.client;
  final user = supabaseClient.auth.currentUser;
  if (user != null) {
    final response = await supabaseClient
        .from('Hulya') //  supabasede 'users' tablosunun adı
        .select()
        .eq('email', user.email!) // email eşitliği
        .single(); // tek bir kayıt getirme

    if (response != null) {
      // response boş değilse
      setName(response['name'] ?? ''); // response'dan gelen name değerini alır
      setEmail(
          response['city'] ?? ''); // response'dan gelen email değerini alır
      setAbout(
          response['adress'] ?? ''); // response'dan gelen about değerini alır
      setIcon(response['name']?.substring(0, 1) ??
          ''); // icon için username'in ilk harfi
    } else {
      // Hata yönetimi
      //print('Error fetching user profile: ${response.error.message}');
    }
  }
}

String? name; // string değerlerini null olabilir olarak tanımlama
String? email;
String? about;
String? icon;

void setName(String value) {
  name = value;
}

void setEmail(String value) {
  email = value;
}

void setAbout(String value) {
  about = value;
}

void setIcon(String value) {
  icon = value;
}

String get getName => name ?? '';

String get getEmail => email ?? '';

String get getAbout => about ?? '';

String get getIcon => icon ?? '';
