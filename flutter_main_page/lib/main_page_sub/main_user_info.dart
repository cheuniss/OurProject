import 'package:flutter/material.dart';
import 'package:flutter_main_page/login_page.dart';
import 'package:flutter_main_page/main.dart';

class MainPage4 extends StatefulWidget {
  const MainPage4({Key? key}) : super(key: key);

  @override
  State<MainPage4> createState() => _MainPage4State();
}

class _MainPage4State extends State<MainPage4> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        _buildUserInfo(),
      ],
    ));
  }

  Widget _buildUserInfo() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 380,
            height: 340,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.black, width: 3),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Column(
              children: [
                Container(
                    width: 280,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: const [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Center(
                            child: Text(
                              "사용자정보",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    )),
                const Icon(
                  Icons.account_circle_rounded,
                  size: 60,
                ),
                const Text(
                  '이름 : hi',
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  '학번 : ',
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  '학년 : ',
                  style: TextStyle(fontSize: 20),
                ),
                const Text(
                  '반 : ',
                  style: TextStyle(fontSize: 20),
                ),
                ElevatedButton(
                    onPressed: (() {
                      MyApp().isAutoLogin = false;
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    }),
                    child: const Text("로그아웃"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
