import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';

import 'Messages.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String,dynamic>> messages = [];
  ArtistResource objartist = ArtistResource(0, "username", "realname", lastname, email, password, artistfollowers, instagramLink, facebookLink, twitterLink)
  PublicationResource objpublication = PublicationResource(0, "description", false,, artistid, artist)

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Fortlom Bot"),
        actions: [
          Image.asset('assets/imgs/logo.png'),
          Padding(padding: EdgeInsets.only(right: 30))
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages:messages)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8
              ),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(child:
                  TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                   )
                  ),
                  IconButton(onPressed: (){
                     sendMessage(_controller.text);
                     _controller.clear();
                  }, icon: Icon(Icons.send, color: Colors.white,))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  sendMessage(String text) async{
    if(text.isEmpty){
      print("Message is Empty");
    }else{
      setState(() {
        addMessages(Message(
          text: DialogText(text: [text])
        ),true);
      });
      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text))
      );
      if(response.message == null) return;
      setState(() {
        addMessages(response.message!);
        //Para crear publicaciones
        if(response.message == "Este será la descripción de tu publicación, seguro de esta respuesta?"){
          print(text);
          print(response.message);
          widget.objectpublication
        }

        //Para crear eventos
        if(response.message == "Este será la descripción de tu evento, seguro de esta respuesta?"){

        }
      });
    }
  }

  addMessages(Message message, [bool isUserMessage = false]){ //default value in the bool variable = false
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage
    });
  }
}
