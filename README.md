# lista_de_tareas

Esta aplicación permite agregar, marcar como completada y eliminar tareas. Además, guarda las tareas aunque cierre la app.
Usa `SharedPreferences` para guardar las tareas y `JSON` para convertir las tareas en texto y poder guardarlas.

# tarea
Una tarea es como una caja con dos cosas:
- El título de la tarea (texto).
- Si está completada o no (verdadero o falso).

```
class Tarea {
  String titulo;
  bool completada;
}
```

# guardar_tarea
Flutter no puede guardar objetos directamente, entonces usamos:
`SharedPreferences` para guardar infomación como texto
`JSON` para convertir tareas en texto y poder guardarlas

```
// Convertimos lista de tareas a JSON y la guardamos
prefs.setString('tareas', jsonEncode(listaTareas));
```

# agregar_tarea
- se escribe el texto en la caja.
- se crea una nueva tarea.
- se agrega una lista.
- se guarda la lista actualizada.

```
void agregarTarea() {
  listaTareas.add(Tarea(titulo: controladorTexto.text));
}
```

# marcar_tarea
- Cuando se toca el checkbox, cambia entre hecha y no hecha.
- Luego se vuelve a guardar la lista.

```
void marcarTarea(int indice) {
  listaTareas[indice].completada = !listaTareas[indice].completada;
}
```

# eliminar_tarea
- Cuando se toca el ícono de eliminar, se quita de la lista.
- También se actualiza el guardado.

```
void eliminarTarea(int indice) {
  listaTareas.removeAt(indice);
}
```
