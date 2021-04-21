//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabela_de_turno/dados.dart';
import 'rotinas.dart';


class VisaoDiaria extends StatefulWidget {
  @override
  _VisaoDiariaState createState() => _VisaoDiariaState();
}

class _VisaoDiariaState extends State<VisaoDiaria> {
  DateTime dataH = DateTime.now();
  double larguraInterna = 0.9;
  double tmBt = 1/numeroDeGrupos-0.01;

  @override
  void initState()  {
    super.initState();
    setState(()  {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //BBOTÃO ESQUERDA
            IconButton(
                icon: Icon(Icons.arrow_left, size: 40, color: Colors.blue),
                onPressed: () {
                  dataAtual = DateTime(anoAtual, mesAtual, diaAtual)
                      .subtract(new Duration(seconds: 60 * 60 * 24));
                  setState(() {
                    atualiza();
                  });
                }),
            //BOTÃO DATETIME PICKER
            Container(
              //width: largura * .7,
              height: 60,
              alignment: Alignment.center,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                //color: Colors.white,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: TextButton(
                  onPressed: () => showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                             firstDate: DateTime(1900),
                              lastDate: DateTime(3000)
                        ).then((value) {
                        setState(() {
                          anoAtual = value.year;
                          mesAtual = value.month;
                          diaAtual = value.day;
                          gA = tabela[indiceGr('a')];
                          gB = tabela[indiceGr('b')];
                          gC = tabela[indiceGr('c')];
                          gD = tabela[indiceGr('d')];
                          gE = tabela[indiceGr('e')];
                          gF = tabela[indiceGr('f')];
                        });
                      }),
                  child: Text(
                    "${diaSemanaComp[dataAtual.weekday - 1]} - "
                    "$diaAtual/$mesAtual/$anoAtual",
                    style: TextStyle(
                        fontSize: tamanhoFonteDataP, color: Colors.blue),
                  )),
            ),
            //BOTÃO DIREITA
            IconButton(
                icon: Icon(
                  Icons.arrow_right,
                  size: 40,
                  color: Colors.blue,
                ),
                onPressed: () {
                  dataAtual = DateTime(anoAtual, mesAtual, diaAtual)
                      .add(new Duration(seconds: 60 * 60 * 24));
                  setState(() {
                    atualiza();
                  });
                })
          ],
        ),
          Center(
          child: Card(
            shadowColor: Colors.grey,
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),

            ),
           // color: Colors.grey[200],
            margin: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: largura * larguraInterna,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Letra dos grupos
                    Container(
                        width: largura * larguraInterna,
                        child: Row(
                          //letras das tabelas de turno
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Primeiro grupo
                            Visibility(
                              visible:true,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      //defineGrupoFavorito("a");
                                      grupoAtual = grupo["a"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                    });
                                  },
                                  child: Text(grupos[0],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["a"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                            ),
                            //segundo grupo
                            Visibility(
                              visible:(numeroDeGrupos>=2)?true:false,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      grupoAtual = grupo["b"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                    });
                                  },
                                  child: Text(grupos[1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["b"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                        /* shadows: (grupoAtual == grupo["b"])
                                            ? [
                                                Shadow(
                                                  blurRadius: 3.0,
                                                  color: Colors.red,
                                                  offset: Offset(1.0, 1.0),
                                                )
                                              ]
                                            : null,*/
                                      )),
                                ),
                              ),
                            ),
                            //Terceiro grupo
                            Visibility(
                              visible:(numeroDeGrupos>=3)?true:false,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      grupoAtual = grupo["c"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                    });
                                  },
                                  child: Text(grupos[2],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["c"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                            ),
                            //Quarto grupo
                            Visibility(
                              visible:(numeroDeGrupos>=4)?true:false,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      grupoAtual = grupo["d"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                    });
                                  },
                                  child: Text(grupos[3],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["d"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                            ),
                            //Quinto grupo
                            Visibility(
                              visible:(numeroDeGrupos>=5)?true:false,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    setState(() {
                                      grupoAtual = grupo["e"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                     // leTeste();
                                    });
                                  },
                                  child: Text(grupos[4],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["e"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                            ),
                            //Sexto grupo
                            Visibility(
                              visible:(numeroDeGrupos==6)?true:false,
                              child: Container(
                                width: largura * larguraInterna * tmBt,
                                child: TextButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    setState(() {
                                      grupoAtual = grupo["f"];
                                      preferencias[0]["turnoFavorito"] =
                                          grupoAtual;
                                      salvaArquivo();
                                      // leTeste();
                                    });
                                  },
                                  child: Text(grupos[5],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: corTxBtTurnoC,
                                        fontSize: tamanhoFonteDataL,
                                        decoration: (grupoAtual == grupo["f"])
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      )),
                                ),
                              ),
                            )
                          ],
                        )),
                    Divider(
                      color: Colors.blue,
                      thickness: 3,
                    ),
                    //Horários dos grupos
                    Container(
                        width: largura * larguraInterna,
                        child: Row(
                            //letras das tabelas de turno
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Horário primeiro grupo
                              Visibility(
                                visible:true,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gA",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gA],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              ),
                              // Horário segundo grupo
                              Visibility(
                                visible: true,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gB",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gB],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              ),
                              // Horário terceiro grupo
                              Visibility(
                                visible: (numeroDeGrupos>=3)?true:false,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gC",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gC],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              ),
                              // Horário quarto grupo
                              Visibility(
                                visible: (numeroDeGrupos>=4)?true:false,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gD",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gD],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              ),
                              // Horário quinto grupo
                              Visibility(
                                visible: (numeroDeGrupos>=5)?true:false,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gE],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              ),
                              // Horário sexto grupo
                              Visibility(
                                visible: (numeroDeGrupos==6)?true:false,
                                child: Container(
                                  width: largura * larguraInterna * tmBt,
                                  child: Text("$gE",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: coresHorarios[gE],
                                          fontSize: tamanhoFonteDataL)),
                                ),
                              )
                            ])),
                  ],
                ),
              ),
            ),
          ),
        ),
          // Botão de teste em baixo do card
          Visibility(visible: false,
            child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
            child: Row(
              children: [
                ElevatedButton(onPressed: (){
                  bancoDeDados.doc("documento").set({'dado':'Valor Mudado'});
                },
                    child: Text(
                        "Muda Valor",
                        style: TextStyle(fontSize: 16))),
                Text(
                    meuTexto,
                    style: TextStyle(fontSize: 16)),
              ],
            ),
        ),
          ),
      ],
    ));
  }

  void atualiza() {
    diaAtual = dataAtual.day;
    mesAtual = dataAtual.month;
    anoAtual = dataAtual.year;
    gA = tabela[indiceGr('a')];
    gB = tabela[indiceGr('b')];
    gC = tabela[indiceGr('c')];
    gD = tabela[indiceGr('d')];
    gE = tabela[indiceGr('e')];
  }

  Future<DateTime> buildShowDatePicker(BuildContext context) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2300));
  }
}
