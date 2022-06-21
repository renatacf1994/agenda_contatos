import 'dart:io';

import 'package:agenda_contatos/widgets/botao_widget.dart';
import 'package:flutter/material.dart';

import '../helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {

  final Contact? contact;

  const ContactPage({Key? key, this.contact}) : super(key: key);



  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact? _editedContact;

  @override
  void initState(){
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    } else{
      _editedContact = widget.contact!;

      _nameController.text = _editedContact!.name ?? "";
      _emailController.text = _editedContact!.email ?? "";
      _phoneController.text = _editedContact!.phone ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Text(_editedContact!.name ?? "Novo Contato"),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(_editedContact!.name != null && _editedContact!.name!.isNotEmpty){
                  Navigator.pop(context, _editedContact);
                }else{
                  FocusScope.of(context).requestFocus(_nameFocus);

                }
              } ,
              backgroundColor: Colors.red,
              child: const Icon(Icons.save),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      width: 140.0,
                      height: 140.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact?.img != null ?
                            FileImage(File(_editedContact!.img!)) as ImageProvider :
                            const AssetImage("images/person.png"),
                            fit: BoxFit.cover
                        ),
                      ),
                    ),
                    onTap: (){
                     _showOptions(context);
                    },
                  ),
                  TextField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: const InputDecoration(labelText: "Nome"),
                    onChanged: (text){
                      _userEdited = true;
                      setState((){
                        _editedContact!.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    onChanged: (text){
                      _userEdited = true;
                      _editedContact!.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: "Phone"),
                    onChanged: (text){
                      _userEdited = true;
                      _editedContact!.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                  ),


                ],
              ),
            ),
        ),
        );
  }

  Future<bool>_requestPop(){
    if(_userEdited){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: const Text("Descartar Alterações?"),
              content: const Text("Se sair as alterações serão perdidas."),
              actions: [
                botaoWidget("Cancelar", () {
                  Navigator.pop(context);
                }),
                botaoWidget("Sim", () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                })
            ]
            );
          }
          );
      return Future.value(false);
    } else{
      return Future.value(true);
    }
  }

  void _showOptions(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
              onClosing: (){},
              builder: (context){
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: botaoWidget("Câmera", () {
                          Navigator.pop(context);
                          ImagePicker().pickImage(source: ImageSource.camera).then((file){
                            if(file == null) return;
                            setState((){
                              _editedContact?.img = file.path;
                            });
                          });
                        })
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: botaoWidget("Galeria", () {
                          Navigator.pop(context);
                          ImagePicker().pickImage(source: ImageSource.gallery).then((file){
                            if(file == null) return;
                            setState((){
                              _editedContact?.img = file.path;
                            });
                          });
                        })
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: botaoWidget("Cancelar", () {
                          Navigator.pop(context);
                        }),
                      ),
                    ],
                  ),
                );
              }
          );
        }
    );
  }

}
