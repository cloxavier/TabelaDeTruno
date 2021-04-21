import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dados.dart';

//Rotinas de salvamento de dados de preferências.
Future<File> getCaminhoArquivo({String arquivo}) async {
  /*import 'dart:io' as io;
// for a file
  io.File(path).exists();
// for a directory
  io.Directory(path).exists();*/
  String arq = arquivo??"preferencias";
  final directory = await getApplicationDocumentsDirectory();

  //mod a apagar
  final dir = directory.path.toString();
  if ( await File("${directory.path}/$arq.json").exists()){
    print("existe o arquivo!");
  }
  return File("${directory.path}/$arq.json" );
}

Future<File> salvaArquivo({String arquivo,List<dynamic> dados}) async {
  // Se eu não passar o nome do arquivo usa o preferencias
  String arq = arquivo??"preferencias";
  // Se eu não passar o que quero salvar, salva as preferências
  List<dynamic> dadosASalvar= dados??preferencias;
  String data = json.encode(dadosASalvar);
  final file = await getCaminhoArquivo(arquivo: arq);
  return file.writeAsString(data);
}

Future<String> leArquivo({String arquivo}) async {
  String arq = arquivo??"preferencias";
  try {
    final file = await getCaminhoArquivo(arquivo: arq);
    return file.readAsString();
  } catch (e) {
    print('Não leu a preferencia!!!!!!!!!!!!!!');
    return null;
  }
}

void defineGrupoFavorito(String letra){
  grupoAtual = grupo[letra];
  preferencias[0]["turnoFavorito"] = grupoAtual;
  salvaArquivo();
}

//Retorna a diferença em dias do inicio até a data dt
int ps(DateTime dt){
  return  dt.difference(DateTime(1,1,1)).inDays;
}

//ToDo
/////  JUNTAR AS DUAS FUNÇÕES ABAIXO EM UMA SÓ COM PARAMETROS
///// OPICIONAIS

//Retorna a posição do grupo da data atual
int indiceGr(String grp){
  int qdias =ps(DateTime(anoAtual,mesAtual,diaAtual))+ grupo[grp];
  return qdias%tamanhoDaSequencia;
}

//Retorna a posição do grupo em data específica
int indiceDtGr(DateTime dt, String grp){
  int qdias =ps(dt)+ grupo[grp];
  return qdias%tamanhoDaSequencia;
}

