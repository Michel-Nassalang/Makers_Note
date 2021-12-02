import 'package:flutter/material.dart';
import 'NoteDatabase.dart';
import 'composant.dart';
import 'listcomposant.dart';

class Notepage extends StatefulWidget {
  Notepage({Key? key, required this.titre, required this.composant})
      : super(key: key);
  final String titre;
  final Composant composant;

  @override
  _Page createState() => _Page();
}

class _Page extends State<Notepage> {
  void miseajour() {
    if (controlnote.value.text.isEmpty) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Echec, la note est vide.'),
          backgroundColor: Colors.grey));
    } else {
      NoteDatabase.instance.updateNote(
          controltitre.value.text,
          controlnote.value.text,
          widget.composant,
          widget.composant.isFavorite);
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (_) => new Listcomposant(title: 'Maker\'s Note')),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Succes, la note est mise à jour.'),
          backgroundColor: Colors.grey));
    }
  }

  void affiche(String plus) {
    setState(() {
      widget.composant.titre = plus;
    });
  }

  void changefavorite() {
    if (widget.composant.isFavorite == false) {
      setState(() {
        widget.composant.isFavorite = true;
      });
    } else {
      setState(() {
        widget.composant.isFavorite = false;
      });
    }
  }

  late TextEditingController controltitre;
  late TextEditingController controlnote;
  void initState() {
    super.initState();
    controltitre = new TextEditingController(text: widget.composant.titre);
    controlnote = new TextEditingController(text: widget.composant.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Note : ' + widget.composant.titre),
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
                              widget.composant.isFavorite
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
                          onPressed: miseajour,
                          icon: Icon(Icons.check_circle_rounded,
                              color: Colors.blue, size: 30),
                          padding: EdgeInsets.only(right: 25))
                    ],
                  ),
                   Container(
                      margin: EdgeInsets.only(right: 25, left: 25),
                        child: TextField(
                          maxLength: 40,
                          keyboardType: TextInputType.name,
                          controller: controltitre,
                          autocorrect: true,
                          onChanged: affiche,
                          decoration: InputDecoration(
                              labelText: 'Titre',
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 1),
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
                                  BorderSide(color: Colors.blue, width: 1),
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
