import 'package:flutter/material.dart';

void main() {
  UserInfo userInfo = UserInfo(
    profilePicture: 'assets/images/user1.jpg',
    name: 'Homer Simpson',
    location: 'Springfield, Oregon',
    status: "Love ❤️. Laugh 😆. Slay 👑. D'oh! 🍩🍺📺.",
    hobbies: ['Gaming', 'Eating Donuts', 'Napping'],
    followers: 500,
    following: 200,
    photos: ['assets/images/card1.jpg', 'assets/images/card2.jpg', 'assets/images/card3.jpg'],
    photoTitles: ['Homer at Moe\'s', 'Mmm... Donuts', 'Naptime'],
    postTitles: ["D'oh! Moment", "Simpson Family Adventures"],
    posts: [
        'D\'oh! I can\'t believe I did it again! I left the oven on all night. Marge is not going to be happy about this. Maybe a few donuts will make everything better.',
        'Family time with Bart, Lisa, and Marge. We went on an adventure to Krustyland today. Bart tried to skateboard on a roller coaster. Lisa was her usual smart self, and Marge kept us all in line. Life may be chaotic, but I love my family. 🍩📺',
    ]

  );

  runApp(MaterialApp(home: UserInfoPage(userInfo: userInfo)));
}

class UserInfo {
  final String profilePicture;
  final String name;
  final String location;
  final String status;
  final List<String> hobbies;
  final int followers;
  final int following;
  final List<String> photos;
  final List<String> posts;
  final List<String> photoTitles; // Added field for photo titles
  final List<String> postTitles; // Added field for post titles

  UserInfo({
    required this.profilePicture,
    required this.name,
    required this.location,
    required this.status,
    required this.hobbies,
    required this.followers,
    required this.following,
    required this.photos,
    required this.posts,
    required this.photoTitles,
    required this.postTitles,
  });
}

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({super.key, required this.userInfo});

  final UserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
      ),
      title: '${userInfo.name}\'s Profile',
      home: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('${userInfo.name}\'s Profile'),
          backgroundColor: Colors.purpleAccent,
          centerTitle: true,
          leading:  IconButton(
            onPressed:(){},
            icon:Icon(Icons.arrow_back_sharp),
          ),
          actions:[
            IconButton(
              onPressed:(){},
              icon:Icon(Icons.search),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          minRadius: 40.0,
                          child: Icon(
                            Icons.messenger_outline,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white54,
                          minRadius: 100.0,
                          child: CircleAvatar(
                            radius: 98.0,
                              backgroundColor: Colors.lightGreen,
                              child: CircleAvatar(
                              radius: 94.0,
                              backgroundImage:
                                  AssetImage(userInfo.profilePicture),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.green,
                          minRadius: 40.0,
                          child: Icon(
                            Icons.person_add_outlined,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${userInfo.name}',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '\n📍${userInfo.location}\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${userInfo.status}\n',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.purple,
                        child: ListTile(
                          title: Text(
                            '${userInfo.followers}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Followers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.amber,
                        child: ListTile(
                          title: Text(
                            '${userInfo.following}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Following',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white12,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Interests',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(),
                              Column(
                                  children: [Wrap(
                                    children: [
                                      for (final interest in userInfo.hobbies)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.icecream,
                                                size: 36,
                                                color: Colors.yellow,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                interest,
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.purple,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Photos',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(),
                              Text(
                                "${userInfo.photoTitles[0]}",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),

                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 4.0,

                                        ),
                                      ),
                                      child: Image.asset(
                                        "${userInfo.photos[0]}",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: 16),
                              Divider(),
                              Text(
                                "${userInfo.photoTitles[1]}",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),

                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 4.0,

                                        ),
                                      ),
                                      child: Image.asset(
                                        "${userInfo.photos[1]}",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: 16),
                              Divider(),
                              Text(
                                "${userInfo.photoTitles[2]}",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 8),

                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 4.0,

                                        ),
                                      ),
                                      child: Image.asset(
                                        "${userInfo.photos[2]}",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              SizedBox(height: 16),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white12,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Posts',
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Divider(),
                              Column(
                                  children: [Wrap(
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.text_snippet, size: 32, color: Colors.white),
                                        title: Text(
                                          "${userInfo.postTitles[0]}",
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "${userInfo.posts[0]}",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.text_snippet, size: 32, color: Colors.white),
                                        title: Text(
                                          "${userInfo.postTitles[1]}",
                                          style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          "${userInfo.posts[1]}",
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                    ],
                                  ),]
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.white12,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Text(
                                    '© 2023 TownTalk',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}