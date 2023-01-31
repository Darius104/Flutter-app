import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_front_end/screens/home_page.dart';
import 'package:flutter_front_end/screens/profile_page.dart';
import 'package:flutter_front_end/utils/constants.dart';
import 'package:flutter_front_end/screens/create_post_page.dart';
import 'package:flutter_front_end/widgets/post_list.dart';
import 'package:flutter_front_end/widgets/post_widget.dart';
import 'package:http/http.dart';
import 'package:flutter_front_end/screens/login_page.dart';
import 'package:provider/provider.dart';

import '../models/post_list_data.dart';
import '../models/user_data.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    String nameUser = Provider.of<UserData>(context).name;
    String emailUser = Provider.of<UserData>(context).email;

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageIndex == 0 ? "Home Page" : "Profile"),
        actions: [
          _pageIndex == 1
              ? PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Row(
                        children: const [
                          Icon(Icons.logout),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Log out")
                        ],
                      ),
                    )
                  ],
                  offset: const Offset(0, 50),
                  color: Color.fromARGB(255, 72, 72, 72),
                  elevation: 2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                  ),
                  onSelected: (value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                )
              : Container()
        ],
      ),
      body: IndexedStack(
        index: _pageIndex,
        children: [
          const HomePage(),
          ProfilePage(emailUser: emailUser),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kbottomBarBackgrounColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Profile',
          ),
        ],
        currentIndex: _pageIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (value) {
          Provider.of<PostListData>(context, listen: false)
              .getPostList(context);

          setState(() {
            _pageIndex = value;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePostPage(),
            ),
          );
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
