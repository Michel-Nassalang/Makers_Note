import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:maker_note/Creationpage.dart';
import 'package:maker_note/NoteDatabase.dart';
import 'package:maker_note/Vocalpage.dart';
import 'package:maker_note/composant.dart';
import 'package:maker_note/Settings.dart';
import 'About.dart';
import 'Favoritepage.dart';
import 'Notepage.dart';
import 'package:share/share.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'VocalNotepage.dart';

class Listcomposant extends StatefulWidget {
  Listcomposant({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return Listing();
  }
}

class Listing extends State<Listcomposant> {
  void creation() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => new Creationpage()));
  }

  void creationvocal() async {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (context) => new Vocalpage()));
  }

  Future<List<Composant>> notepresent = NoteDatabase.instance.composants();
  bool research = false;

  void recharge(String nom) {
    setState(() {
      notepresent = NoteDatabase.instance.recherche(nom);
    });
  }

  void searchange() {
    setState(() {
      if (customIcon.icon == Icons.search_rounded) {
        customIcon = Icon(Icons.cancel);
        research = true;
        sujet = 'Pas de résultats';
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
        notepresent = NoteDatabase.instance.composants();
        sujet = 'Ajout de notes';
        research = false;
      }
    });
  }

  Icon customIcon = Icon(Icons.search_rounded, color: Colors.white);
  Widget customtitle = Text('Maker\'s Note');
  final controlnom = TextEditingController();
  String sujet = 'Ajout de notes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), bottomRight: Radius.circular(50)),
        ),
        margin: EdgeInsets.only(top: 30),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(top: 17.5, right: 17.5, bottom: 17.5),
          width: 300,
          height: 550,
          decoration: new BoxDecoration(
              // color: Colors.white,
              borderRadius: new BorderRadius.only(
            bottomRight: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0),
          )),
          child: Drawer(
            elevation: 0,
            child: ListView(
              children: [
                DrawerHeader(
                    child: Center(
                  child: Container(
                    child: Image.asset('images/makers.png'),
                  ),
                )),
                Padding(padding: EdgeInsets.only(top: 20)),
                Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 30),
                    leading: Icon(Icons.menu_book_rounded, color: Colors.blue),
                    title: Text('Notes'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new Listcomposant(title: 'Maker\'s Note')),
                          (route) => false);
                    },
                  ),
                ),
                Card(
                  child: Hero(
                    tag: 'favorisHero',
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      leading: Icon(Icons.favorite, color: Colors.blue),
                      title: Text('Favoris'),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) =>
                                    new Favoritepage(title: 'Notes favoris')));
                      },
                    ),
                  ),
                ),
                Card(
                  child: Hero(
                    tag: 'parametresHero',
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      leading: Icon(Icons.settings, color: Colors.blue),
                      title: Text('Paramètres'),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Settings()));
                      },
                    ),
                  ),
                ),
                Card(
                  child: Hero(
                    tag: 'proposHero',
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 30),
                      leading: Icon(Icons.align_vertical_bottom_outlined,
                          color: Colors.blue),
                      title: Text('A Propos'),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new About()));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        title: customtitle,
        actions: [
          Container(
            width: 35,
            child: IconButton(onPressed: searchange, icon: customIcon),
          ),
          Container(
            width: 35,
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Favoritepage(title: 'Maker\s Note')));
                },
                icon: Icon(Icons.favorite, color: Colors.white)),
          ),
          Padding(padding: EdgeInsets.only(right: 20))
        ],
      ),
      body: FutureBuilder<List<Composant>>(
          future: notepresent,
          builder:
              (BuildContext context, AsyncSnapshot<List<Composant>> snapshot) {
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
                            Column(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 7)),
                                Text(sujet),
                                Padding(padding: EdgeInsets.only(top: 15)),
                                Container(
                                  child: research
                                      ? SpinKitFadingCube(
                                          color: Colors.blue, size: 35)
                                      : Container(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return new Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.builder(
                        itemCount: composant.length,
                        itemBuilder: (context, index) {
                          final present = composant[index];
                          return new Slidable(
                            key: Key(present.titre + '${present.id}'),
                            actionPane: SlidableScrollActionPane(),
                            child: new Containerobjet(composant: present),
                            actionExtentRatio: 1 / 4,
                            direction: Axis.horizontal,
                            actions: [
                              IconSlideAction(
                                caption: 'Modification',
                                color: Colors.blue,
                                icon: Icons.mode_edit_outlined,
                                foregroundColor: Colors.white,
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              Notepage(
                                                  titre: 'Note : ${present.id}',
                                                  composant: present),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.ease);
                                            return FadeTransition(
                                                opacity: animation,
                                                child: child);
                                          }));
                                },
                              ),
                              IconSlideAction(
                                caption: 'Partage',
                                color: Colors.blue[400],
                                icon: Icons.share,
                                foregroundColor: Colors.white,
                                onTap: () {
                                  Share.share(present.note);
                                },
                              ),
                              IconSlideAction(
                                  caption: 'Suppression',
                                  color: Colors.blue[300],
                                  icon: Icons.delete_forever_rounded,
                                  foregroundColor: Colors.white,
                                  onTap: () {
                                    setState(() {
                                      composant.removeAt(index);
                                      NoteDatabase.instance
                                          .deleteNote(present.id);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.grey,
                                            content: Text(present.titre +
                                                ' est bien supprimé')));
                                  }),
                              IconSlideAction(
                                caption: 'Annulation',
                                color: Colors.blue[200],
                                icon: Icons.cancel,
                                foregroundColor: Colors.white,
                              )
                            ],
                            secondaryActions: [
                              IconSlideAction(
                                caption: 'Modification',
                                color: Colors.blue,
                                icon: Icons.mode_edit_outlined,
                                foregroundColor: Colors.white,
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              Notepage(
                                                  titre: 'Note : ${present.id}',
                                                  composant: present),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            animation = CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.ease);
                                            return FadeTransition(
                                                opacity: animation,
                                                child: child);
                                          }));
                                },
                              ),
                              IconSlideAction(
                                caption: 'Partage',
                                color: Colors.blue[400],
                                icon: Icons.share,
                                foregroundColor: Colors.white,
                                onTap: () {
                                  Share.share(present.note);
                                },
                              ),
                              IconSlideAction(
                                  caption: 'Suppression',
                                  color: Colors.blue[300],
                                  icon: Icons.delete_forever_rounded,
                                  foregroundColor: Colors.white,
                                  onTap: () {
                                    setState(() {
                                      composant.removeAt(index);
                                      NoteDatabase.instance
                                          .deleteNote(present.id);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(present.titre +
                                                ' est bien supprimé'),
                                            backgroundColor: Colors.grey));
                                  }),
                              IconSlideAction(
                                caption: 'Annulation',
                                color: Colors.blue[200],
                                icon: Icons.cancel,
                                foregroundColor: Colors.white,
                              )
                            ],
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

