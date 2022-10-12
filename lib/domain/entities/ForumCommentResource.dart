import 'ForumResource.dart';
import 'PersonResource.dart';

class ForumCommentResource{


  final int id;

  final String commentdescription;

  final String registerdate;

  final PersonResource person;

  final ForumResource forum;

  ForumCommentResource(this.id,this.commentdescription,this.registerdate,this.person,this.forum);




}