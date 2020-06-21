import 'dart:io';

import 'package:flutter/material.dart';

import 'package:crud_rest_api/models/post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomeScreen extends StatelessWidget {
  String url = 'https://jsonplaceholder.typicode.com/posts';

  Future<Post> getPost() async {
    final response = await http.get('$url/1');
    return postFromJson(response.body);
  }

  Post post1 = Post(
      id: 3,
      userId: 9,
      body: 'This is Adnan Test Body',
      title: 'Adnan Post Method');

  Future<http.Response> createPost(Post post) async {
    final response = await http.post('$url',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: ''
        },
        body: postToJson(post));
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                showDialog(
                  context: context,
                  child: FutureBuilder<Post>(
                      future: getPost(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return AlertDialog(
                            title: Text(
                                'Title from Post JSON : ${snapshot.data.title} \nUser ID from Post JSON: ${snapshot.data.id}'),
                          );
                        else
                          return CircularProgressIndicator(
                            strokeWidth: 2,
                          );
                      }),
                );
              },
              child: Text('Read from Rest API'),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: RaisedButton(
              elevation: 5,
              onPressed: () {
                createPost(post1).then((response) {
                  if (response.statusCode == 200) {
                    showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Successfully Added!'),
                      ),
                    );
                  } else
                    print(response.statusCode);
                });
              },
              child: Text('Write to Rest API'),
            ),
          ),
        ],
      )),
    );
  }
}
