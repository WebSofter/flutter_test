import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/models/user.dart';
import 'models/image.dart';

class UserDetail extends StatelessWidget {
  User user;
  UserDetail(this.user, {Key? key}) : super(key: key);

  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyListScreen(user),
    );
  }
}

class MyListScreen extends StatefulWidget {
  User user;

  MyListScreen(this.user, {Key? key}) : super(key: key);

  @override
  createState() => _MyListScreenState(user);
}

class _MyListScreenState extends State {
  User user;
  _MyListScreenState(this.user);
  final _textUserNameController = TextEditingController();
  @override
  initState() {
    super.initState();
    _fetchImage();
    _textUserNameController.text = user.name;
  }

  @override
  dispose() {
    super.dispose();
  }

  int _imageId = 1;
  //final List<ImageModel> _images = [];
  final List<String> imageList = [];
  static const _imageEndpoint = 'http://jsonplaceholder.typicode.com/photos';

  void _fetchImage() async {
    String url = '$_imageEndpoint/$_imageId';
    final response = await get(Uri.parse(url));
    final parsedJson = json.decode(response.body);

    final img = ImageModel.fromJson(parsedJson);
    setState(() {
      //_images.add(img);
      _imageId++;
      imageList.add(img.url);
    });
  }

  Future<String?> _showTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Редактирвоание профиля'),
            content: TextField(
              controller: _textUserNameController,
              decoration: const InputDecoration(hintText: "Введите имя"),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Отмена"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                child: const Text('Ок'),
                onPressed: () async {
                  final body =
                      jsonEncode({'name': _textUserNameController.text});
                  final url = Uri.http('http://test.com', 'control.php');
                  await post(url,
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer 123',
                      },
                      body: body);

                  Navigator.pop(context, _textUserNameController.text);
                },
              ),
            ],
          );
        });
  }

  Widget getSlider() {
    return Container(
      margin: const EdgeInsets.all(15),
      child: CarouselSlider.builder(
        itemCount: imageList.length,
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 100,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          reverse: false,
          aspectRatio: 5.0,
        ),
        itemBuilder: (context, i, id) {
          //for onTap to redirect to another screen
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.white,
                  )),
              //ClipRRect for image border radius
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageList[i],
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getProfile(userName, userPic) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: CircleAvatar(
                radius: 110,
                backgroundColor: Color(0xffFDCF09),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(userPic),
                )),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Привет $userName',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'пользователь',
                style: TextStyle(
                  fontFamily: 'SF Pro',
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: TextButton(
                onPressed: () async {
                  var resultLabel = await _showTextInputDialog(context);
                  if (resultLabel != null) {
                    //setState(() {
                    //  label = resultLabel;
                    //});
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFEF476F),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Text(
                    'измнеить профиль',
                    style: TextStyle(
                      fontFamily: 'SF Pro',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Пользователь"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getProfile(_textUserNameController.text,
                "https://s3.o7planning.com/images/boy-128.png"),
            getSlider()
          ],
        ),
      ),
    );
  }
}
