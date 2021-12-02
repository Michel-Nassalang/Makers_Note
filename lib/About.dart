import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class About extends StatefulWidget {
  @override
  _About createState() => _About();
}

class _About extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('A propos'),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 60)),
              Stack(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      width: 350,
                      height: 150,
                      padding: EdgeInsets.only(left: 200),
                      child: Center(
                          child: Text(
                        'Maker\'s',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontStyle: FontStyle.italic),
                      )),
                    ),
                  ),
                  Hero(
                    tag: 'proposHero',
                    child: Container(
                      margin: EdgeInsets.only(left: 30),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[350],
                      ),
                      child: Image.asset('images/makers.png'),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Maker\'s Note est une application pour prise de notes vocales ou écrites. Le groupe Makers de l\'Institut Polytechnique de Saint Louis de par sa créativité a réalisé cette application. Elle est très facile d\'utilisation, très flexible.',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(left: 30, right: 30),
                  child: Text(
                    'Pour utiliser les notes, il faudra d\'abord configurer la synthese vocale de votre smartphone pour que les vocaux soient pris en charge. ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Center(
                child: Text('∞ Makers 2021 ∞',
                    style: TextStyle(fontSize: 16, color: Colors.blue)),
              )
            ],
          )
        ],
      ),
    );
  }
}
