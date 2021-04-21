/* Visão mensal*/

import 'package:flutter/material.dart';
import 'package:tabela_de_turno/dados.dart';
import 'rotinas.dart';

class VisaoMensal extends StatefulWidget {
  @override
  _VisaoMensalState createState() => _VisaoMensalState();
}

class _VisaoMensalState extends State<VisaoMensal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: largura,
      height: double.infinity,
      //color: Colors.white,
      child:GestureDetector(
        onVerticalDragStart: (dstr){
          //ToDo
        },
          onVerticalDragEnd: (valor){
          //ToDo
        },

          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(top:5),
                  child: corpoTabela("m")//mesWrap()

              ))),
    );
  }
}

