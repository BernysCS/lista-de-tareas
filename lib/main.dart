import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MiApp());
}

// Modelo de tarea
class Tarea {
  String titulo;
  bool completada;

  Tarea({required this.titulo, this.completada = false});

  // Convertir a JSON para guardar
  Map<String, dynamic> aJson() => {
        'titulo': titulo,
        'completada': completada,
      };

  // Crear tarea desde JSON
  factory Tarea.desdeJson(Map<String, dynamic> json) {
    return Tarea(
      titulo: json['titulo'],
      completada: json['completada'],
    );
  }
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PaginaTareas(),
    );
  }
}

class PaginaTareas extends StatefulWidget {
  const PaginaTareas({super.key});

  @override
  State<PaginaTareas> createState() => _PaginaTareasEstado();
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
      setState(() {
        listaTareas = lista.map((e) => Tarea.desdeJson(e)).toList();
      });
    }
  }

  void guardarTareas() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List datos = listaTareas.map((e) => e.aJson()).toList();
    prefs.setString('tareas', jsonEncode(datos));
  }

  void agregarTarea() {
    if (controladorTexto.text.isNotEmpty) {
      setState(() {
        listaTareas.add(Tarea(titulo: controladorTexto.text));
        controladorTexto.clear();
        guardarTareas();
      });
    }
  }

  void marcarTarea(int indice) {
    setState(() {
      listaTareas[indice].completada = !listaTareas[indice].completada;
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
      appBar: AppBar(title: const Text('Mis Tareas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controladorTexto,
                    decoration: const InputDecoration(
                        hintText: 'Escribe una nueva tarea'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: agregarTarea,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listaTareas.length,
              itemBuilder: (context, indice) => ListTile(
                leading: Checkbox(
                  value: listaTareas[indice].completada,
                  onChanged: (valor) => marcarTarea(indice),
                ),
                title: Text(
                  listaTareas[indice].titulo,
                  style: TextStyle(
                    decoration: listaTareas[indice].completada
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => eliminarTarea(indice),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
