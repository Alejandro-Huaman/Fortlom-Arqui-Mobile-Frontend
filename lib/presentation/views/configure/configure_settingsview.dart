import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortloom/presentation/views/login_register/login.dart';

import '../../../core/framework/globals.dart';



class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<bool> isActive =[false,false,false,false,false,false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 1,
        title: Container(
          padding: EdgeInsets.only(right: 50),
          alignment: Alignment.center,
          child: Image.asset('assets/imgs/logo.png',
              height: ScreenWH(context).height * 0.1,
              width: ScreenWH(context).width * 0.25),
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text("Settings", style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.person,
                  color: Colors.black,
                ),
                SizedBox(width: 8,),
                Text("Account",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),

            buildAcountOptionRow(context, "Manage tags"),
            buildAcountOptionRow(context, "Social"),
            SizedBox(height: 40,),
            Row(
              children: [
                Icon(Icons.volume_up_outlined,
                  color: Colors.black,
                ),
                SizedBox(width: 8,),
                Text("Notifications",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(height: 15,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [

                  Text("Likes",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Off",0),
            buildNotificationOptionRow("From people i follow",1),
            buildNotificationOptionRow("From everyone",2),
            SizedBox(
              height: 10,
            ),
            Row(
                children: [
                  Text("Comments",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.library_books,
                    color: Colors.amber,
                  ),
                ],
              ),

            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Off",3),
            buildNotificationOptionRow("From people i follow",4),
            buildNotificationOptionRow("From everyone",5),
            SizedBox(
              height: 50,
            ),
            Center(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                  onPressed: (){actionSheetMethod(context);},
                  child: Text("Sign Out",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                    color: Colors.black
                  ),
                  )
              ),
            )
          ],
        ),

      ),
    );
  }

  Row buildNotificationOptionRow(String title,int index) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(title,
            style: TextStyle(
              fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]
            ),
            ),
            Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  value: isActive[index],
                  activeColor: Colors.black,
                  onChanged: (value){
                    setState(() {
                      isActive[index]=value;
                    });
                  },
                )
            )
          ],);
  }



  GestureDetector buildAcountOptionRow(BuildContext context, String title) {
    return GestureDetector(
            onTap: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      title: Text(title),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Text("Option 1"),
                        Text("Option 2"),
                        Text("Option 3"),
                      ],),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        },
                            child: Text("Close",
                            style: TextStyle(
                              color: Colors.black
                            ),
                            )
                        ),
                      ],
                    );
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text(title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ],),
            ),
          );
  }
  actionSheetMethod(BuildContext context){
    showCupertinoModalPopup(
        context: context,
        builder: (context){
          return CupertinoActionSheet(
            title: Text("You are about to leave",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black
            ),
            ),
            message: Text("If you sign out you will have to enter your credentials again",
              style: TextStyle(
                  fontSize: 16,
              ),
            ) ,
            cancelButton: CupertinoActionSheetAction(

              onPressed: (){Navigator.of(context).pop();},
              child: Text("Cancel",
              style: TextStyle(
                color: Colors.black
              ),
              ),
            ) ,
            actions: <Widget>[
              CupertinoActionSheetAction(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Text("Leave",
                  style: TextStyle(
                    color: Colors.black

                  ),
                  ),
              ),
            ],
          );
        }
    );
  }
}