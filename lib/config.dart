import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tabela_de_turno/temas.dart';
import 'dados.dart';
import 'rotinas.dart';

class Interface extends StatefulWidget {
  @override
  _InterfaceState createState() => _InterfaceState();
}

class _InterfaceState extends State<Interface> {
  @override
  Widget build(BuildContext context) {
    //Cria lista de booleando para toggleButton
    List<bool> selPagInicial = List.generate(5, (_) => false);
    //Defini qual botão vai esta ativo em função da pagina inicial
    selPagInicial[paginaInicial] =true;
    //Capturam a largura e altura da tela do dispositivo
    altura = MediaQuery.of(context).size.height;
    largura = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Interface"),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              //Titulo Interior do Botão
              Container(
                padding: EdgeInsets.only(left: 10,top: 20),
                alignment: Alignment.centerLeft,
                child: Text("Interior do Botão",
                style:(isTemaDark)? Theme.of(context).textTheme.headline6
                  : TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
                ),
              ),
              //Interface
              Container(
                width: largura*0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey)
                ),
                //margin: EdgeInsets.symmetric(vertical: 15,horizontal: 30),
                margin: EdgeInsets.only(top: 10,bottom: 10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Column(
                  children:
                  [
                    Row(
                      children: [ Radio(
                        value: true,
                        groupValue: barraVisivel,
                        onChanged: ( value) {
                          setState(() {
                            barraVisivel =true;
                            horarioCentro = barraVisivel;
                            barraComTabelaVisivel = !barraVisivel;
                            preferencias[0]["interface"] = barraVisivel;
                            salvaArquivo();
                          }); },
                      ),
                        Text("Horário ao lado do dia.")],
                    ),
                    Row(
                      children: [ Radio(
                        value: false,
                        groupValue: barraVisivel,
                        onChanged: ( value) { setState(() {
                          barraVisivel =false;
                          diaMesVisivel =true;
                          horarioCentro = barraVisivel;
                          barraComTabelaVisivel = !barraVisivel;
                          preferencias[0]["interface"] = barraVisivel;
                          salvaArquivo();
                        }); },
                      ),
                        Text("Horário destacado no fundo.")  ],
                    ),
                    Divider(thickness: 2,),
                    Text("Padrão no tema escuro!")  ,
                    Row(
                      children: [ Checkbox(
                        value: flat,
                        onChanged: ( value) { setState(() {
                          flat = !flat;
                          preferencias[0]["botaoFlat"] = flat;
                          salvaArquivo();
                        }); },
                      ),
                        Text("Sem relevo.")  ],
                    ),Divider(thickness: 2,),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: cardDia(1, dataHoje.day.toString(),
                        diaSemana[dataHoje.weekday-1],
                        Colors.amber ,full: true)),
                  ],
                ),
              ),
              //Titulo Display
              Container(
                margin: EdgeInsets.only(left: 10,top: 20),
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text("Telas",
                  style:(isTemaDark)? Theme.of(context).textTheme.headline6
                      : TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              //Corpo display
              Container(
                 width: largura*0.85,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey)
                ),
                 margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Column(
                  children:
                  [
                    Row(
                      children: [ Checkbox(
                        value: isTemaDark,
                        onChanged: ( value) {
                          isTemaDark = !isTemaDark;
                          preferencias[0]["temaEscuro"] = isTemaDark;
                          salvaArquivo();
                          AppController.instance.changeTheme();
                        },
                      ),
                        Text("Tema Escuro")  ],
                    ),
                  Divider(thickness: 2,),
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text("Selecione a página inicial."),),
                    //Botões de seleção da pagina inicial
                    ToggleButtons(
                        children: [
                          Text("D"),
                          Text("S"),
                          Text("M"),
                          Text("A"),
                          Text("G"),
                        ],
                        isSelected:selPagInicial,
                      onPressed: (indice){
                          setState(() {
                            paginaInicial=indice;
                            for(int i=0; i<5;i++ ) if(i==indice)
                              selPagInicial[i] =true; else
                              selPagInicial[i] =false;
                          });
                          preferencias[0]["pgInicial"]=indice;
                          salvaArquivo();
                      },
                     //Controle das cores dos Toggles
                      color: Colors.green,
                      selectedColor: Colors.blue,
                        borderColor:Colors.blue ,
                      selectedBorderColor: Colors.orange,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                     //
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      child: Text("D= Dia, S= Semana, M= Mês, A= Ano, G= Geral"),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UnidadesGrupos extends StatefulWidget {
  @override
  _UnidadesGruposState createState() => _UnidadesGruposState();
}

class _UnidadesGruposState extends State<UnidadesGrupos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
          title: Text("Em breve!")),
      body: Container(
        child: Center(
          child: Text("Em breve!"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text('Add'),
        onPressed: ()async{
          String resposta= await pegaFeriados();
        },
      ),

    );

  }
}

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Container(
        child: Center(
          child: Text("Em breve!"),
        ),
      ),
    );
  }
}
