import 'package:flutter/material.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateJourneyScreenState();
}

class CreateJourneyScreenState extends State<CreateJourneyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_rounded),
              ),
              Text(
                "Новая поездка",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(),
            ],
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: Column(),
      ),
    );
  }
}
