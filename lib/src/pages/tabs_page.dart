import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/models/usuario.dart';
import 'package:precavidos_simulador/src/pages/login_page.dart';
import 'package:precavidos_simulador/src/pages/usuario_page.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/pages/home_page.dart';


class TabsPage extends StatelessWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return ChangeNotifierProvider(
      create: (_) => new _NavegacionModel(),  
      child: Scaffold(
        body: StreamBuilder<Usuario?>(
          stream: authService.user,
          builder: ( _ , AsyncSnapshot<Usuario?> snapshot){
          
          if (snapshot.connectionState == ConnectionState.active) {
            final Usuario? usuario = snapshot.data;
            return usuario == null ? _Paginas2(): _Paginas();
          }else{
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        },
        ),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      onTap: (i) => navegacionModel.paginaActual = i,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.app_registration), label: "Practicar"),
        //BottomNavigationBarItem(icon: Icon(Icons.question_answer_sharp), label: "Contestar"),
        //BottomNavigationBarItem(icon: Icon(Icons.insert_comment), label: "Contestar"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Usuario"),
      ]
    );
  }
}


class _Paginas2 extends StatelessWidget {
  const _Paginas2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<_NavegacionModel>(context);

    return PageView(
      controller: navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomePage(),
        //ContestarPage(),
        LoginPage(),
      ]
    );
  }
}

class _Paginas extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final navegacionModel = Provider.of<_NavegacionModel>(context);
    
    return PageView(
      //physics: BouncingScrollPhysics(),
      controller: navegacionModel.pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        HomePage(),
        //ContestarPage(),
        UsuarioPage(),
        /*StreamBuilder<Usuario?>(
          stream: authService.user,
          builder: ( _ , AsyncSnapshot<Usuario?> snapshot){
            if (snapshot.connectionState == ConnectionState.active) {
              final Usuario? usuario = snapshot.data;
              return usuario == null ? LoginPage(): UsuarioPage();
            }else{
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
          },
        ),*/
      ],
    );
  }
}

class _NavegacionModel with ChangeNotifier{

  int _paginaActual = 0;
  
  PageController _pageController = new PageController(initialPage: 0);

  int get paginaActual => this._paginaActual;

  set paginaActual(int valor){
    this._paginaActual = valor;

    _pageController.animateToPage(valor, duration: Duration(milliseconds: 250), curve: Curves.easeOut);

    notifyListeners();
  }

  PageController get pageController => this._pageController;

}