/* ************************************************************** *
   MONTA O CARD DO DIA PARA AS TELAS
* ************************************************************** */
Widget cardDia(int indice, String dm, String ds, Color corDaBarra,
    {int mes, int an, bool full=false, String tipo=""}) {
  /*  VARIAVEIS LOCAIS*/
  bool dsv=false;
  //diaMesVisivel=false;
  bool dmv = false;
  //horarioCentro = true;
  bool hc = true;
  //barraComTabelaVisivel = false;
  bool bctv = false;
  //barraVisivel = false;
  bool bv = false;

  //Usado para mudar a cor dos horários de acordo com a tabela pré definida
  Color cor = coresHorarios[tabela[indice]];

  //Muda a cor do dia da semana de acordo com a tabela pré definida
  Color fs = corFs[ds];

  //gera um valor para a margem baseado na largura de tela = 0.1% da tela
  double mrg = largura*0.001;

  //double larTxt = ((largura / divisoes) - mrg)*0.4;
  if (tipo=="aa"){
    //diaSemanVisivel=false;
      dsv=false;
    //diaMesVisivel=false;
     dmv = false;
    //horarioCentro = true;
     hc =(barraVisivel)? true:false;
    //barraComTabelaVisivel = false;
     bctv = (barraVisivel)?false:true;
      //barraSimplesVisivel = false;
     bv = false;
  }
  return Container(
      //width: (full!=true)? (largura / divisoes)- mrg : largura/2,
      width: (full!=true)?(tipo=="aa")? (largura *0.72/numeroDeGrupos)- mrg
          :(largura / divisoes)- mrg: largura/2,
      constraints: BoxConstraints(minHeight:(full!=true)?
      (tipo=="aa")?largura / divisoes/2 : largura / divisoes: largura/2 ),

      //Espaçamento interno de cada botão
      padding: EdgeInsets.fromLTRB(2, 2, 4, 0),
      //Decoração do botão
      decoration: BoxDecoration(
        border:(flat)? Border.all(color:Colors.grey):
        Border.all(color:Colors.white54),
       /* boxShadow:(flat)?null:(isTemaDark)?null:[
          BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 10)
        ],*/
          boxShadow:(flat || isTemaDark)?null:[
            BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 10)
          ],
        borderRadius: BorderRadius.all(Radius.circular(10),
        ),
        color:(isTemaDark)? null: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /* DIA DA SEMANA NO TOPO DO BOTÃO*/
          Visibility(
            visible:(tipo=="aa")? dsv : diaSemanVisivel,
            child: Text("$ds",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: fs,
                fontSize:(full!=true)? 15:30,
              ),
            ),
          ),
          //Linha com dia do mes e dia da tabela
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible:(tipo=="aa")?dmv: diaMesVisivel,
                child: Expanded(
                  /* DIA DO MES DO BOTÃO*/
                  child: Text("$dm",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: (corDaBarra == Colors.amber && !barraVisivel)?
                      Colors.amber:
                      (corDaBarra == desabilitado)
                          ?corDaBarra:(isTemaDark)?null:Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:(full!=true)? tamanhoFonteData:40,
                    ),
                  ),
                ),
              ),
              /* HORÁRIO DO CENTRO DO BOTÃO*/
              Visibility(
                visible:(tipo=="aa")?hc: horarioCentro,
                child:  Container(
                  alignment: Alignment.center,
                  //width:larTxt,
                  //color: (corDaBarra==desabilitado)?corDaBarra:cor,

                  child: Text(
                    "${tabela[indice]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: (corDaBarra==desabilitado)?corDaBarra:cor,//Colors.white,
                        decoration:(tipo=="aa")?TextDecoration.none
                            :TextDecoration.underline,
                        fontSize: tamanhoFonteDataR,
                        fontWeight: (tabela[indice] == "F")
                            ? FontWeight.bold
                            : FontWeight.normal),

                  ),
                ),
              ),
            ],
          ),
          /*BARRA COM HORÁRIO NO FUNDO DO BOTÃO*/
          Visibility(
            visible: (tipo=="aa")?bctv:barraComTabelaVisivel,
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              width: double.maxFinite,
              color:(isTemaDark)? cor.withOpacity(0.4) :  cor ,
              child: Text("${tabela[indice]}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize:(full!=true)? 15:35,
                    fontWeight: (tabela[indice]=="F")?
                    FontWeight.bold:FontWeight.normal
                ),
              ),
            ),
          ),
          //Fim
          /* BARRA DO FUNDO DO BOTÃO */
          Visibility(
            visible:(tipo=="aa")? bv: barraVisivel,
            child: Divider(
              color: corDaBarra,
              thickness:(full!=true)? 3:10,
            ),
          )
        ],
      ));
}

/* ****************************************************
    CRIA O TITULO DO MES NA VISÃO ANUAL E VISTA GERAL
   ************************************************** */
