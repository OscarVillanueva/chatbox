import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurate El tortas"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: () {
              response("hola");
            },
            child: Text("response"),
          ),
        ),
      ),
    );
  }

  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/credentials.json").build();

    Dialogflow dialogflow =
        await Dialogflow(authGoogle: authGoogle, language: Language.english);

    AIResponse aiResponse = await dialogflow.detectIntent('hola');

    print(aiResponse.getMessage());
  }
}
