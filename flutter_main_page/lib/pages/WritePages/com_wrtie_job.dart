import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Write {
  String title;
  String content;
  String time;

  Write(this.title, this.content, this.time);
}

class WriteJobPage extends StatefulWidget {
  final String user;
  const WriteJobPage(this.user, {Key? key}) : super(key: key);

  @override
  State<WriteJobPage> createState() => _WriteJobPageState();
}

class _WriteJobPageState extends State<WriteJobPage> {
  var _now = DateTime.now();
  final _title = TextEditingController();
  final _content = TextEditingController();

  void _addNotice(Write notice, String user) {
    FirebaseFirestore.instance.collection('job').add({
      'title': "[취업정보] ${notice.title}",
      'content': notice.content,
      'author': user,
      'time': notice.time,
    });
    _title.text = '';
    _content.text = '';
  }

  @override
  void initState() {
    Timer.periodic((const Duration(seconds: 1)), (v) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "information of Job",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pacifico',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (_title.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "제목을 입력하세요.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16,
                  );
                } else if (_content.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "내용을 입력하세요.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16,
                  );
                } else {
                  _addNotice(Write(_title.text, _content.text, _now.toString()),
                      widget.user);
                  Fluttertoast.showToast(
                    msg: "새 공지가 등록되었습니다.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16,
                  );
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: [
            Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    TextField(
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                      minLines: 1,
                      maxLines: 10,
                      controller: _title,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "제목",
                          hintStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      minLines: 15,
                      maxLines: 100,
                      controller: _content,
                      onChanged: (text) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                          hintText: "내용을 입력하세요",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          filled: true,
                          fillColor: Colors.white),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
