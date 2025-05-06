import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registro_estudiantes_app/db/database_helper.dart';
import 'summary_screen.dart';
import 'models/student.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _cuotaInicialController = TextEditingController();
  final TextEditingController _cuotaMensualController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();

  String? _paisSeleccionado;
  String? _ciudadSeleccionada;
  DateTime? _fechaSeleccionada;

  final List<String> _paises = ['Ecuador', 'Perú', 'Colombia'];
  final Map<String, List<String>> _ciudades = {
    'Ecuador': ['Quito', 'Guayaquil', 'Cuenca'],
    'Perú': ['Lima', 'Arequipa', 'Cusco'],
    'Colombia': ['Bogotá', 'Medellín', 'Cali'],
  };

  void _seleccionarFecha() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (fecha != null) {
      setState(() {
        _fechaSeleccionada = fecha;
        _fechaController.text = DateFormat('yyyy-MM-dd').format(fecha);
      });
    }
  }

  void _calcularCuotas() {
    double cuotaInicial = double.tryParse(_cuotaInicialController.text) ?? 0.0;
    double restante = 1500 - cuotaInicial;
    double cuotaMensual = (restante / 4) * 1.05;

    setState(() {
      _cuotaMensualController.text = cuotaMensual.toStringAsFixed(2);
    });
  }

  void _irAResumen() async {
    if (_formKey.currentState!.validate() &&
        _paisSeleccionado != null &&
        _ciudadSeleccionada != null &&
        _fechaSeleccionada != null) {
      // Crear objeto estudiante
      Student estudiante = Student(
        nombre: _nombreController.text,
        edad: _edadController.text,
        fecha: _fechaController.text,
        pais: _paisSeleccionado!,
        ciudad: _ciudadSeleccionada!,
        cuotaInicial: double.tryParse(_cuotaInicialController.text) ?? 0.0,
        cuotaMensual: double.tryParse(_cuotaMensualController.text) ?? 0.0,
      );

      // Guardar en la base de datos
      await DatabaseHelper().insertStudent(estudiante);

      // Navegar a la pantalla de resumen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => SummaryScreen(
                nombre: estudiante.nombre,
                edad: estudiante.edad,
                fecha: estudiante.fecha,
                pais: estudiante.pais,
                ciudad: estudiante.ciudad,
                cuotaInicial: estudiante.cuotaInicial.toStringAsFixed(2),
                cuotaMensual: estudiante.cuotaMensual.toStringAsFixed(2),
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de estudiantes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Registro de estudiantes',
                style: TextStyle(color: Colors.blue, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombres'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _fechaController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Fecha'),
                onTap: _seleccionarFecha,
              ),
              DropdownButtonFormField<String>(
                value: _paisSeleccionado,
                hint: const Text('Selecciona un país'),
                items:
                    _paises.map((String pais) {
                      return DropdownMenuItem<String>(
                        value: pais,
                        child: Text(pais),
                      );
                    }).toList(),
                onChanged: (valor) {
                  setState(() {
                    _paisSeleccionado = valor;
                    _ciudadSeleccionada = null;
                  });
                },
              ),
              if (_paisSeleccionado != null)
                DropdownButtonFormField<String>(
                  value: _ciudadSeleccionada,
                  hint: const Text('Selecciona una ciudad'),
                  items:
                      _ciudades[_paisSeleccionado]!.map((String ciudad) {
                        return DropdownMenuItem<String>(
                          value: ciudad,
                          child: Text(ciudad),
                        );
                      }).toList(),
                  onChanged: (valor) {
                    setState(() {
                      _ciudadSeleccionada = valor;
                    });
                  },
                ),
              const SizedBox(height: 10),
              const Text('Valor del curso: \$1500'),
              TextFormField(
                controller: _cuotaInicialController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cuota inicial'),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              ElevatedButton(
                onPressed: _calcularCuotas,
                child: const Text('Calcular cuotas'),
              ),
              TextFormField(
                controller: _cuotaMensualController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Cuota mensual'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _irAResumen,
                child: const Text('Resumen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
