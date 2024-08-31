import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Future<void> deletePeople(String uid) async {
      setState(() {
        _isLoading = true;
      });
      await removePeople(uid);
      setState(() {
        _isLoading = false;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase - CRUD'),
      ),
      body: FutureBuilder(
        future: getPeople(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return (ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: ((context, index) {
                  return Dismissible(
                    onDismissed: (direction) async {
                      deletePeople(snapshot.data?[index]['uid']);
                      snapshot.data?.removeAt(index);
                      setState(() {});
                    },
                    confirmDismiss: (direction) async {
                      bool result = false;

                      result = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                  "¿ Deseas eliminar esta persona ${snapshot.data?[index]['name']}?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, false);
                                  },
                                  child: const Text(
                                    "Cancelar",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    return Navigator.pop(context, true);
                                  },
                                  child: const Text("Si, Estoy seguro"),
                                )
                              ],
                            );
                          });

                      return result;
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(
                        Icons.delete_sharp,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    key: Key(snapshot.data?[index]['uid']),
                    child: ListTile(
                      title: Text(snapshot.data?[index]['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              deletePeople(snapshot.data?[index]['uid']);
                              setState(() {});
                            },
                          )
                        ],
                      ),
                      onTap: () async {
                        await Navigator.pushNamed(context, '/edit', arguments: {
                          'name': snapshot.data?[index]['name'],
                          'uid': snapshot.data?[index]['uid']
                        });
                        setState(() {});
                      },
                    ),
                  );
                })));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
