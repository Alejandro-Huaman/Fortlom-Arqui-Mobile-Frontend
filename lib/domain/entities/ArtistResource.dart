import 'dart:typed_data';

class ArtistResource{
  final int id;

  final String username;

  final String realname;

  final String lastname;

  final String email;

  final String password;

  final String? content;

  int artistfollowers;

  final String? instagramLink;

  final String? facebookLink;

  final String? twitterLink;

  ArtistResource(this.id,this.username,this.realname,this.lastname,this.email,this.password,this.content,
                 this.artistfollowers,this.instagramLink,this.facebookLink,this.twitterLink);

}