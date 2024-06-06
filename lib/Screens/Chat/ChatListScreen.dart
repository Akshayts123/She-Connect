import 'package:flutter/material.dart';
import 'package:she_connect/Const/Constants.dart';
import 'package:she_connect/Const/network.dart';
import 'package:she_connect/MainWidgets/loading.dart';
import 'package:she_connect/Screens/Chat/DATA/listAllChatsAPI.dart';
import 'package:she_connect/Screens/Chat/chatScreen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  var arrChat;
  var load = true;

  @override
  void initState() {
    super.initState();
    this.getDetails();
    setState(() {});
  }

  Future<String> getDetails() async {
    var rsp = await listAllChatsAPI();
    if (rsp["status"].toString() == "success") {
      arrChat = rsp["data"];
    }
    setState(() {
      load = false;
    });
    return "success";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Chats", style: appBarTxtStyl),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 25)),
      ),
      body: load == true
          ? loading()
          : arrChat.length == 0
              ? Center(child: Text("No Recent Chats", style: size14_600))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (context, index) =>
                        Divider(color: Colors.black45, height: 20),
                    shrinkWrap: true,
                    itemCount: arrChat.length != null ? arrChat.length : 0,
                    itemBuilder: (context, index) {
                      final item = arrChat != null ? arrChat[index] : null;
                      return chatList(item, index);
                    },
                  ),
                ),
    );
  }

  chatList(var item, int index) {
    return GestureDetector(
      onTap: () {
        print(item);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => chatScreen(
                    refresh: getDetails,
                    image: item["isAddImage"],
                    name: item["vendor"]["name"],
                    subject: item["subject"].toString(),
                    from: "aaa",
                    orderID: "aaaaa",
                    chatId: item["_id"].toString(),
                  )),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[200],
          backgroundImage: NetworkImage(
              chatImageBaseUrl + item["vendor"]["image"].toString()),
        ),
        title: Text(item["subject"].toString(), style: size16_400),
        subtitle: Text(item["vendor"]["name"].toString()),
        trailing: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text(
              item["status"].toString() == "OPEN" ? "Open" : "Closed",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: item["status"].toString() == "OPEN"
                      ? Colors.green
                      : Colors.red),
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(
                  color: item["status"].toString() == "OPEN"
                      ? Colors.green
                      : Colors.red)),
        ),
      ),
    );
  }
}
