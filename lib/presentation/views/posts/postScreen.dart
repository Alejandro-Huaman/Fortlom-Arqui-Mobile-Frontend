import 'package:flutter/material.dart';
import 'package:fortloom/core/framework/colors.dart';
import 'package:fortloom/core/framework/globals.dart';
import 'package:fortloom/core/service/AuthService.dart';
import 'package:fortloom/core/service/PostService.dart';
import 'package:fortloom/core/service/PublicationService.dart';
import 'package:fortloom/domain/entities/PostResource.dart';
import 'package:fortloom/domain/entities/PublicationResource.dart';
import 'package:fortloom/presentation/views/posts/widgets/post.dart';
import 'package:fortloom/presentation/widgets/screenBase.dart';
import 'package:fortloom/presentation/widgets/sideBar/navigationBloc.dart';

class PostScreen extends StatefulWidget with NavigationStates {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _newPostDescripController =
      TextEditingController();
  final TextEditingController _newPostTitleController = TextEditingController();
  final PublicationService _postService = PublicationService();
  final AuthService authService=AuthService();
  List<PublicationResource> lstPosts = [];
  int userId=0;
  String username = "Usuario";
  @override
  void initState() {
    // TODO: implement initState
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





    _postService.getall().then((value) {
      setState(() {
        lstPosts = value;

      });
    });

  }

  @override
  Widget build(BuildContext context) {
    Future<void> _pullRefresh() async {
      _postService.getall().then((value) {
        setState(() {
          lstPosts = value;
        });
      });
      // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
    }

    return ScreenBase(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          newPostForm(),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: lstPosts.isNotEmpty
                ? RefreshIndicator(
                    child: ListView.builder(
                        itemCount: lstPosts.length,
                        itemBuilder: (context, index) {
                          return PostWidget(post: lstPosts[index]);
                        }),
                    onRefresh: _pullRefresh)
                : const Center(child: Text("No Posts")),
          )
        ],
      ),
    ));
  }

  Widget newPostForm() {
    return Container(
        width: ScreenWH(context).width,
        decoration: BoxDecoration(
          color: Colors.grey[600],
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'Make a Post',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Column(
              children: [

                Container(
                  margin: const EdgeInsets.all(12),
                  height: 4 * 18.0,
                  child: TextField(
                    controller: _newPostDescripController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: getBorder(false),
                      enabledBorder: getBorder(false),
                      focusedBorder: getBorder(true),
                      hintText: "Enter a post description",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      )),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(goldPrimary),
                    ),
                    onPressed: () {
                      _postService.addPost(
                          _newPostDescripController.text, userId,"false");
                      _newPostDescripController.clear();
                      _newPostTitleController.clear();
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  OutlineInputBorder getBorder(bool focused) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      borderSide:
          BorderSide(width: 2, color: focused ? Colors.black : borderGrey),
      gapPadding: 2,
    );
  }
}
