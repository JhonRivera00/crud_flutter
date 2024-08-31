import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

// ignore: camel_case_types
class _AddNamePageState extends State<AddNamePage> {
  TextEditingController nameController = TextEditingController(text: "");
  bool _isLoading = false;
  Future<void> _addName() async {
    setState(() {
      _isLoading = true;
    });
    final name = nameController.text;
    final prefs = await SharedPreferences.getInstance();
    try {
      await addPeople(name);
      await _uploadPendingData();

      if (mounted) {
        // Verifica si el widget sigue montado
        Navigator.pop(context); // Vuelve a la página anterior
      }
    } catch (e) {
      // Manejo de error: almacenar localmente si falla al intentar enviar
      final List<String> names = prefs.getStringList('pending_names') ?? [];
      names.add(name);
      await prefs.setStringList('pending_names', names);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('No se pudo conectar. Nombre guardado localmente: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Ocultar el indicador de carga
        });
      }
    }
  }

  Future<void> _uploadPendingData() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> names = prefs.getStringList('pending_names') ?? [];

    for (var name in names) {
      try {
        await addPeople(name);
      } catch (e) {
        // Podrías registrar el error aquí para depuración
        print('Error al subir nombre pendiente: $e');
        continue;
      }
    }

    // Limpia la lista de nombres pendientes después de subirlos
    await prefs.remove('pending_names');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Name"),
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
                          hintText: 'Ingrese el nombre',
                        ),
                      ),
                      ElevatedButton(
                          onPressed: _addName, child: const Text('Guardar'))
                    ],
                  ),
                ),
        ));
  }
}
