import 'package:flutter/material.dart';

class SummaryScreen extends StatelessWidget {
  final String nombre;
  final String edad;
  final String fecha;
  final String pais;
  final String ciudad;
  final String cuotaInicial;
  final String cuotaMensual;

  SummaryScreen({
    required this.nombre,
    required this.edad,
    required this.fecha,
    required this.pais,
    required this.ciudad,
    required this.cuotaInicial,
    required this.cuotaMensual,
  });

  @override
  Widget build(BuildContext context) {
    double inicial = double.tryParse(cuotaInicial) ?? 0.0;
    double mensual = double.tryParse(cuotaMensual) ?? 0.0;
    double valorFinal = inicial + (mensual * 4);

    return Scaffold(
      appBar: AppBar(title: Text('Resumen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildResumenItem('Nombres', nombre),
            _buildResumenItem('Edad', edad),
            _buildResumenItem('Fecha', fecha),
            _buildResumenItem('País', pais),
            _buildResumenItem('Ciudad', ciudad),
            _buildResumenItem(
              'Cuota Inicial',
              '\$${inicial.toStringAsFixed(2)}',
            ),
            _buildResumenItem(
              'Cuota Mensual',
              '\$${mensual.toStringAsFixed(2)}',
            ),
            Divider(),
            _buildResumenItem(
              'Valor Final',
              '\$${valorFinal.toStringAsFixed(2)}',
              isBold: true,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenItem(
    String titulo,
    String valor, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(child: Text(titulo)),
          Text(
            valor,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
