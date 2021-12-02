import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:maker_note/NoteDatabase.dart';
import 'listcomposant.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:avatar_glow/avatar_glow.dart';

class Vocalpage extends StatefulWidget {
  @override
  _VocalpageState createState() => _VocalpageState();
}

class _VocalpageState extends State<Vocalpage> {

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      initial = controlnote.value.text;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  String initial = '';
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if(initial.isEmpty){
        controlnote = new TextEditingController(text:_lastWords);
      }else{
        controlnote = new TextEditingController(text: initial + '. ' + _lastWords);
      }
    });
  }

  String titre = '';
  void affiche(String plus) {
    setState(() {
      titre = plus;
    });
  }

  void insertion() {
    if (controlnote.value.text.isEmpty) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Echec, la note est vide.'),
          backgroundColor: Colors.grey));
    } else {
      NoteDatabase.instance.insertNote(
          controltitre.value.text, controlnote.value.text, faveurIcon, true);
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (_) => new Listcomposant(title: 'Maker\'s Note')),
          (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Succes, la note est enrigistrée.'),
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

  var controltitre = TextEditingController();
  var controlnote = TextEditingController();

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
                      Padding(padding: EdgeInsets.only(left: 25)),
                      Icon(Icons.record_voice_over_rounded, color : _speechToText.isNotListening ? Colors.grey : Colors.blue),
                    Padding(padding: EdgeInsets.only(left: 10)),
                      Icon(Icons.edit, color : _speechToText.isNotListening ? Colors.blue : Colors.grey),
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
                      autocorrect: false,
                      autofocus: false,
                      controller: controlnote,
                      // keyboardType: TextInputType.none,
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
        ),
      floatingActionButton: AvatarGlow(
        animate: _speechToText.isListening,
        endRadius: 75.0,
        glowColor: Colors.blue,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds:100),
        repeat: true,
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed:
              // If not yet listening for speech start, otherwise stop
              _speechToText.isNotListening ? _startListening : _stopListening,
          tooltip: 'Ecoute',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic, color: Colors.white),
        ),
      ),
    );
  }
}
