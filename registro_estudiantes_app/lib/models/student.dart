class Student {
  int? id;
  String nombre;
  String edad;
  String fecha;
  String pais;
  String ciudad;
  double cuotaInicial;
  double cuotaMensual;

  Student({
    this.id,
    required this.nombre,
    required this.edad,
    required this.fecha,
    required this.pais,
    required this.ciudad,
    required this.cuotaInicial,
    required this.cuotaMensual,
  });

  // Convertir a mapa para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'edad': edad,
      'fecha': fecha,
      'pais': pais,
      'ciudad': ciudad,
      'cuotaInicial': cuotaInicial,
      'cuotaMensual': cuotaMensual,
    };
  }

  // Crear objeto desde un mapa de SQLite
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      nombre: map['nombre'],
      edad: map['edad'],
      fecha: map['fecha'],
      pais: map['pais'],
      ciudad: map['ciudad'],
      cuotaInicial: map['cuotaInicial'],
      cuotaMensual: map['cuotaMensual'],
    );
  }
}