class Containerobjet extends StatefulWidget {
  const Containerobjet({Key? key, required this.composant}) : super(key: key);
  final Composant composant;

  @override
  _ContainerobjetState createState() => _ContainerobjetState();
}

class _ContainerobjetState extends State<Containerobjet> {
  bool changeExpansion = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.composant.isVocal == false) {
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Notepage(
                            titre: 'Note : ${this.widget.composant.id}',
                            composant: this.widget.composant),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      animation = CurvedAnimation(
                          parent: animation, curve: Curves.ease);
                      return FadeTransition(opacity: animation, child: child);
                    }));
          } else {
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        VocalNotepage(
                            titre: 'Note : ${this.widget.composant.id}',
                            composant: this.widget.composant),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      animation = CurvedAnimation(
                          parent: animation, curve: Curves.ease);
                      return FadeTransition(opacity: animation, child: child);
                    }));
          }
        },
        child: Card(
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          elevation: 7,
          child: Row(
            children: [
              Container(
                width: 75,
                height: 75,
                margin: EdgeInsets.only(right: 5),
                child: Hero(
                    tag: 'note_page' + widget.composant.titre,
                    child: Stack(
                      children: [
                        Container(
                          child: Center(
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          width: 75,
                          height: 75,
                        ),
                      ],
                    )),
              ),
              Expanded(
                  child: ExpansionTile(
                title: Text(widget.composant.titre,
                    textAlign: TextAlign.start,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: 
                    Text(widget.composant.note + ' ...',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                trailing: Icon(
                  changeExpansion
                      ? Icons.arrow_drop_down_circle
                      : Icons.arrow_drop_down,
                ),
                onExpansionChanged: (bool expandre) {
                  setState(() {
                    changeExpansion = expandre;
                  });
                },
                childrenPadding:
                    EdgeInsets.only(left: 15, right: 20, bottom: 10),
                children: [
                  Text(widget.composant.note,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              )),
            ],
          ),
        ));
  }
}