Widget mes(int mes){
  return Container(
    margin: EdgeInsets.only(top:6,bottom: 4,left: 2,right: 2),
    padding: EdgeInsets.all(3),
    width: double.infinity,
    decoration: BoxDecoration(
        color: (isTemaDark)?Colors.black:ThemeData().primaryColor,//corFundoMes,
        border: Border.all(
            color: corBordaMes,
            width: 2
        ),
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Text("${meses[mes]}",
        textAlign: TextAlign.center,
        style:TextStyle(
          color: corTextoMes,
          fontSize: 25,
        )),
  );
}

/* *********************************************************** *
    CRIA O CORPO DAS TABELAS MENSAL E ANUAL E VISTA GERAL
 * *********************************************************** */
 corpoTabela(String tipo) {
  //divisoes=(tipo=="m")?7:5;
  divisoes =7;
  /* O tipo se refere a quantidade de dias e ao cabeçalhos
  * deve ser passado tipo "a" para ano, "m" para mes*/

  //Variáveis locais
  int dias=42;
  int deslocSegunda=0;
  int qdiasB;
  int indiceB ;
  int qdiasC;
  int indiceC;
  int qdiasD;
  int indiceD;
  int qdiasE;
  int indiceE;
  int qdiasF;
  int indiceF;
  int diaAux=1;

  //Atribui o numero de dias do ano de acordo com ano bissexto ou não
  if (tipo == "a" ){      dias = (anoAtual%4 == 0) ? 366 : 365;}
  else if (tipo == "aa"){ dias=378; }
  else if (tipo == "m"){ dias=42; }

  //Cria uma lista de Widgets que vai ser preenchida nesta rotina
  List<Widget> diasCard = [];
  List<Widget> diasCardAux = [];

  //Para visão anual paga a data do primeiro dia do ano
  var dS =(tipo == "a" || tipo=="aa")
      ? new DateTime(anoAtual, 1, 1)
      :new DateTime(anoAtual, mesAtual, 1);

  //Usa uma variável auxiliar para receber a auteração da data
  var aux = dS;

  /* Aqui vou garantir que seja sempre segunda feira
  * deslocando a data para uma segunda feira*/
  if (tipo=="m" || tipo=="aa"){
    deslocSegunda = dS.weekday-1;
    aux=dS.subtract(new Duration(seconds: 60 * 60 * 24 * deslocSegunda));
    dS=aux;
  }
  /*  fim do calculo mensal*/

  //Calcula o numero de dias para geração da tabela(Aqui tem uma diferença no mês)
  int qdias =(tipo=="aa")?ps(dS)+ grupo["a"]:ps(dS)+ grupoAtual;
  int indice =qdias%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
  if (tipo=="aa"){
     qdiasB=ps(dS)+ grupo["b"];
     indiceB =qdiasB%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
     qdiasC=ps(dS)+ grupo["c"];
     indiceC =qdiasC%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
     qdiasD=ps(dS)+ grupo["d"];
     indiceD =qdiasD%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
     qdiasE=ps(dS)+ grupo["e"];
     indiceE =qdiasE%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
     qdiasF=ps(dS)+ grupo["f"];
     indiceF =qdiasF%tamanhoDaSequencia;//ps(aux)%tamanhoDaSequencia;
  }
  int _esteMes = aux.month;
  Color corDaBarra;

  //Adiciona um mês ao CABEÇALHO dos meses.
  if (tipo=="a" || tipo=="aa"){diasCard.add(mes(aux.month-1));}

  //Começa a adicionar dias
  for (int dia = 1; dia <= dias; dia++) {
    //Faz a verificação do mes atual e coloca o titulo do mes no topo
    // para aquele mes na visão anual e anual geral.
    if (_esteMes != aux.month && (tipo=="a" || tipo=="aa")){
      //Se o mes muda adiciona um titulo
      if(tipo=="a" ){
      /* ********************************************************
        Adiciona o final do mes e reinicia o outro na visão anual
        ******************************************************** */
        diasCard.add(Row(children: diasCardAux,));
        diasCardAux=[];
        diaAux=1;
        /* ***************************************************** */
        }
        diasCard.add(mes(aux.month-1));
        _esteMes=aux.month;
        // Fim
    }
    // Confere se o dia, mes e ano são os mesmos da data atual
    // e muda a cor da barra para destacar
    corDaBarra = (
        diaHoje == aux.day &&
            mesHoje == aux.month &&
            anoHoje == aux.year )? corBarraBtTurnoC : corBarraBtTurnoE;
    if (tipo=="m" && (mesAtual != aux.month)){corDaBarra = desabilitado;}

    //Adiciona card com a data atual.
    if (tipo=="aa") {
      /* ************************************************* *
      * Monta o card visão anual geral
      * ************************************************** */
      diasCard.add( Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
              //width: largura/divisoes-largura*0.001,
              width: largura*0.15,//-largura*0.001
              alignment: Alignment.center,
              child: Text("${aux.day}-${mesesAbrev[aux.month-1]}",
                //   child: Text("${aux.day}/${aux.month}",
                style: TextStyle(
                    color: corDaBarra,
                ),
              )),
          Container(
              //width: largura/divisoes-largura*0.001,
              width: largura*0.13,//-largura*0.001
              alignment: Alignment.center,
              child: Text(diaSemana[aux.weekday - 1],
                style: TextStyle(
                  color: corFs[diaSemana[aux.weekday - 1]],
                ),)),
          cardDia(indice, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo),
          cardDia(indiceB, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo),
          if(numeroDeGrupos>=3) cardDia(indiceC, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo),
          if(numeroDeGrupos>=4)cardDia(indiceD, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo),
          if(numeroDeGrupos>=5)cardDia(indiceE, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo),
          if(numeroDeGrupos==6)cardDia(indiceF, aux.day.toString(),
              diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo)
        ],)
      );

    }else if (tipo=="a" ){
      /* ************************************************* *
      * Monta o card visão anual na forma de lista
      * ************************************************** */
      diasCardAux.add(cardDia(indice, aux.day.toString(),
          diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo));
      /* *************************************************************
          Verifica se a linha já possui o numero de colunas definido
      *  em divisoes, se i mes mudou o se a montagem do ano está no
      *  último dia e adiciona uma nova linha a tabela.
      * ************************************************************ */
      if(diaAux%divisoes==0  || _esteMes!=aux.month || dia==dias){
        diasCard.add(Row(children: diasCardAux,));
        diasCardAux = [];
        diaAux=0;
      }
      diaAux++;
    }
    else{
      diasCard.add(cardDia(indice, aux.day.toString(),
          diaSemana[aux.weekday - 1], corDaBarra,tipo: tipo));
    }
    /*Controla o indice da tabela dentro dos dias da sequencia
      ex.: se o tamanhoDaSequencia for de 35 dias o indice será
      controlado entre (0 a 35-1)*/
    indice = (indice < tamanhoDaSequencia-1) ? indice += 1 : 0;
    /* ***************************************************** *
      * Controla os indices da tabela na visão anual geral
      * *************************************************** */
    if (tipo=="aa"){
      indiceB =(indiceB < tamanhoDaSequencia-1) ? indiceB += 1 : 0;
      if(numeroDeGrupos>=3) indiceC =(indiceC < tamanhoDaSequencia-1)
          ? indiceC += 1 : 0;
      if(numeroDeGrupos>=4) indiceD =(indiceD < tamanhoDaSequencia-1)
          ? indiceD += 1 : 0;
      if(numeroDeGrupos>=5) indiceE =(indiceE < tamanhoDaSequencia-1)
          ? indiceE += 1 : 0;
      if(numeroDeGrupos>=6)indiceE =(indiceF < tamanhoDaSequencia-1)
          ? indiceF += 1 : 0;
    }
    //Adiciona um dia a data que irá ser utilizada para criar o card
    aux = dS.add(new Duration(seconds: 60 * 60 * 24 * dia));
  }
  return (tipo=="aa"|| tipo=="a")?diasCard : Wrap(children: diasCard);
}

