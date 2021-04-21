/*  Visão anual da tabela de turno
*   Esta página gera uma tabela de turno para 5 grupos.
*   Os dados utilizados na formação dos grupos estão no
*   arquivo dados.dart. Isto visa facilitar e organizar
*   as informações em um só arquivo para facilitar a
*   depuração, correção e alteração dos dados. */
import 'package:flutter/material.dart';
import 'rotinas.dart';

class VisaoAnual extends StatefulWidget {
  @override
  _VisaoAnualState createState() => _VisaoAnualState();
}

class _VisaoAnualState extends State<VisaoAnual> {
  @override
  Widget build(BuildContext context) {
    List<Widget> vaa=[];
    vaa = corpoTabela("a");
    return ListView.builder(
        itemCount: vaa.length,
        itemBuilder: (context ,indice){
          return vaa[indice];

        });
  }
}

/*
Container(
//padding: EdgeInsets.only(top: 5),
color: Colors.white,
width: double.maxFinite,
height: double.maxFinite,
child: SingleChildScrollView(
child: Column(
children: [

corpoWrap("a"),
],
),
));*/
