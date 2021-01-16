import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:loading_overlay/loading_overlay.dart';

class ChatBot extends StatefulWidget {
  ChatBot({Key key}) : super(key: key);

  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final txtMessageController = TextEditingController();
  List<Map> messages = List();
  bool reset = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Restaurate Chatbox"),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          MaterialButton(
              child: Icon(Icons.reset_tv, color: Colors.white),
              onPressed: () => resetConversation())
        ],
      ),
      body: LoadingOverlay(
        isLoading: reset,
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                      // reverse: true,
                      padding: EdgeInsets.all(15.0),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => generateBubble(
                          messages[index]["data"],
                          messages[index]["message"]))),
              Divider(height: 3.0),
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                        child: TextField(
                            controller: txtMessageController,
                            decoration: InputDecoration.collapsed(
                                hintText: "Enviar mensaje"))),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (txtMessageController.text.isEmpty)
                              print("vacio");
                            else {
                              setState(() {
                                messages.add({
                                  "data": 1,
                                  "message": txtMessageController.text
                                });
                              });
                              response(txtMessageController.text);
                              txtMessageController.clear();
                            }
                          }),
                    )
                  ],
                ),
              )
            ],
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

    AIResponse aiResponse = await dialogflow.detectIntent(query);

    setState(() {
      messages.add({"data": 0, "message": aiResponse.getMessage()});
    });
  }

  Widget generateBubble(side, message) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      nipWidth: 10,
      nipHeight: 10,
      nip: side == 0 ? BubbleNip.leftBottom : BubbleNip.rightBottom,
      color: side == 0 ? Colors.grey[300] : Colors.orange,
      child: Text(
        message,
        style: TextStyle(fontSize: 15.0),
      ),
      alignment: side == 0 ? Alignment.topLeft : Alignment.topRight,
    );
  }

  void resetConversation() {
    setState(() {
      reset = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        messages.clear();
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        reset = false;
      });
    });
  }
}
