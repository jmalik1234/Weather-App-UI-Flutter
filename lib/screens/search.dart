import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/components/my_button.dart';
import 'package:weather_app/components/my_text_field.dart';
import 'package:weather_app/screens/home.dart';
import 'package:weather_app/screens/text_page.dart';
import 'package:weather_app/services/auth/auth_services.dart';

class SearchPage extends StatefulWidget {
  final void Function()? onTap;
  const SearchPage({super.key, this.onTap});

  State<SearchPage> createState() => _Searches();
}

class _Searches extends State<SearchPage> {
  //make an instance of authentication
  final FirebaseAuth iofauth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  String? city = "";
  String? country = "";
  bool showWeather = false;
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  Future<void> delPage() async {
    await iofauth.currentUser!.delete();
    await db.collection('users').doc(iofauth.currentUser!.uid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your Searches'), actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout)),
        ]),
        body: Column(
          children: [
            MyTextField(
              controller: cityController,
              hintText: "city",
              obscureText: false,
            ),
            MyTextField(
              controller: countryController,
              hintText: "country",
              obscureText: false,
            ),
            MyButton(
              onTap: () async {
                addSearchToDB(cityController.text, countryController.text);
                //changing the UI be reassigning the fetched data to final response
                setState(() {
                  TextPage(
                      city: cityController.text,
                      country: countryController.text);
                });
              },
              text: 'Submit',
            ),
            _buildUserList(),
          ],
        ));
  }

  void addSearchToDB(String? city, String? country) {
    String docName = "$city$country";
    var person = iofauth.currentUser!.uid;
    print("Current user is $person");
    db.collection("users").doc(person).collection('Searches').doc(docName).set({
      'city': city,
      'country': country,
    });
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(iofauth.currentUser!.uid)
          .collection('Searches')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        //.map applies (docs) func to each entry in the db
        // and returns as a widget
        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //this func will be called for each db entry
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    //get current users searches and list them

    return ListTile(
      title: Text(data['city']),
      //when u click on an id open a chatpage page
      //which holds your convo with that id
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TextPage(
                city: data['city'],
                country: data['country'],
              ),
            ));
      },
    );
  }
}
