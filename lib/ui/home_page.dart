import 'dart:io';

import 'package:flutter/material.dart';

import '../helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = <Contact>[];

  @override
  void initState(){
    super.initState();

    helper.getAllContacts().then((list){
      setState((){
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index){
            return _contactCard(context, index);

          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ?
                        FileImage(File(contacts[index].img!)) as ImageProvider :
                          AssetImage("images/person.png")
                  ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Column(
                      children: [
                        Text(contacts[index].name ?? "",
                        style: TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                        ),
                        Text(contacts[index].email ?? "",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Text(contacts[index].phone ?? "",
                          style: TextStyle(fontSize: 18.0),
                        ),

                      ],
                    ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
