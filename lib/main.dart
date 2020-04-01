import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

var request = "https://viacep.com.br/ws/${88704761}/json/";

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),

  )); //MaterialApp
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController cepController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe o CEP!";

  String cepAPI;
  String logradouroAPI;
  String complementoAPI;
  String bairroAPI;
  String localidadeAPI;
  String ufAPI;
  String unidadeAPI;
  String ibgeAPI;
  String giaAPI;

  void _resetFields() {
    cepController.text = "";
    setState(() {
      _infoText = "Informe o CEP!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _jogaCep() {
    setState(() {
      _infoText = logradouroAPI+"\n"+complementoAPI+"\n"+bairroAPI+"\n"+localidadeAPI+"\n"+ufAPI+"\n"+unidadeAPI+"\n"+ibgeAPI+"\n"+giaAPI;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (contexto, retorno) {
            if(retorno.connectionState == ConnectionState.none|| retorno.connectionState == ConnectionState.waiting) {
              return _textoCentralizado("Carregando dados...");
            } else {
              if(retorno.hasError) {
                return _textoCentralizado("Erro ao carregar dados:");
              } else {
                logradouroAPI = retorno.data["logradouro"];
                complementoAPI = retorno.data["complemento"];
                bairroAPI = retorno.data["bairro"];
                localidadeAPI = retorno.data["localidade"];
                ufAPI = retorno.data["uf"];
                unidadeAPI = retorno.data["unidade"];
                ibgeAPI = retorno.data["ibge"];
                giaAPI = retorno.data["gia"];
                return _telaPrincipal();
              }
            }
          }),
    );
  }

  _appBar() {
    return AppBar(
      title: Text("Buscador de CEP"),
      centerTitle: true,
      backgroundColor: Colors.pinkAccent,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: _resetFields,
        )
      ],
    );
  }

  _telaPrincipal() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.email, size: 120.0, color: Colors.pinkAccent),
            _textFormField("CEP", cepController, "Insira o CEP"),
            _paddingButton(),
            _texto(_infoText),
          ],
        ),
      ),
    );
  }

  _textoCentralizado(String txt) {
    return Center(
        child: Text(txt,
          style: TextStyle(
              color: Colors.pinkAccent,
              fontSize: 25.0),
          textAlign: TextAlign.center,)
    );
  }

  _texto(String _text) {
    return Text(
      _text,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.pinkAccent, fontSize: 25.0),
    );
  }

  _paddingButton() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        height: 50.0,
        child: RaisedButton(
          onPressed: () {
            if(_formKey.currentState.validate()) {
              _jogaCep();
            }
          },
          child: Text(
            "Buscar",
            style: TextStyle(color: Colors.white, fontSize: 25.0),
          ),
          color: Colors.pinkAccent,
        ),
      ),
    );
  }

  _textFormField(String _labelText, TextEditingController _controller, String _msgValidator) {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: _labelText.toString(),
            labelStyle: TextStyle(color: Colors.pinkAccent)),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.pinkAccent, fontSize: 25.0),
        controller: _controller,
        validator: (value) {
          if(value.isEmpty) {
            return _msgValidator;
          }
        }
    );
  }

}
