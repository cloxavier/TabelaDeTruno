import 'package:flutter/material.dart';
import 'dados.dart';
/* **************************************************************
* Colocar no main() um AnimatedBuilder retornando               *
*  um MaterialApp e com a propriedade                           *
*  animation: AppController.instance,o parametro   escuro do    *
* changeTheme({bool escuro}) controla a alteração do tema  e    *
* temaDarK controla la no main() o tema da seguinte forma       *
* theme: ThemeData(brightness: AppController.instance.temaDark  *
*              ? Brightness.dark                                *
*                :Brightness.light                              *
*        ),                                                     *
* a variável isTemaDark é utilizada para outros controles.      *
* ************************************************************* */
class AppController extends ChangeNotifier{
  static AppController instance = AppController();
  bool temaDark =isTemaDark;
  changeTheme({bool escuro}){

        temaDark =(escuro!=null)?escuro: !temaDark;
        isTemaDark= temaDark;
        notifyListeners();
  }
}
