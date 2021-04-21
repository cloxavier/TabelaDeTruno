import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tabela_de_turno/dados.dart';
import 'package:tabela_de_turno/rotinas.dart';
import 'package:tabela_de_turno/tabela.dart';
import 'package:tabela_de_turno/temas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Inicializa o App no firebase
  await Firebase.initializeApp();
  //Anima mudanças de estado no App ex.: Tema escuro/claro
  //junto com classe em temas.
  runApp(AnimatedBuilder(
    animation: AppController.instance,
    builder: (context, child){
      return MaterialApp(
        //Controla o tema do aplicativo
        theme: ThemeData(brightness: AppController.instance.temaDark
              ? Brightness.dark
                :Brightness.light
        ),

        home: Home(),
      );
    },

  ));
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown

    ]);
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(context,MaterialPageRoute(
          builder: (BuildContext context) =>Tabela()));
      anoAtual =DateTime.now().year;
      mesAtual = DateTime.now().month;
      diaAtual = DateTime.now().day;
      densidadeH =MediaQuery.of(context).size.width/320;
     // menorTamanho =MediaQuery.of(context).size.shortestSide;
    });

    // Teste definições
    leArquivo().then((value) {
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
          paginaInicial = (preferencias[0]["pgInicial"]!=null)
              ?preferencias[0]["pgInicial"]
              :paginaInicial;
          paginaAtual = paginaInicial;


        AppController.instance.changeTheme(escuro: isTemaDark);
      });
    }).catchError((e) {
    });
    //
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient:LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  //Cores da Splash screen
                  Colors.orange[100],
                 Colors.orange[500],
                  Colors.orange[100],
                 // Colors.purple
                ]
            )
        ),
        child: Stack(
          children:[
            Center(
              child: Image.asset("assets/images/tabela-de-turno-azul_tranparente.png",
          width: 200,
          height: 200 ,
          ),
            ),
          Positioned(
              bottom: 20,
              right: 20,
              child: Text("por Claudio Xavier",
              style: TextStyle(
                color: Colors.blue[900]
              ),))],
        ),
      ),
    );
  }
}

