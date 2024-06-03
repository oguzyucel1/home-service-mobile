import 'package:flutter/material.dart';
import 'package:home_hub/components/profile_widget.dart';
import 'package:home_hub/components/text_field_widget.dart';
import 'package:home_hub/fragments/account_fragment.dart';
import 'package:home_hub/models/customer_details_model.dart';
import 'package:home_hub/screens/dashboard_screen.dart';
import 'package:home_hub/utils/colors.dart';
import 'package:home_hub/utils/images.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String customerName = "";
  String customerEmail = "";
  String customerAbout = "";

  Future<void> _updateUserProfile() async {
    // Kullanıcı profil sayfasını logged-in kullanıcıya göre otomatik olarak güncelleme
    final SupabaseClient supabaseClient = Supabase.instance.client;
    final user = supabaseClient.auth.currentUser;
    if (user != null) {
      final response = await supabaseClient
          .from('users') // 'users' tablosunun adı
          .update({
        'name': customerName,
        'about': customerAbout,
      }).eq('email', user.email!);

      if (response.error == null) {
        print('User profile updated successfully.');
      } else {
        // Hata yönetimi
        print('Error updating user profile: ${response.error?.message}');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: Text(
          "My Profile",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 10,
        enableDrag: false,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width, 45),
                shape: StadiumBorder(),
              ),
              child: Text("Save", style: TextStyle(fontSize: 16)),
              onPressed: () async {
                if (customerName != "") {
                  setName(customerName);
                }
                if (customerEmail != "") {
                  setEmail(customerEmail);
                }
                if (customerAbout != "") {
                  setAbout(customerAbout);
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (route) => false,
                );
                setState(() async {
                  await _updateUserProfile();
                });
              },
            ),
          );
        },
        onClosing: () {},
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: [
          ProfileWidget(imagePath: userImage, onClicked: () {}),
          SizedBox(height: 20),
          TextFieldWidget(
            label: "Full Name",
            text: getName,
            onChanged: (name) {
              customerName = name;
            },
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: "Email",
            text: getEmail,
            onChanged: (email) {
              customerEmail = email;
            },
          ),
          SizedBox(height: 15),
          TextFieldWidget(
            label: "About",
            text: getAbout,
            maxLines: 5,
            onChanged: (about) {
              customerAbout = about;
            },
          ),
        ],
      ),
    );
  }
}
