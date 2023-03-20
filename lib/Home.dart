import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async {
    String url = "https://blockchain.info/ticker";
    http.Response response = await http.get(url);
    return json.decode( response.body );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPreco(),
      //SNAPSHOOT -----> SÃO OS DADOS QUE VC RECUPEROU NA VARIAVEL _recuperarPreco() ao fazer a requisicao
      builder: (context, snapshot){

        String resultado;
        //fazer o controle de conexao
        switch (snapshot.connectionState){
          //o none defini o estado de conexao em null

          case ConnectionState.none :
          //o waiting seria um aguardando
          case ConnectionState.waiting :
            print("conexao waiting");
            resultado = "Carregando";
            break;

          //o active ele se mantem ligando caso voce estiver fazer varias requisiçoes
          case ConnectionState.active :
          case ConnectionState.done :
            //o done serve para averiguar se houve algum tipo de erro na conexao
            if(snapshot.hasError){
              resultado = "Erro ao se conectar com a api";
            }else{
              double valor = snapshot.data["BRL"]["buy"];
              resultado = "Preco do bitcoin atualmente é ${valor.toString()} ";
            }
            break;
        }

        //lembrando quando vc usar este swotch ele irá esperar um returno e dentro deste retorno pode se passado um valor
        return Center(
          child: Text(resultado),
        );
      },
    );
  }
}
