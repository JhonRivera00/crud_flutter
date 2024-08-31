import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_service.dart';

// ignore: camel_case_types
class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

// ignore: camel_case_types
class _EditNamePageState extends State<EditNamePage> {
  TextEditingController nameController = TextEditingController(text: "");
  bool _isLoading = false;
  Future<void> _updateName(String uid) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await updatePeople(uid, nameController.text);

      if (mounted) {
        // Verifica si el widget sigue montado
        Navigator.pop(context); // Vuelve a la página anterior
      }
    } catch (e) {
      if (mounted) {
        // Maneja cualquier error que pueda ocurrir
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el nombre: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Desactiva el indicador de carga
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    nameController.text = arguments['name'];
    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit Name"),
        ),
        body: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: 'Ingrese la modificación',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _updateName(arguments['uid']);
                          },
                          child: const Text('Actualizar'))
                    ],
                  ),
                ),
        ));
  }
}
