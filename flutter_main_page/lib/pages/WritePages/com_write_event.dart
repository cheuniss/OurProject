import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class Write {
  String title;
  String content;
  String time;

  Write(this.title, this.content, this.time);
}

class WriteEventPage extends StatefulWidget {
  final String user;
  const WriteEventPage(this.user, {Key? key}) : super(key: key);

  @override
  State<WriteEventPage> createState() => _WriteEventPageState();
}

class _WriteEventPageState extends State<WriteEventPage> {
  var _now;
  final _title = TextEditingController();
  final _content = TextEditingController();

  void _createItemDialog(Write event, String user) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text('이벤트를 등록하시겠습니까? \n등록된 이벤트는 내정보 페이지에서 관리할 수 있습니다.')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _addNotice(event, user);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("확인")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("취소")),
            ],
          );
        });
  }

  void _addNotice(Write event, String user) {
    FirebaseFirestore.instance.collection('event').add({
      'title': "[이벤트] ${event.title}",
      'content': event.content,
      'author': user,
      'time': event.time,
    });
    _title.text = '';
    _content.text = '';
  }

  @override
  void initState() {
    Timer.periodic((const Duration(seconds: 1)), (v) {
      if (mounted) {
        setState(() {
          _now = DateFormat('yyyy-MM-dd - HH:mm:ss').format(DateTime.now());
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
          "Event",
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
                  _createItemDialog(
                      Write(_title.text, _content.text, _now.toString()),
                      widget.user);
                }
              },
              icon: Icon(Icons.check))
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
                  physics: NeverScrollableScrollPhysics(),
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
