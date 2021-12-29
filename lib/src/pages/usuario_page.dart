import 'package:flutter/material.dart';
import 'package:precavidos_simulador/src/ads/banner_ad.dart';
import 'package:precavidos_simulador/src/pages/resultado_page.dart';
import 'package:provider/provider.dart';
import 'package:precavidos_simulador/src/models/infousuario_response.dart';
import 'package:precavidos_simulador/src/services/preguntas_service.dart';
import 'package:precavidos_simulador/src/models/usuario.dart';
import 'package:precavidos_simulador/src/services/auth_service.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({Key? key}) : super(key: key);

  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> with AutomaticKeepAliveClientMixin<UsuarioPage>{

  @override
  Widget build(BuildContext context) {

    final _authService = Provider.of<AuthService>(context);
    final Usuario? usuario = _authService.usuario;

    print(usuario?.toJson().values);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: ( _ ) => new PreguntasService(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                (usuario?.photoUrl != null)
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(usuario!.photoUrl!),
                                  )
                                  : CircleAvatar(
                                    radius: 30,
                                    child: Text("${usuario?.displayName?[0]}", style: TextStyle(fontSize: 25),),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(usuario?.displayName ?? "No name", overflow: TextOverflow.ellipsis,),
                                      Text("Estudiante", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold))
                                    ],
                                  ),
                              ],     
                            ),
                  
                            Row(
                              children: [
                                IconButton(
                                  onPressed: (){
                                    _authService.signOut();
                                  }, 
                                  icon:  Icon(Icons.power_settings_new_rounded, color: Colors.red[300]),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 2  ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.task, color: Theme.of(context).primaryColor,),
                            SizedBox(width: 10),
                            Text("Avance del Estudiante", style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 10 ),
                        Text("Revisa tus últimos 3 simuladores realizados por categoría. También puedes consultar como resolver los ejercicios de estas preguntas"),
                        SizedBox(height: 10 ),
                        Divider(thickness: 2),
                        SizedBox(height: 10 ),
                  
                        FutureBuilder(
                          future: _authService.getInfoUser(),
                          builder: (BuildContext context, AsyncSnapshot<InfoUserResponse> snapshot){
                  
                            if(snapshot.hasData){
                              if(snapshot.data!.msg == "Usuario no encontrado"){
                                return Text(
                                  "Aún no has realizado ningún simulador, Intenta realizar uno ahora.", 
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                );
                              }
                  
                              final ListaSimuladores? simuladores1 = snapshot.data!.simuladores;
                              final ListaSimuladores? simuladores2 = snapshot.data!.simuladores2;
                              final ListaSimuladores? simuladores3 = snapshot.data!.simuladores3;
                                                    
                              return Column(
                                children: [
            
                                  (simuladores1?.numerico == null && simuladores1?.logico == null && simuladores1?.verbal == null && simuladores1?.abstracto == null)
                                    ? Text("Aún no has realizado simuladores de nivel 1")
                                    : Column(
                                      children: [
                                        Text("Simuladores Nivel 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        SizedBox(height: 10),
                                        _SimulacionesCategoria(listaSimuladores: simuladores1!),
                                      ],
                                    ),
                                  
                                  (simuladores2?.numerico == null && simuladores2?.logico == null && simuladores2?.verbal == null && simuladores2?.abstracto == null)
                                    ? Text("Aún no has realizado simuladores de nivel 2")
                                    : Column(
                                      children: [
                                        Divider(),
                                        Text("Simuladores Nivel 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        SizedBox(height: 10),
                                        _SimulacionesCategoria(listaSimuladores: simuladores2!),
                                      ],
                                    ),
                                  
                                  
                                  (simuladores3?.numerico == null && simuladores3?.logico == null && simuladores3?.verbal == null && simuladores3?.abstracto == null)
                                    ? Text("Aún no has realizado simuladores de nivel 3")
                                    : Column(
                                      children: [
                                        Divider(),
                                        Text("Simuladores Nivel 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                        SizedBox(height: 10),
                                        _SimulacionesCategoria(listaSimuladores: simuladores3!),
                                      ],
                                    ),
                                  
                                ],
                              );
                            }
                            return CircularProgressIndicator();
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            BannerAdGoogle()
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _SimulacionesCategoria extends StatelessWidget {

  final ListaSimuladores listaSimuladores;

  const _SimulacionesCategoria({
    required this.listaSimuladores
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        (listaSimuladores.numerico != null) 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Razonamiento Numérico", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                _Simulaciones(simulaciones: listaSimuladores.numerico!),
                SizedBox(height: 10),
              ]
            )
          : SizedBox.shrink(),

        (listaSimuladores.logico != null) 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Razonamiento Lógico", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                _Simulaciones(simulaciones: listaSimuladores.logico!),
                SizedBox(height: 10),
              ]
            )
          : SizedBox.shrink(),

        (listaSimuladores.verbal != null) 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Razonamiento Verbal", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                _Simulaciones(simulaciones: listaSimuladores.verbal!),
                SizedBox(height: 10),
              ]
            )
          : SizedBox.shrink(),

        (listaSimuladores.abstracto != null) 
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Razonamiento Abstracto", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                _Simulaciones(simulaciones: listaSimuladores.abstracto!),
                SizedBox(height: 10),
              ]
            )
          : SizedBox.shrink(),
      ]
    );
  }
}

class _Simulaciones extends StatelessWidget {

  final List<Simulacion> simulaciones;

  const _Simulaciones({
    required this.simulaciones
  });

  @override
  Widget build(BuildContext context) {

    final List<Widget> list = [];
    final List<String> listaPreguntas = [];
    final Map<String, String> userResponses = {};
    final _preguntasService = Provider.of<PreguntasService>(context);

    list.add(
      (_preguntasService.consultando) 
      ? SizedBox(
        child: CircularProgressIndicator(),
        height: 10.0,
        width: 10.0,
      )
      : SizedBox.shrink()
    );

    for (Simulacion simulacion in simulaciones) {
      list.add(
        new InkWell(

          onTap: (_preguntasService.consultando) 
            ? (){}
            : () async {
              for (InfoSimulacion infoSimulacion in simulacion.preguntas) {
                listaPreguntas.add(infoSimulacion.id);
              
                if (infoSimulacion.userRespuesta != null){
                  userResponses[infoSimulacion.id] = infoSimulacion.userRespuesta!;
                }
              }

              final preguntas = await _preguntasService.getPreguntasById(listaPreguntas);
              //print(preguntas);

              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ResultadoPage(preguntas: preguntas!, userResponses: userResponses))
              );
            },
          
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(7))
            ),
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Fecha: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${DateTime.fromMillisecondsSinceEpoch(simulacion.fecha).toString().split(" ")[0]}")
                  ]
                ),
                Row(
                  children: [
                    Text("Puntaje: ", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${simulacion.puntaje}"),
                  ]
                ),
                Row(
                  children: [
                    Text("Ver más", style: TextStyle(fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward_ios_outlined, size: 15,)
                  ],
                )
              ],
            ),
          ),
        )
      );
    }
    return Column(
      children: list,
    );
  }
}