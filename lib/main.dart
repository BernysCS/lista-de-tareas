import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(MiApp());
}

// Modelo de tarea
class Tarea {
  String titulo;
  bool completada;

  Tarea({required this.titulo, this.completada = false});

  // Convertir a JSON para guardar
  Map<String, dynamic> aJson() {
    return {'titulo': titulo, 'completada': completada};
  }

  // Crear tarea desde JSON
  factory Tarea.desdeJson(Map<String, dynamic> json) {
    return Tarea(titulo: json['titulo'], completada: json['completada']);
  }
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: PaginaTareas());
  }
}

class PaginaTareas extends StatefulWidget {
  const PaginaTareas({super.key});

  @override
  State<PaginaTareas> createState() {
    return _PaginaTareasEstado();
  }
}

class _PaginaTareasEstado extends State<PaginaTareas> {
  List<Tarea> listaTareas = [];
  TextEditingController controladorTexto = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargarTareas();
  }

  void cargarTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? datos = prefs.getString('tareas');

    if (datos != null) {
      List lista = jsonDecode(datos);
      List<Tarea> tareasCargadas = [];

      for (int i = 0; i < lista.length; i++) {
        tareasCargadas.add(Tarea.desdeJson(lista[i]));
      }

      setState(() {
        listaTareas = tareasCargadas;
      });
    }
  }

  void guardarTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> datos = [];

    for (int i = 0; i < listaTareas.length; i++) {
      datos.add(listaTareas[i].aJson());
    }

    String jsonTareas = jsonEncode(datos);
    prefs.setString('tareas', jsonTareas);
  }

  void agregarTarea() {
    String texto = controladorTexto.text;

    if (texto.isNotEmpty) {
      setState(() {
        listaTareas.add(Tarea(titulo: texto));
        controladorTexto.clear();
        guardarTareas();
      });
    }
  }

  void marcarTarea(int indice) {
    setState(() {
      bool estadoActual = listaTareas[indice].completada;
      listaTareas[indice].completada = !estadoActual;
      guardarTareas();
    });
  }

  void eliminarTarea(int indice) {
    setState(() {
      listaTareas.removeAt(indice);
      guardarTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mis Tareas')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorTexto,
                    decoration: InputDecoration(
                      hintText: 'Escribe una nueva tarea',
                    ),
                  ),
                ),
                IconButton(icon: Icon(Icons.add), onPressed: agregarTarea),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaTareas.length,
              itemBuilder: (context, indice) {
                return ListTile(
                  leading: Checkbox(
                    value: listaTareas[indice].completada,
                    onChanged: (valor) {
                      marcarTarea(indice);
                    },
                  ),
                  title: Text(
                    listaTareas[indice].titulo,
                    style: TextStyle(
                      decoration:
                          listaTareas[indice].completada
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      eliminarTarea(indice);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
