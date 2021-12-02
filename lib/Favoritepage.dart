import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:maker_note/About.dart';
import 'package:maker_note/Creationpage.dart';
import 'package:maker_note/NoteDatabase.dart';
import 'package:maker_note/composant.dart';
import 'Settings.dart';
import 'Vocalpage.dart';
import 'listcomposant.dart';

class Favoritepage extends StatefulWidget {
  Favoritepage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return Listing();
  }
}

enum cote { parametres, propos, home }
dynamic _selection;

class Listing extends State<Favoritepage> {
  void creation() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Creationpage()));
  }

  void func(_selection) {
    if (_selection == cote.home) {
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new Listcomposant(title: 'Maker\'s Note')),
          (route) => false);
    } else if (_selection == cote.parametres) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Settings()));
    } else if(_selection == cote.propos) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
    }
  }


  Future<List<Composant>> notepresent = NoteDatabase.instance.favoris();
  bool research = false;
  
  void creationvocal() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (_) => new Vocalpage()));
  }

  void recharge(String nom) {
    setState(() {
      notepresent = NoteDatabase.instance.recherchefavoris(nom);
    });
  }

  void searchange() {
    setState(() {
      if (customIcon.icon == Icons.search_rounded) {
        customIcon = Icon(Icons.cancel);
        research = true;
        customtitle = ListTile(
          leading: Container(
              width: 20,
              child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.search_rounded, color: Colors.white))),
          title: TextField(
            controller: controlnom,
            onChanged: recharge,
            autofocus: true,
            onSubmitted: null,
            decoration: InputDecoration(
              hintText: 'Chercher par titre ...',
              hintStyle: TextStyle(fontStyle: FontStyle.italic),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
          ),
        );
      } else {
        customIcon = Icon(Icons.search_rounded, color: Colors.white);
        customtitle = Text(widget.title);
        notepresent = NoteDatabase.instance.favoris();
        research = false;
      }
    });
  }


  Icon customIcon = Icon(Icons.search_rounded, color: Colors.white);
  Widget customtitle = Text('Notes favoris');
  final controlnom = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: customtitle,
          // leading: Icon(Icons.notes),
          actions: [
            Container(
              width: 35,
              child: IconButton(onPressed: searchange, icon: customIcon),
            ),
            Container(
              width: 35,
              child: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.favorite, color: Colors.white)),
            ),
            PopupMenuButton<cote>(
              onSelected: (cote result) {
                setState(() {
                  _selection = result;
                });
                func(_selection);
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<cote>>[
                const PopupMenuItem<cote>(
                  value: cote.home,
                  child: Text('Acceuil'),
                ),
                const PopupMenuItem<cote>(
                  value: cote.parametres,
                  child: Text('Paramètres'),
                ),
                const PopupMenuItem<cote>(
                  value: cote.propos,
                  child: Text('A Propos...'),
                ),
              ],
            )
          ],
        ),
        body: FutureBuilder<List<Composant>>(
            future: notepresent,
            builder: (BuildContext context,
                AsyncSnapshot<List<Composant>> snapshot) {
              if (snapshot.hasData) {
                List<Composant>? composant = snapshot.data;
                if (composant!.length == 0) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: 150,
                                height: 150,
                                child: Image.asset('images/makers.png'),
                              ),
                              Padding(padding: EdgeInsets.only(top: 7)),
                              Text('Il n\'existe pas encore de favoris'),
                              Padding(padding: EdgeInsets.only(top: 15)),
                            Container(
                              child: research
                                  ? SpinKitFadingCube(
                                      color: Colors.blue, size: 35)
                                  : Container(),
                            )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Scrollbar(
                      isAlwaysShown: true,
                      child: ListView.builder(
                          itemCount: composant.length,
                          itemBuilder: (context, index) {
                            final present = composant[index];
                            return Dismissible(
                              key: Key(present.titre + '${present.id}'),
                              child: Containerobjet(composant: present),
                              onDismissed: (direction) {
                                setState(() {
                                  composant.removeAt(index);
                                  NoteDatabase.instance.updateNote(
                                      present.titre,
                                      present.note,
                                      present,
                                      false);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(present.titre +
                                            ' est bien supprimé des favoris'),
                                        backgroundColor: Colors.grey));
                              },
                              background: Container(
                                color: Colors.grey,
                                child: Row(
                                  children: [
                                    Padding(padding: EdgeInsets.all(10)),
                                    Expanded(
                                        child: Row(
                                      children: [
                                        Image.asset('images/makers.png'),
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 10)),
                                        Text('Elimination de favori'),
                                      ],
                                    )),
                                    Icon(Icons.delete_sweep),
                                    Padding(
                                        padding: EdgeInsets.only(right: 10)),
                                  ],
                                ),
                              ),
                            );
                          }));
                }
              } else {
                return Center(
                  child: SizedBox(
                    child: SpinKitFadingCube(color: Colors.blue, size: 40),
                  ),
                );
              }
            }),
        floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 35,
            height: 35,
            child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: creationvocal,
                child: Icon(Icons.mic_sharp, size: 18, color: Colors.white),
                tooltip: 'Vocal'),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: creation,
            child: Icon(Icons.edit, color: Colors.white),
            elevation: 5,
            tooltip: 'Ajouter une note',
          )
        ],
      ),
    );
  }
}
