import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Validación',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        backgroundColor: Colors.teal[50],
        appBar: AppBar(
          title: const Text('Formulario de Validación'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Formulario(),
        ),
      ),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController tarjetaController = TextEditingController();
  final TextEditingController vencimientoController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String soloLetras = r'^[a-zA-Z\s]+$';
  String soloNumeros = r'^\d+$';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Complete sus detalles',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[

                    //nombre
                    buildTextField('Nombre', nombreController, soloLetras, 'Por favor ingrese su nombre'),
                    const SizedBox(height: 10),

                    //apellidos
                    buildTextField('Apellidos', apellidosController, soloLetras, 'Por favor ingrese sus apellidos'),
                    const SizedBox(height: 10),

                    //dirección
                    buildTextField('Dirección', direccionController, null, 'Por favor ingrese su dirección'),
                    const SizedBox(height: 10),

                    //número de la tarjeta
                    buildTextField('Número de la tarjeta', tarjetaController, soloNumeros, 'El número de tarjeta debe tener 16 dígitos', isCard: true),
                    const SizedBox(height: 10),

                    //vencimiento
                    buildTextField('Mes/Año de vencimiento (MM/YY)', vencimientoController, r'^\d{2}/\d{2}$', 'Formato MM/YY', isExpiry: true),
                    const SizedBox(height: 10),

                    //CVV
                    buildTextField('CVV', cvvController, soloNumeros, 'El CVV debe tener 3 dígitos', isCVV: true),
                    const SizedBox(height: 20),
                    
                    //envío
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Procesando datos')));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Enviar',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildTextField(String label, TextEditingController controller, String? pattern, String errorMessage, {bool isCard = false, bool isExpiry = false, bool isCVV = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: isCard || isCVV ? TextInputType.number : TextInputType.text,
      inputFormatters: [
        if (isCard || isCVV) FilteringTextInputFormatter.digitsOnly,
        if (isExpiry) FilteringTextInputFormatter(RegExp(r'^[0-9/]+$'), allow: true),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        } else if (pattern != null && !RegExp(pattern).hasMatch(value)) {
          return errorMessage;
        }
        return null;
      },
    );
  }
}
