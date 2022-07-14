import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_main_page/pages/Update_Page/Content_update.dart';
import 'package:flutter_main_page/pages/View_pages/notice_view.dart';

class Com {
  String title;
  String content;
  String author;
  String time;

  Com(this.title, this.author, this.content, this.time);
}

class MyContentUpdatePage extends StatefulWidget {
  final String user;
  MyContentUpdatePage(this.user, {Key? key}) : super(key: key);

  @override
  State<MyContentUpdatePage> createState() => _MyContentUpdatePageState();
}

class _MyContentUpdatePageState extends State<MyContentUpdatePage> {
  void _updateItemDialog(
      DocumentSnapshot doc, String docID, String title, String content) {
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
              children: const [Text('수정하시겠습니까??')],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                ContentUpdatePage(docID, title, content))));
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

  // void _deleteItem(DocumentSnapshot doc) {
  //   FirebaseFirestore.instance.collection('com').doc(doc.id).delete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.refresh))],
        backgroundColor: Colors.blue,
        title: const Text(
          "My Content",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Pacifico',
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('com')
              .where('author', isEqualTo: widget.user)
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: Container(child: const CircularProgressIndicator()));
            }
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return _buildNonEvent();
            } else {
              return ListView(
                shrinkWrap: true,
                children:
                    documents.map((doc) => _buildEventWidget(doc)).toList(),
              );
            }
          }),
    );
  }

  Widget _buildEventWidget(DocumentSnapshot doc) {
    final com = Com(doc['title'], doc['author'], doc['content'], doc['time']);
    return ListTile(
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoticeViewPage(
                    com.title, com.content, com.author, com.time)));
      },
      title: Text(
        com.title,
        style: const TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "익명",
        style: const TextStyle(fontSize: 10),
      ),
      trailing: IconButton(
        onPressed: () {
          _updateItemDialog(doc, doc.id, com.title, com.content);
        },
        icon: Icon(Icons.update),
      ),
    );
  }

  Widget _buildNonEvent() {
    return Center(
      child: Container(
        child: const Center(
          child: Text(
            '등록한 글이 없습니다.',
            style: TextStyle(
                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
