import 'package:flutter/material.dart';
import 'package:word_quest/theme/colors.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leader Board"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    List items = ["1", "2"];
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return getCard();
        });
  }

  Widget getCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(60 / 2),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(""))),
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 15, color: Colors.deepOrange),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Score",
                    style: TextStyle(fontSize: 15, color: Colors.deepOrange),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