/* ************************************************************
*   MONTA O CARD DA VISÃO SEMANAL
*   Foi mantida separada por causa de peculiaridade e para
*   manter o código mais simples de realizar manutenção
* ********************************************************** */
Widget cardSemana(int indice, String dm, String ds, Color corDaBarra,
    [int mes, int ano,bool full]) {
  //Usado para mudar a cor dos horários de acordo com a tabela pré definida
  Color cor = coresHorarios[tabela[indice]];
  //Muda a cor do dia da semana de acordo com a tabela pré definida
  Color fs =corFs[ds];
  //gera um valor para a margem baseado na largura de tela = 0.1% da tela
  double mrg = largura * 0.001;
  double larTxt = ((largura / divisoes) - mrg)*0.38;
  return Container(
      //Altura e largura do botão
      width: largura/divisoes-mrg,
      height: largura/divisoes,

      //Espaçamento interno de cada botão
      padding: EdgeInsets.fromLTRB(2, 2, 4, 0),

      //Decoração do botão
      decoration: BoxDecoration(
        border: Border.all(color:Colors.white54),
        boxShadow:isTemaDark?null: [
          BoxShadow(color: Colors.grey, offset: Offset(1, 1), blurRadius: 10)
        ],
        borderRadius: BorderRadius.all( Radius.circular(10),
        ),
       color:(isTemaDark)? null: Colors.white,////////////////////////////
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Texto dia da semana
          Text(
            "$ds",
            textAlign: TextAlign.center,
            style: TextStyle(color: fs, fontSize: 20),
          ),
          //Linha com dia do mes e dia da tabela
          Row(
            children: [
              Expanded(
                //dia do mes
                child: Text(
                  "$dm",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                   /* color: Colors.black,*/
                    fontWeight: FontWeight.bold,
                    fontSize: tamanhoFonteData * 2.0,
                  ),
                ),
              ),
              //horario na tabela
              Container(
                width:larTxt,
                color: cor,
                child: Text(
                  "${tabela[indice]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      ////////////////////////////////////////////////////////
                      fontSize: tamanhoFonteDataL,
                      fontWeight: (tabela[indice] == "F")
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            ],
          ),
          // TEXT DO MES E ANO NO FUNDO
          Text(
            "${mesesAbrev[mes - 1]}/$ano",
            style: TextStyle(
                color:(isTemaDark)?null: cor,
                fontSize: tamanhoFonteDataP,
                fontWeight: (tabela[indice] == "F")
                    ? FontWeight.bold
                    : FontWeight.normal),
          ),
          //Barra de fundo do botão
          Divider(
            color: corDaBarra,
            thickness:4,
          )
        ],
      ));
}

