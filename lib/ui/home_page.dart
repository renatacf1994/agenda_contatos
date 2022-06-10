import 'dart:io';

import 'package:agenda_contatos/ui/contact_page.dart';
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

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(10.0),
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
          padding: const EdgeInsets.all(10.0),
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
                          const AssetImage("images/person.png")
                  ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contacts[index].name ?? "",
                        style: const TextStyle(fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                        ),
                        Text(contacts[index].email ?? "",
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        Text(contacts[index].phone ?? "",
                          style: const TextStyle(fontSize: 18.0),
                        ),

                      ],
                    ),
                )

            ],
          ),
        ),
      ),
      onTap: (){
        _showContactPage(contact: contacts[index]);
      },
    );
  }

  void _showContactPage({Contact ? contact}) async {
    final recContact = await Navigator.push(context,
    MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      }else{
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState((){
        contacts = list;
      });
    });
  }
}
