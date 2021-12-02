import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maker_note/NoteDatabase.dart';
import 'listcomposant.dart';

class Creationpage extends StatefulWidget {
  @override
  _CreationpageState createState() => _CreationpageState();
}

class _CreationpageState extends State<Creationpage> {


  void initState() {
    super.initState();
  
  }
  String titre = '';
  void affiche(String plus) {
    setState(() {
      titre = plus;
    });
  }

  void insertion() {
    if (controlnote.value.text.isEmpty) {
      Navigator.pop(context,true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Echec, la note est vide.'), backgroundColor: Colors.grey));
    } else {
      NoteDatabase.instance.insertNote(controltitre.value.text, controlnote.value.text, faveurIcon, false);
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (_) => new Listcomposant(title: 'Maker\'s Note')),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Succes, la note est enrigistrée.'),
          backgroundColor: Colors.grey));
    }
  }

  bool faveurIcon = false;

    void changefavorite() {
    if (faveurIcon == false) {
      setState(() {
        faveurIcon = true;
      });
    } else {
      setState(() {
        faveurIcon = false;
      });
    }
  }

  final controltitre = TextEditingController();
  final controlnote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nouveau note : ' + titre),
        ),
        body: Scrollbar(
          child: ListView(
            children: [
              Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: changefavorite,
                          icon: Icon(
                              faveurIcon 
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.blue)),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              Icon(Icons.cancel, color: Colors.grey, size: 30),
                          padding: EdgeInsets.only(right: 5)),
                      IconButton(
                          onPressed: insertion,
                          icon: Icon(Icons.check_circle_rounded,
                              color: Colors.blue, size: 30),
                          padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 25, left: 25),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: controltitre,
                      autocorrect: true,
                      onChanged: affiche,
                      decoration: InputDecoration(
                          labelText: 'Titre',
                          border: OutlineInputBorder(
                              borderSide:BorderSide(color: Colors.blue, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5)))),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Container(
                    margin: EdgeInsets.only(right: 25, left: 25),
                    child: TextField(
                      minLines: 25,
                      maxLines: 1000,
                      controller: controlnote,
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: 'Note',
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width:1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(2.5),
                                bottomRight: Radius.circular(2.5),
                              ))),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
