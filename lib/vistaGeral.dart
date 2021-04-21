import 'package:flutter/material.dart';
import 'package:tabela_de_turno/rotinas.dart';

class VistaGeral extends StatefulWidget {
  @override
  _VistaGeralState createState() => _VistaGeralState();
}

class _VistaGeralState extends State<VistaGeral> {
  @override
  Widget build(BuildContext context) {
    List<Widget> vaa=[];
    vaa = corpoTabela("aa");
    return ListView.builder(
        itemCount: vaa.length,
        itemBuilder: (context ,indice){
          return vaa[indice];

        });
  }

}


