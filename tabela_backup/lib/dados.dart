import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'rotinas.dart';

/* Diferença para ajuste da tabela*/
const dif =7;
/* Margem para uso em alguns pontos*/
double mrgn =2;

/* Definem a largura e a altura da tela do aparelho
* usados para dimensionar Widgets*/
const defDensH= 215;
double largura ;
double altura;
double densidadeH=1;
//double menorTamanho=300;

// PADRONIZAÇÃO DO TAMANHO DA FONTES
double tamanhoFonteData=tamanhoFonteDataP;
double tamanhoFonteDataR = 13.0 * densidadeH;
double tamanhoFonteDataP = 15.0 * densidadeH;
double tamanhoFonteDataL = 20.0 * densidadeH;

//USO FUTURO - ANIMAÇÃO DO TAMANHO DAS FONTES
/*double hgt = altura*0.95;*/

/* Define o numero de botões de dia na horizontal*/
int divisoes =7;

/* Define o ano/mes/dia em que a tabela será montada, este valor
* é alterado dinamicamente no inicio do app e na barra
* de titulos*/
DateTime dataAtual = DateTime(anoAtual,mesAtual,diaAtual);
int anoAtual = 2021; // Altera o ano no interior dos botões
int mesAtual=1;   //
int diaAtual;     //
int paginaInicial=0;
int paginaAtual =0;

/*Define qual o grupo será mostrado automáticamente
* é usado também para mudar o grupo atual.
* ALGUMAS COISAS PODEM SAIR */
int grupoAtual= grupo["e"];
/*int ndias = ps(DateTime(anoAtual,1,1));
int ciclos = (ndias/35).ceil() ;
int diaDoCiclo = (ndias+dif)%35;*/

// DEFINE DIA, MES, ANO E DATA ATUAL
DateTime dataHoje = DateTime.now();
int diaHoje = dataHoje.day;
int mesHoje = dataHoje.month;
int anoHoje = dataHoje.year;

int diasSemanaAtual=dataHoje.difference(DateTime(anoAtual,mesAtual,1)).inDays;
int semanas = 0;

// CORES DOS BOTÕES DA BARRA DE TURNOS
//Color corFdBtTurno =ThemeData().primaryColor;//Colors.white;
//Color corFdBtTurnoSl = ThemeData().backgroundColor   ;//(isTemaDark)?Colors.white:Colors.blueAccent;

// COR DOS TEXTOS DOS BOTÕES DE TURNO
Color corTxBtTurnoE =  ThemeData().primaryColor; //Colors.blueAccent;
Color corTxBtTurnoC = Colors.amber;
Color corTxVistaGeral = Colors.white;

// DEFINE A COR DAS BORDAS DOS BOTÕES DE TURNO
Color corBrdBtTurnoE = Colors.blueAccent;
Color corBrdBtTurnoC = Colors.red;

// DEFINE A COR DA BARRA SEM DATA
Color corBarraBtTurnoE = Colors.blueAccent;
Color corBarraBtTurnoC = Colors.amber;

// DEFINE AS CORES DAS BARRA DE MESES
//Color corFundoMes = (isTemaDark)?Colors.black:ThemeData().primaryColor;
Color corTextoMes = Colors.white;
Color corBordaMes = Colors.blue[900];

// COR PARA DESABILITAR CARD DE OUTRO MES
Color desabilitado= Colors.grey;

// DEFINE A ORIENTAÇÃO DO APP
Orientation orientacao; // ANALISAR A UTILIDADE POSTERIORMENTE.

// CONFIG DE INTERFACE //
bool isTemaDark = false;
bool flat = false;  // Utilizado no cardDia para elevar os botões

// DEFINE A VISIBILIDADE DOS BOTÕES -> tabela
bool botoesVisiveis = false;
bool controleAno = false;
bool controleMes = false;
bool visaoGeral = false;

