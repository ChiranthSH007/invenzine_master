import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invenzine/pages/home_pages/main_page.dart';
import 'package:invenzine/pages/home_pages/search.dart';
import 'package:invenzine/pages/home_pages/settings.dart';
import 'main_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedindex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  List<Widget> _pages = [Home(), Search(), Setting()];
  void _ontapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'INVENZINE',
            style: GoogleFonts.oswald(
                fontSize: size.width * 0.085, fontWeight: FontWeight.bold),
          )
        ],
      )),
      body: _pages[_selectedindex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home_outlined, size: 30),
          Icon(Icons.search_outlined, size: 30),
          Icon(Icons.perm_identity, size: 30),
        ],
        color: Colors.grey[300],
        buttonBackgroundColor: Colors.yellowAccent,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedindex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
      // BottomNavigationBar(
      //   selectedItemColor: Colors.yellow,
      //   backgroundColor: Colors.grey[850],
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //       // ignore: deprecated_member_use
      //       //title: SizedBox.shrink()
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //       // ignore: deprecated_member_use
      //       //title: SizedBox.shrink()
      //     ),
      //     BottomNavigationBarItem(
      //       label: 'Profile',
      //       icon: Icon(Icons.person),
      //       // ignore: deprecated_member_use
      //       //title: SizedBox.shrink()
      //     ),
      //   ],
      //   selectedLabelStyle: TextStyle(fontSize: 13),
      //   currentIndex: _selectedindex,
      //   unselectedItemColor: Colors.white,
      //   onTap: _ontapped),
    );
  }
}
