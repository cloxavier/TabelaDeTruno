import 'package:flutter/material.dart';
import 'dados.dart';
import 'rotinas.dart';

List<Widget> wdt = [];

class VisaoSemanal extends StatefulWidget {
  @override
  _VisaoSemanalState createState() => _VisaoSemanalState();
}

class _VisaoSemanalState extends State<VisaoSemanal> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.white,
        child: Wrap(
          children: [
            Container(
              //color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),

                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(Radius.circular(30),
                        ),
                        color:(isTemaDark)?Colors.white10 : Colors.blueAccent),
                    width: largura * 0.4,
                    child: TextButton(
                        //minWidth: largura*0.4,
                        // splashColor: Colors.blue  ,

                        child: Icon(
                          Icons.arrow_left,
                          color: Colors.white,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            semanas += 7;
                          });
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color:(isTemaDark)?Colors.white10 : Colors.blueAccent),
                    width: largura * 0.4,
                    child: TextButton(
                       // minWidth: largura * 0.4,
                        // splashColor: Colors.blue  ,

                        child: Icon(Icons.arrow_right,
                            color: Colors.white, size: 35),
                        onPressed: () {
                          setState(() { semanas -= 7; });
                        }),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top:5),
                child: semanaWrap())
          ],
        ));
  }


}