//VARIÁVEIS DE VISIBILIDADE DO BOTÕES CARD -> rotinas
bool diaSemanVisivel= true;
bool diaMesVisivel =true;
bool horarioCentro = barraVisivel;
bool barraComTabelaVisivel = !barraVisivel;
bool barraVisivel = false;

// // // //  TESTE // // // //
String meuTexto = "texto";
CollectionReference bancoDeDados;

// PREFERÊNCIAS SALVAS EM ARQUIVO
int interface =0;
List  preferencias=[
  {"turnoFavorito": grupoAtual,
    "interface" : barraVisivel,
    "pgInicial": paginaInicial,
    "temaEscuro" : isTemaDark,
    "botaoFlat" : flat,
  }
];
/* *********************
* Referente aos grupos
* ******************** */
// VALOR INICAL DO DROPDOWN DA VISÃO MENSAL
String dropdownValue = mesesAbrev[mesAtual-1];

// POSIÇÃO DE CADA GRUPO NA DATA ATUAL
String gA = tabela[indiceGr('a')];
String gB = tabela[indiceGr('b')];
String gC = tabela[indiceGr('c')];
String gD = tabela[indiceGr('d')];
String gE = tabela[indiceGr('e')];
String gF = tabela[indiceGr('f')];


// MAPEIA OS GRUPOS ALINHANDO CONFORME TABELA REAL
Map<String,int> grupo={
  "a": sequencia[0],
  "b": sequencia[3],
  "c": sequencia[2],
  "d": sequencia[4],
  "e": sequencia[1],
  "f": sequencia[5]
};
// DIFERENÇA EM DIAS DA TABELA DOS GRUPOS A/B/C/D/E
List<int> sequencia=[0,7,14,21,28,35];
//int numero de grupos
int numeroDeGrupos =5;

//Cabeçalho dos grupos
List<String> grupos=["A","B","C","D","E","F"];

// MAPA DE CORES DOS HORÁRIOS DA TABELA
Map<String,Color> coresHorarios={
  "F": Colors.blue ,
  "7": Colors.green,
  "15": Colors.orange,
  "23":(isTemaDark)?Colors.lightBlue : Colors.red
  };
// MAPA DE CORES PARA OS DIAS DA SEMANA
Map<String,Color> corFs={
  "Seg":Colors.blue,
  "Ter":Colors.blue,
  "Qua":Colors.blue,
  "Qui":Colors.blue,
  "Sex":Colors.blue,
  "Sab":Colors.red,
  "Dom":Colors.red
};
// LISTA LITERAL DIAS DA SEMANA ABREVIADO
List<String>diaSemana=[
  "Seg",
  "Ter",
  "Qua",
  "Qui",
  "Sex",
  "Sab",
  "Dom"
];
// LISTA LITERAL DIAS DA SEMANA
List<String>diaSemanaComp=[
  "Segunda",
  "Terça",
  "Quarta",
  "Quinta",
  "Sexta",
  "Sabado",
  "Domingo"
];
//REFERENTES A TABELA
int tamanhoDaSequencia=35;
//TABELA PRINCIPAL
List<String> tabela=tabelaPadrao;
List<String> tabelaPadrao = [
  "F","F","F","F",
  "7","7","7",
  "15","15",
  "23","23",
  "F","F","F","F","F",
  "7","7",
  "15","15","15",
  "23","23",
  "F","F","F","F","F",
  "7","7",
  "15","15",
  "23","23","23"
];
// LISTA LITERAL MESES
List<String>meses=[
  "Janeiro",
  "Fevereiro",
  "Março",
  "Abril",
  "Maio",
  "Junho",
  "Julho",
  "Agosto",
  "Setembro",
  "Outubro",
  "Novembro",
  "Dezembro"
];
// LISTA LITERAL MESES ABREVIADOS
List<String>mesesAbrev=[
  "Jan",
  "Fev",
  "Mar",
  "Abr",
  "Mai",
  "jun",
  "Jul",
  "Ago",
  "Set",
  "Out",
  "Nov",
  "Dez"
];

