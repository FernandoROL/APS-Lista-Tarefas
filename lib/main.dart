import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaTarefas(),
    );
  }
}

class ListaTarefas extends StatefulWidget {
  const ListaTarefas({super.key});

  @override
  _AtualizarLista createState() => _AtualizarLista();
}

class _AtualizarLista extends State<ListaTarefas> {
  List<String> tarefas = [];
  List<bool> concluidas = [];

  TextEditingController taskController = TextEditingController();

  void _adicionarTarefa(String task) {
    setState(() {
      tarefas.add(task);
      concluidas.add(false);
    });
    taskController.clear();
  }

  void _editarTarefa(int index) {
    taskController.text = tarefas[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Tarefa'),
          content: TextField(
            controller: taskController,
            decoration: InputDecoration(hintText: 'Digite o nome da tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                taskController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () {
                setState(() {
                  tarefas[index] = taskController.text;
                });
                taskController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmarDelecao(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text(
              'Tem certeza que deseja excluir a tarefa "${tarefas[index]}"?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deletarTarefa(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletarTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
      concluidas.removeAt(index);
    });
  }

  void _toggleComplete(int index) {
    setState(() {
      concluidas[index] = !concluidas[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text(
          'Lista de Tarefas',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: IconButton(
                icon: Icon(
                  concluidas[index]
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: concluidas[index] ? Colors.green : null,
                ),
                onPressed: () => _toggleComplete(index),
              ),
              title: Text(
                tarefas[index],
                style: TextStyle(
                  decoration:
                  concluidas[index] ? TextDecoration.lineThrough : null,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editarTarefa(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarDelecao(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Nova Tarefa'),
                content: TextField(
                  controller: taskController,
                  decoration:
                  InputDecoration(hintText: 'Digite o nome da tarefa'),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      taskController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Adicionar'),
                    onPressed: () {
                      _adicionarTarefa(taskController.text);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
