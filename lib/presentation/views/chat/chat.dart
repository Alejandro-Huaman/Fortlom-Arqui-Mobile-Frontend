import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fortloom/core/service/ArtistService.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/EventService.dart';
import 'package:fortloom/domain/entities/ArtistResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';

import '../../../core/service/PublicationService.dart';
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
  final PublicationService publicationService = PublicationService();
  final ArtistService artistService = ArtistService();
  final AuthService authService = AuthService();
  final EventService eventService = EventService();
  var auxlinks = [];
  Message? obtainresponse = Message();
  var mayus;
  int userId=0;
  int contevent = 0;
  String username = "Usuario";
  bool ispremium = false;
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();

    String tep;
    this.authService.getToken().then((result) {
      setState(() {
        tep = result.toString();
        username = this.authService.GetUsername(tep);

        this.authService.getperson(username).then((result) {
          setState(() {
            userId = result.id;
          });
        });
      });
    });
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
      obtainresponse = response.message;
      setState(() {
        print(text);
        print(obtainresponse!.text!.text!.first);
        addMessages(response.message!);

        //Para crear publicaciones
        if(obtainresponse!.text!.text!.first == "Se creo la publicación correctamente :D"){
          print(text);
          print(obtainresponse!.text!.text!.first);
          mayus = auxlinks.length > 0;
          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
              publicationService.addPost(text, userId, mayus.toString());
            }else{
              Fluttertoast.showToast(
                  msg: "No es un artista por tal motivo no puede crear publicaciones!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 7,
                  fontSize: 16.0
              );
            }
          });
        }

        //Para crear eventos
        if(obtainresponse!.text!.text!.first == "Se creo el evento correctamente :D"){
          print(text);
          print(obtainresponse!.text!.text!.first);

          artistService.existartistId(userId).then((resartist){
            if(resartist == true){
                artistService.checkremiumartistid(userId).then((response){
                  ispremium = response;

                  print(ispremium);

                  if(ispremium == true){
                    contevent+=1;
                    eventService.addEvents("Event "+contevent.toString(),text,"https://teleticket.com.pe/","",userId);
                  }else{
                    Fluttertoast.showToast(
                        msg: "No es artista premium, por favor mejorar su cuenta a premium para crear un evento!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 7,
                        fontSize: 16.0
                    );
                  }
                });
            }else{
              Fluttertoast.showToast(
                  msg: "No es un artista por tal motivo no puede crear eventos!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 7,
                  fontSize: 16.0
              );
            }
          });
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
