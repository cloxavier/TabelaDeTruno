import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//IMPORTE DAS PÁGINAS DE INTERFACES, DADOS E REGRAS DE NEGOCIOS.
import 'config.dart'; //PÁGINA DE CONFIGURAÇÕES
import 'vistaGeral.dart';    // INTERFACE VISÃO ANUAL GERAL
import 'dados.dart';          // PÁGINA DE DADOS
import 'visaoAnual.dart';     // INTERFACE VISÃO ANUAL
import 'visaoDiaria.dart';    // INTERFACE VISÃO DÁRIA
import 'visaoMensal.dart';    // INTERFACE VISÃO MENSAL
import 'visaoSemanal.dart';   // INTERFACE VISÃO SEMANAL

final controlador = PageController();
class Tabela extends StatefulWidget {
  @override
  _TabelaState createState() => _TabelaState();
}

class _TabelaState extends State<Tabela>  {
  @override
  Widget build(BuildContext context)  {

    bancoDeDados = FirebaseFirestore.instance.collection('colecao');
    bancoDeDados.snapshots().listen((event){
      event.docs.forEach((element) {
       // print(element.data()['dado']);
        setState(() {
          meuTexto = element.data()['dado'];
        });
      });
    });


    altura = MediaQuery.of(context).size.height;
    largura = MediaQuery.of(context).size.width;


    final controlador = PageController(initialPage: paginaInicial);

    // LISTA DE PÁGINAS
    var _paginas = [
      VisaoDiaria(),
      VisaoSemanal(),
      VisaoMensal(),
      VisaoAnual(),
      VistaGeral()
    ];
    //Define estados das barras das paginas

    /*CONTÉM AS DEFINIÇÕES ORIENTAÇÃO DAS PÁGINAS E VISIBILIDADE DA
    * BARRAS DE TURNOS, MES E ANO CHAMA O atualizaPagina para tanto*/
    final paginas = PageView(
      controller: controlador,
      children: _paginas,
      onPageChanged: (pagina) {
        setState(() {
          paginaAtual = pagina;
          atualizaPagina(paginaAtual);
          //sTorna visivel ou não a barra de botões de acordo com a pagina
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
        });
      },
    );
    //
    atualizaPagina(paginaAtual);

    //PAGINA PRINCIPAL
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              Container(
                  child:
                  (largura > 350) ? Text("Tabela de Turno") : Text("Tabela")),
              Spacer(),
              //barraAno
              Visibility(
                visible: controleAno,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                        ),
                        onPressed: () {
                          setState(() {
                            anoAtual--;
                          });
                        }),
                   Text("$anoAtual",
                     /*style: TextStyle(color: Colors.white),*/),
                    IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            anoAtual++;
                          });
                        }),
                  ],
                ),
              ),
            ],
          )),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.orange[800], Colors.orangeAccent])),
                child: Container(
                    child: Column(
                      children: [
                        Material(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: BorderRadius.all(Radius.circular(50.01)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/tabela-de-turno-azul.png",
                                width: 80,
                                height: 80,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Tabela de Turno",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ))),
            ItemMenu(Icons.apps, "Interface", () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext cotext) => Interface()));
            }),
            ItemMenu(Icons.supervised_user_circle_outlined, "Unidade / Grupos",
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext cotext) => UnidadesGrupos()));
                }),
            // ItemDeMenu(Icons.apps, "Visão Anual", ()=>{}),
            ItemMenu(
                Icons.settings,
                "Configurações",
                    () => {
                  Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext cotext) =>
                              Configuracoes())),
                }),
          ],
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        divisoes = (orientation == Orientation.portrait) ? 5 : 7;
        tamanhoFonteData = (orientation == Orientation.portrait)
            ? tamanhoFonteDataP
            : tamanhoFonteDataL;
        orientacao = orientation; //ANALISAR A UTILIDADE POSTERIORMENTE
        //Método extraído
        return corpoPagina(controlador, paginas);
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    //
    /*lePreferencia().then((value) {
      final dt = jsonDecode(value);
      preferencias = dt;
      //LÊ E DEFINE AS PREFERÊNCIAS
      setState(() {
        grupoAtual = (preferencias[0]["turnoFavorito"] != null)
            ? preferencias[0]["turnoFavorito"]
            : grupo["a"];
        barraVisivel = (preferencias[0]["interface"] != null)
            ? preferencias[0]["interface"]
            : true;
        isTemaDark = (preferencias[0]["temaEscuro"] != null)
            ? preferencias[0]["temaEscuro"]
            : isTemaDark;
        flat = (preferencias[0]["botaoFlat"] != null)
            ? preferencias[0]["botaoFlat"]
            : flat;
        paginaInicial = (preferencias[0]["pgInicial"] != null)
            ? preferencias[0]["pgInicial"]
            :4;
          print("Apagina inicial é: $paginaInicial");
        AppController.instance.changeTheme(escuro: isTemaDark);
      });
    }).catchError((e) {

    });*/
  }

  /* *****************************************************************
  * Monta a barra de opções de turno, ano e mes das páginas e obtem
  * o corpo da tabela de acordo com a aba.
  * *************************************************************** */
  Container corpoPagina(PageController controlador, PageView paginas) {
    double tamBt =(controleMes)?75/numeroDeGrupos:100/numeroDeGrupos; //Define o percentual do botao visão ano
    double margem = 0.005;
    double tamanhoDaFonte = tamanhoFonteDataP;
    Color corTexto = corTxVistaGeral;
    /* tira 28% da largura e divide entre os botões visiveis na
    * aba vista geral                                           */
    double tmbt = (largura*0.72)/numeroDeGrupos-margem;

    return Container(
      width: double.infinity,
      height: double.infinity,
      //color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          //Aba de grupos
          //barraTurnos,
          Container(
            //duration: Duration(seconds: 1),
            //height: altura*0.095,
            child: Column(
              /* ****************************************
                Controles de semana, mes e ano
                Realizada redução de código repetido
              * *************************************** */
              children: [
                /*Visibility(
                  visible: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        btContainer("a", tamBt),
                        btContainer("b", tamBt),
                        btContainer("c", tamBt),
                        btContainer("d", tamBt),
                        btContainer("e", tamBt),
                      ],
                    ),
                  ),
                ),*/
                Visibility(
                  visible: (controleMes || botoesVisiveis),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      height: largura / divisoes - margem * largura * 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //Botões
                          Container(
                            child: Expanded(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  btContainer("a", tamBt),
                                  btContainer("b", tamBt),
                                  Visibility(
                                      visible: (numeroDeGrupos>=3)?true:false,
                                      child: btContainer("c", tamBt)),
                                  Visibility(
                                      visible: (numeroDeGrupos>=4)?true:false,
                                      child: btContainer("d", tamBt)),
                                  Visibility(
                                      visible: (numeroDeGrupos>=5)?true:false,
                                      child: btContainer("e", tamBt)),
                                  Visibility(
                                      visible: (numeroDeGrupos==6)?true:false,
                                      child: btContainer("f", tamBt))
                                ],
                              ),
                            ),
                          ),
                          //Dropdown
                          Visibility(visible: controleMes?true:false,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: largura * margem),
                              width: largura * 0.25,
                              alignment: Alignment.center,
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 20,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 19,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.blueAccent,
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                    mesAtual = mesesAbrev.indexOf(newValue) + 1;
                                  });
                                },
                                items: mesesAbrev.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                /* ***************************** *
                *  Vista Geral                   *
                * ****************************** */
                Visibility(
                  visible: visaoGeral,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors:(isTemaDark)?[Colors.black54, Colors.white10]:
                            [Colors.indigo[900], Colors.blue[300]]

                        )),
                    height: altura * 0.06,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          //color: Colors.blueAccent,
                          width: largura *0.15,

                          child: Text(
                            "Dia",
                            style: TextStyle(
                                fontSize: tamanhoDaFonte, color: corTexto),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //color: Colors.blueAccent,
                          alignment: Alignment.center,
                          width: largura * 0.13,
                          child: Text(
                            "DS",
                            style: TextStyle(
                                fontSize: tamanhoDaFonte, color: corTexto),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          //color: Colors.blueAccent,
                          width: tmbt,
                          child: Text(
                            grupos[0],
                            style: TextStyle(
                                fontSize: tamanhoDaFonte, color: corTexto),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        //Visibilidade da letra do segundo grupo
                        // (controle de visibilidade desnecessário)
                        Visibility(visible: (numeroDeGrupos>=2)?true:false,
                          child: Container(
                            width: tmbt,
                            child: Text(
                              grupos[1],
                              style: TextStyle(
                                  fontSize: tamanhoDaFonte, color: corTexto),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //Visibilidade da letra do terceiro grupo
                        Visibility(visible: (numeroDeGrupos>=3)?true:false,
                          child: Container(
                            // color: Colors.blueAccent,
                            width: tmbt,
                            child: Text(
                              grupos[2],
                              style: TextStyle(
                                  fontSize: tamanhoDaFonte, color: corTexto),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //Visibilidade da letra do quarto grupo
                        Visibility(visible: (numeroDeGrupos>=4)?true:false,
                          child: Container(
                            // color: Colors.blueAccent,
                            width: tmbt,
                            child: Text(
                              grupos[3],
                              style: TextStyle(
                                  fontSize: tamanhoDaFonte, color: corTexto),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //Visibilidade da letra do quinto grupo
                        Visibility(visible: (numeroDeGrupos>=5)?true:false,
                          child: Container(
                            //color: Colors.blueAccent,
                            width: tmbt,
                            child: Text(
                             grupos[4],
                              style: TextStyle(
                                  fontSize: tamanhoDaFonte, color: corTexto),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        //Visibilidade da letra do sexto grupo
                        Visibility(
                          visible: (numeroDeGrupos==6)?true:false,
                          child: Container(
                            //color: Colors.blueAccent,
                            width: tmbt,
                            child: Text(
                              grupos[5],
                              style: TextStyle(
                                  fontSize: tamanhoDaFonte, color: corTexto),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /* ***********************************
          * Página
          * ********************************* */
          Container(
            child: Expanded(
              child: PageView(
                controller: controlador,
                children: [paginas],
              ),
            ),
          ),
        ],
      ),
    );
  }

/* ****************************************************************
* Cria os botoes de turno
* ************************************************************** */
  Container btContainer(String letra, double perc, [int flexS]) {
    String letraMaisucula = letra.toUpperCase();
    return Container(
        width: (perc != 0) ? largura * perc / 100 - mrgn : null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: (grupoAtual == grupo[letra])
                  ? corBrdBtTurnoC
                  : corBrdBtTurnoE,
              width: 3),
          // color: (grupoAtual == grupo[letra]) ? corFdBtTurnoSl : corFdBtTurno,
        ),
        child: TextButton(
          child: Text(
            letraMaisucula,
            style: TextStyle(
                fontSize: 18,
                color: (grupoAtual == grupo[letra])
                    ? corTxBtTurnoC
                    : corTxBtTurnoE),
          ),
          onPressed: () {
            setState(() {
              grupoAtual = grupo[letra];
            });
          },
        ));
  }
}

/*
  CRIA OS BOTÕES DO MENU DRAWER
 */
// ignore: must_be_immutable
class ItemMenu extends StatefulWidget {
  IconData icone;
  String texto;
  Function onTap;

  ItemMenu(this.icone, this.texto, this.onTap);

  @override
  _ItemMenuState createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: InkWell(
          splashColor: Colors.orangeAccent.shade400,
          onTap: widget.onTap,
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.icone,
                      size: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.texto,
                        style: TextStyle(fontSize: 16,/* color: Colors.black*/),
                      ),
                    )
                  ],
                ),
                Icon(Icons.arrow_right)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ********************************************************
* ATUALIZA A VISIBILIDADE DA BARRA DE BOTÕES DE TURNO E A
* ORINTAÇÃO DAS PÁGINAS DE ACORDO COM A SELEÇÃO
* ****************************************************** */
void atualizaPagina(pagina) {
  switch (pagina) {
    case 0:
      {
        botoesVisiveis = false;
        controleAno = false;
        controleMes = false;
        visaoGeral = false;
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
      break;
    case 1:
      {
        botoesVisiveis = true;
        controleAno = false;
        controleMes = false;
        visaoGeral = false;
        //hgt =0;
        //
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

        //
      }
      break;
    case 2:
      {
        botoesVisiveis = false;
        controleAno = true;
        controleMes = true;
        visaoGeral = false;
        // hgt = altura * 0.15;
      }
      break;
    case 4:
      {
        botoesVisiveis = false;
        controleAno = true;
        controleMes = false;
        visaoGeral = true;
      }
      break;
    default:
      {
        botoesVisiveis = true;
        controleAno = true;
        controleMes = false;
        visaoGeral = false;
        //hgt = altura * 0.3;
      }
      break;
  }
}