Widget semanaWrap() {
  //Variáveis locais
  divisoes =3;
  List<Widget> diasCard = [];

  //Para visão anual paga a data do primeiro dia do ano
  var dS = dataHoje.subtract(Duration(days: (dataHoje.weekday - 1) + semanas));

  //Usa uma variável auxiliar para receber a alteração da data
  var aux = dS;

  int qdias = ps(dS) + grupoAtual;
  int indice = qdias % 35; //ps(aux)%35;
  Color corDaBarra;

  //Começa a adicionar dias
  for (int dia = 1; dia <= 7; dia++) {
    //Faz a verificação do mes atual

    // Confere se o dia o ano e o mes são os mesmo e muda a cor da barra
    corDaBarra =
    (diaHoje == aux.day && mesHoje == aux.month && anoHoje == aux.year)
        ? corBarraBtTurnoC
        : corBarraBtTurnoE;
    //Adiciona um dia ao mes

    diasCard.add(cardSemana(indice, aux.day.toString(),
        diaSemana[aux.weekday - 1], corDaBarra, aux.month, aux.year));

    indice = (indice < tamanhoDaSequencia-1) ? indice += 1 : 0;
    aux = dS.add(new Duration(seconds: 60 * 60 * 24 * dia));
  }

  return Wrap(children: diasCard);
}

Future<String> pegaFeriados()async{
String Url = "https://calendarific.com/api/v2/holidays?&api_key=255832cbf0b82f3317f68d348e7e74d39027a56e&country=BR";
String ano = "2021";
String tipo = "national";
print("Url: ${Url}&year=$ano&type=$tipo");
print("Linha completa: https://calendarific.com/api/v2/holidays?&api_key=255832cbf0b82f3317f68d348e7e74d39027a56e&country=BR&year=2021&type=national");
  http.Response response = await http.get("${Url}&year=$ano&type=$tipo");
//feriados = jsonDecode(response.body.replaceAll('\\', ""));
feriados = jsonDecode(response.body);
 listaFeriados = feriados['response']['holidays'];
  print("=====================================================================");
print(feriados);
print("=====================================================================");
print (listaFeriados);
salvaArquivo(arquivo: 'feriados$anoAtual',dados: listaFeriados);
  print("=====================================================================");
return "";
}

String dataIsoParaLocal(String data){
  List<String> dataLocal =data.split('-');
  return "$dataLocal[2]/$dataLocal[1]/$dataLocal[0]";
}
