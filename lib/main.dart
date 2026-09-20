import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const CluedoApp());
}

// ---------------------------------------------------------
// ESTRUCTURA DE DATOS
// ---------------------------------------------------------
class Jugador {
  String nombre;
  int cantidadCartas;
  String personaje;

  Jugador({required this.nombre, required this.cantidadCartas, this.personaje = '?'});
}

// ---------------------------------------------------------
// APLICACIÓN PRINCIPAL
// ---------------------------------------------------------
class CluedoApp extends StatelessWidget {
  const CluedoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cluedo Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const PantallaConfiguracion(),
    );
  }
}

// ---------------------------------------------------------
// 1. PANTALLA DE CONFIGURACIÓN
// ---------------------------------------------------------
class PantallaConfiguracion extends StatefulWidget {
  const PantallaConfiguracion({super.key});

  @override
  State<PantallaConfiguracion> createState() => _PantallaConfiguracionState();
}

class _PantallaConfiguracionState extends State<PantallaConfiguracion> {
  List<Jugador> jugadores = [
    Jugador(nombre: "Yo (me)", cantidadCartas: 6, personaje: '?'),
  ];

  final List<String> personajesDisponibles = ['?', 'Prado', 'Rubio', 'Orquídea', 'Celeste', 'Mora', 'Amapola'];

  Color _obtenerColorPersonaje(String personaje) {
    switch (personaje) {
      case 'Prado': return Colors.green;
      case 'Rubio': return Colors.amber;
      case 'Orquídea': return Colors.pinkAccent;
      case 'Celeste': return Colors.blue;
      case 'Mora': return Colors.purple;
      case 'Amapola': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _agregarJugador() {
    setState(() {
      jugadores.add(Jugador(nombre: "Jugador ${jugadores.length + 1}", cantidadCartas: 0, personaje: '?'));
    });
  }

  void _eliminarJugador(int index) {
    setState(() {
      if (jugadores.length > 2 && index != 0) { 
        jugadores.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalCartasAsignadas = jugadores.fold(0, (suma, jugador) => suma + jugador.cantidadCartas);
    bool totalCorrecto = totalCartasAsignadas == 18;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Partida', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'El Jugador 1 siempre eres TÚ.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: totalCorrecto ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: totalCorrecto ? Colors.green : Colors.red, width: 2),
                  ),
                  child: Text(
                    'Cartas repartidas: $totalCartasAsignadas / 18',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: totalCorrecto ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                bool soyYo = index == 0;
                return Card(
                  elevation: soyYo ? 4 : 1,
                  color: soyYo ? Colors.blue.shade50 : null,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: soyYo ? Colors.blue.shade200 : Colors.transparent, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _obtenerColorPersonaje(jugadores[index].personaje),
                        radius: 25,
                        child: Text(
                          jugadores[index].personaje == '?' 
                              ? '${index + 1}' 
                              : jugadores[index].personaje.substring(0, 1),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      title: TextFormField(
                        initialValue: jugadores[index].nombre,
                        decoration: InputDecoration(
                          labelText: soyYo ? 'Tú (Jugador Principal)' : 'Nombre del jugador',
                          isDense: true,
                        ),
                        onChanged: (valor) => jugadores[index].nombre = valor,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: jugadores[index].personaje,
                            isExpanded: true,
                            items: personajesDisponibles.map((p) => DropdownMenuItem(
                              value: p, 
                              child: Text(p == '?' ? 'Elige su ficha...' : 'Ficha: $p', style: const TextStyle(fontWeight: FontWeight.w500)),
                            )).toList(),
                            onChanged: (val) {
                              setState(() {
                                jugadores[index].personaje = val!;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Cartas: ', style: TextStyle(fontWeight: FontWeight.w500)),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.blueGrey),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    if (jugadores[index].cantidadCartas > 0) jugadores[index].cantidadCartas--;
                                  });
                                },
                              ),
                              Text('${jugadores[index].cantidadCartas}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.blueGrey),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  setState(() {
                                    jugadores[index].cantidadCartas++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: soyYo ? null : IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarJugador(index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _agregarJugador,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Añadir Jugador'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    HapticFeedback.heavyImpact();
                    if (totalCorrecto) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaSeleccionMisCartas(jugadores: jugadores),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajusta las cartas para que sumen 18 en total.'), backgroundColor: Colors.red));
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: totalCorrecto ? Colors.blue.shade800 : Colors.grey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Elegir mis cartas', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// 2. PANTALLA: SELECCIÓN INICIAL DE TUS CARTAS
// ---------------------------------------------------------
class PantallaSeleccionMisCartas extends StatefulWidget {
  final List<Jugador> jugadores;
  const PantallaSeleccionMisCartas({super.key, required this.jugadores});

  @override
  State<PantallaSeleccionMisCartas> createState() => _PantallaSeleccionMisCartasState();
}

class _PantallaSeleccionMisCartasState extends State<PantallaSeleccionMisCartas> {
  final List<String> todasLasCartas = [
    'Prado', 'Rubio', 'Orquídea', 'Celeste', 'Mora', 'Amapola',
    'Candelabro', 'Puñal', 'Tubería de plomo', 'Pistola', 'Cuerda', 'Herramienta',
    'Sala de baile', 'Sala de billar', 'Invernadero', 'Comedor', 'Vestíbulo', 'Cocina', 'Biblioteca', 'Salón', 'Estudio'
  ];
  
  final Set<String> misCartasSeleccionadas = {};

  @override
  Widget build(BuildContext context) {
    int maxCartas = widget.jugadores[0].cantidadCartas;
    int seleccionadas = misCartasSeleccionadas.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('¿Cuáles son tus cartas?', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'Selecciona exactamente tus $maxCartas cartas iniciales.',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  '$seleccionadas / $maxCartas seleccionadas', 
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: seleccionadas == maxCartas ? Colors.green.shade700 : Colors.red.shade700
                  )
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: todasLasCartas.length,
              itemBuilder: (context, index) {
                String carta = todasLasCartas[index];
                bool seleccionada = misCartasSeleccionadas.contains(carta);
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (seleccionada) {
                        misCartasSeleccionadas.remove(carta);
                      } else if (misCartasSeleccionadas.length < maxCartas) {
                        misCartasSeleccionadas.add(carta);
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: seleccionada ? Colors.green.shade100 : Colors.white,
                      border: Border.all(color: seleccionada ? Colors.green.shade600 : Colors.grey.shade300, width: seleccionada ? 2 : 1),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        if (seleccionada) BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))
                      ]
                    ),
                    child: Text(carta, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: seleccionada ? Colors.green.shade900 : Colors.black87, fontWeight: seleccionada ? FontWeight.bold : FontWeight.w500)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: seleccionadas == maxCartas ? () {
          HapticFeedback.heavyImpact();
          Map<String, int> estadoInicial = {};
          String miNombre = widget.jugadores[0].nombre;

          for (String carta in todasLasCartas) {
            if (misCartasSeleccionadas.contains(carta)) {
              estadoInicial["${miNombre}_$carta"] = 2; 
              for (int i = 1; i < widget.jugadores.length; i++) {
                estadoInicial["${widget.jugadores[i].nombre}_$carta"] = 1; 
              }
            } else {
              estadoInicial["${miNombre}_$carta"] = 1; 
            }
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PantallaTablero(jugadores: widget.jugadores, estadoInicial: estadoInicial),
            ),
          );
        } : null,
        backgroundColor: seleccionadas == maxCartas ? Colors.blue.shade800 : Colors.grey,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.videogame_asset),
        label: const Text('Comenzar Partida', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ---------------------------------------------------------
// 3. PANTALLA MOSTRAR CARTA (AHORA BLINDADA ANTI-TOQUE)
// ---------------------------------------------------------
class PantallaMostrarCarta extends StatelessWidget {
  final String carta;
  final String archivoImagen;
  
  const PantallaMostrarCarta({super.key, required this.carta, required this.archivoImagen});

  void _intentarSalir(BuildContext context) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a tocar un botón
      builder: (context) => AlertDialog(
        title: const Text('¿Ocultar carta?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Asegúrate de que tienes tú el móvil de vuelta y el otro jugador ya no está mirando la pantalla.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Solo cierra el diálogo
            child: const Text('Aún no', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              Navigator.pop(context); // Cierra la pantalla completa de la carta
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade700),
            child: const Text('Sí, ya la ha visto', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // PopScope evita que la pantalla se cierre si alguien usa el gesto de atrás del móvil
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _intentarSalir(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // El GestureDetector ahora lanza el aviso en lugar de cerrar directamente
        body: GestureDetector(
          onTap: () => _intentarSalir(context), 
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('MUESTRA ESTO AL JUGADOR', style: TextStyle(color: Colors.redAccent, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
                const SizedBox(height: 40),
                SizedBox(
                  height: 400,
                  child: Image.asset(
                    'assets/images/$archivoImagen.jpeg', 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 250, height: 350, color: Colors.white,
                      alignment: Alignment.center,
                      child: Text(carta, style: const TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Se ha cambiado el texto para que se entienda que pide confirmación
                const Text('(Toca la pantalla cuando hayas terminado)', style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 30),
                Text(
                  carta.toUpperCase(), 
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.amberAccent, 
                    fontSize: 32, 
                    fontWeight: FontWeight.w900, 
                    letterSpacing: 2
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// 4. PANTALLA DEL TABLERO PRINCIPAL (TABLA CONGELADA)
// ---------------------------------------------------------
class PantallaTablero extends StatefulWidget {
  final List<Jugador> jugadores;
  final Map<String, int> estadoInicial;

  const PantallaTablero({super.key, required this.jugadores, required this.estadoInicial});

  @override
  State<PantallaTablero> createState() => _PantallaTableroState();
}

class _PantallaTableroState extends State<PantallaTablero> {
  final List<String> sospechosos = ['Prado', 'Rubio', 'Orquídea', 'Celeste', 'Mora', 'Amapola'];
  final List<String> armas = ['Candelabro', 'Puñal', 'Tubería de plomo', 'Pistola', 'Cuerda', 'Herramienta'];
  final List<String> lugares = ['Sala de baile', 'Sala de billar', 'Invernadero', 'Comedor', 'Vestíbulo', 'Cocina', 'Biblioteca', 'Salón', 'Estudio'];

  late Map<String, int> _estadoCasillas;
  final List<Map<String, dynamic>> _deduccionesPendientes = [];

  final List<Map<String, int>> _historialEstados = [];
  final List<List<Map<String, dynamic>>> _historialDeducciones = [];

  Offset _posicionBoton = const Offset(250, 600);
  bool _mostrarDescartadas = false;

  List<String> sospechososActivos = [];
  List<String> armasActivas = [];
  List<String> lugaresActivos = [];
  List<String> cartasDescartadas = [];

  @override
  void initState() {
    super.initState();
    _estadoCasillas = Map.from(widget.estadoInicial);
    _revisarDeducciones();
  }

  void _guardarEstado() {
    _historialEstados.add(Map.from(_estadoCasillas));
    List<Map<String, dynamic>> copiaDeducciones = [];
    for (var d in _deduccionesPendientes) {
      copiaDeducciones.add({'jugador': d['jugador'], 'cartas': List<String>.from(d['cartas'])});
    }
    _historialDeducciones.add(copiaDeducciones);
  }

  void _deshacer() {
    if (_historialEstados.isNotEmpty) {
      HapticFeedback.mediumImpact();
      setState(() {
        _estadoCasillas = _historialEstados.removeLast();
        _deduccionesPendientes.clear();
        _deduccionesPendientes.addAll(_historialDeducciones.removeLast());
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deshecho correctamente ↩️'), duration: Duration(milliseconds: 1500), backgroundColor: Colors.blueGrey),
      );
    }
  }

  String _obtenerNombreArchivo(String nombreCarta) {
    switch (nombreCarta) {
      case 'Orquídea': return 'Orquidea';
      case 'Puñal': return 'punal';
      case 'Tubería de plomo': return 'tuberia';
      case 'Sala de baile': return 'baile';
      case 'Sala de billar': return 'billar';
      case 'Vestíbulo': return 'vestibulo';
      case 'Salón': return 'salon';
      case 'Candelabro': return 'candelabro';
      case 'Pistola': return 'pistola';
      case 'Cuerda': return 'cuerda';
      case 'Herramienta': return 'herramienta';
      case 'Invernadero': return 'invernadero';
      case 'Comedor': return 'comedor';
      case 'Cocina': return 'cocina';
      case 'Biblioteca': return 'biblioteca';
      case 'Estudio': return 'estudio';
      case 'Prado': return 'Prado';
      case 'Rubio': return 'Rubio';
      case 'Celeste': return 'Celeste';
      case 'Mora': return 'Mora';
      case 'Amapola': return 'Amapola';
      default: return nombreCarta;
    }
  }

  Widget _obtenerIcono(int estado) {
    switch (estado) {
      case 1: return Icon(Icons.close, color: Colors.red.shade700, size: 28);
      case 2: return Icon(Icons.check, color: Colors.green.shade700, size: 28);
      case 3: return Icon(Icons.question_mark, color: Colors.orange.shade800, size: 24);
      default: return const Text('');
    }
  }

  Color _obtenerColorFondo(int estado) {
    switch (estado) {
      case 1: return Colors.red.shade50;
      case 2: return Colors.green.shade50;
      case 3: return Colors.orange.shade50;
      default: return Colors.transparent;
    }
  }

  Color _obtenerColorPersonaje(String personaje) {
    switch (personaje) {
      case 'Prado': return Colors.green.shade700;
      case 'Rubio': return Colors.amber.shade800;
      case 'Orquídea': return Colors.pinkAccent.shade400;
      case 'Celeste': return Colors.blue.shade700;
      case 'Mora': return Colors.purple.shade600;
      case 'Amapola': return Colors.red.shade700;
      default: return Colors.black87; 
    }
  }

  void _marcarCasillaManual(String jugadorNombre, String carta) {
    HapticFeedback.lightImpact(); 
    _guardarEstado(); 

    int estadoActual = _estadoCasillas["${jugadorNombre}_$carta"] ?? 0;
    int nuevoEstado;
    switch (estadoActual) {
      case 0: nuevoEstado = 1; break; 
      case 1: nuevoEstado = 3; break; 
      case 2: nuevoEstado = 0; break; 
      case 3: nuevoEstado = 2; break; 
      default: nuevoEstado = 0;
    }

    setState(() {
      _estadoCasillas["${jugadorNombre}_$carta"] = nuevoEstado;
      if (nuevoEstado == 2) {
        for (var j in widget.jugadores) {
          if (j.nombre != jugadorNombre) {
            _estadoCasillas["${j.nombre}_$carta"] = 1;
          }
        }
      }
      _revisarDeducciones();
    });
  }

  void _marcarCartaComoVista(String jugador, String carta) {
    if (_estadoCasillas["${jugador}_$carta"] == 2) return; 
    _estadoCasillas["${jugador}_$carta"] = 2; 
    for (var j in widget.jugadores) {
      if (j.nombre != jugador) {
        _estadoCasillas["${j.nombre}_$carta"] = 1; 
      }
    }
  }

  void _revisarDeducciones() {
    bool huboCambios = true;
    while (huboCambios) {
      huboCambios = false;

      for (int i = _deduccionesPendientes.length - 1; i >= 0; i--) {
        var deduccion = _deduccionesPendientes[i];
        String jugador = deduccion['jugador'];
        List<String> cartas = List.from(deduccion['cartas']);

        if (cartas.any((carta) => _estadoCasillas["${jugador}_$carta"] == 2)) {
          _deduccionesPendientes.removeAt(i);
          continue;
        }
        cartas.removeWhere((carta) => _estadoCasillas["${jugador}_$carta"] == 1);

        if (cartas.length == 1) {
          _marcarCartaComoVista(jugador, cartas.first);
          _deduccionesPendientes.removeAt(i);
          huboCambios = true;
        } else if (cartas.isEmpty) {
          _deduccionesPendientes.removeAt(i);
        } else {
          _deduccionesPendientes[i]['cartas'] = cartas;
        }
      }

      for (var jugador in widget.jugadores) {
        int cartasEncontradas = 0;
        int casillasVacias = 0;
        int casillasDuda = 0;
        List<String> cartasVacias = [];
        List<String> cartasDuda = [];

        for (var carta in [...sospechosos, ...armas, ...lugares]) {
          int estado = _estadoCasillas["${jugador.nombre}_$carta"] ?? 0;
          if (estado == 2) {
            cartasEncontradas++;
          } else if (estado == 0) {
            casillasVacias++;
            cartasVacias.add(carta);
          } else if (estado == 3) {
            casillasDuda++;
            cartasDuda.add(carta);
          }
        }

        int cartasFaltantes = jugador.cantidadCartas - cartasEncontradas;

        if (cartasFaltantes == 1 && casillasDuda == 1 && casillasVacias == 0) {
          _marcarCartaComoVista(jugador.nombre, cartasDuda.first);
          huboCambios = true;
        }

        if (cartasEncontradas == jugador.cantidadCartas && (casillasVacias > 0 || casillasDuda > 0)) {
          for (var carta in [...cartasVacias, ...cartasDuda]) {
            _estadoCasillas["${jugador.nombre}_$carta"] = 1;
          }
          huboCambios = true;
        }

        int opcionesTotales = casillasVacias + casillasDuda;
        if (cartasFaltantes > 0 && opcionesTotales == cartasFaltantes && opcionesTotales > 0) {
          for (var carta in [...cartasVacias, ...cartasDuda]) {
            _marcarCartaComoVista(jugador.nombre, carta);
          }
          huboCambios = true;
        }
      }
    }
  }

  String _obtenerSolucion(List<String> grupo) {
    List<String> sinVerde = [];
    for (var carta in grupo) {
      bool alguienLaTiene = false;
      for (var j in widget.jugadores) {
        if (_estadoCasillas["${j.nombre}_$carta"] == 2) {
          alguienLaTiene = true;
          break;
        }
      }
      if (!alguienLaTiene) {
        sinVerde.add(carta);
      }
    }
    if (sinVerde.length == 1) return sinVerde.first;
    return "?";
  }

  void _clasificarCartas() {
    sospechososActivos.clear(); armasActivas.clear(); lugaresActivos.clear(); cartasDescartadas.clear();

    void clasificar(String carta, List<String> listaActiva) {
      bool laTienenOtros = false;
      for (int i = 1; i < widget.jugadores.length; i++) {
        if (_estadoCasillas["${widget.jugadores[i].nombre}_$carta"] == 2) {
          laTienenOtros = true;
          break;
        }
      }
      if (laTienenOtros) {
        cartasDescartadas.add(carta);
      } else {
        listaActiva.add(carta);
      }
    }

    for (var c in sospechosos) clasificar(c, sospechososActivos);
    for (var c in armas) clasificar(c, armasActivas);
    for (var c in lugares) clasificar(c, lugaresActivos);
  }

  Widget _construirBarraAsesinato() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.grey.shade900, Colors.black], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 16, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _cajaSolucion('ASESINO', _obtenerSolucion(sospechosos)),
          Container(width: 1, height: 40, color: Colors.white24), 
          _cajaSolucion('ARMA', _obtenerSolucion(armas)),
          Container(width: 1, height: 40, color: Colors.white24), 
          _cajaSolucion('LUGAR', _obtenerSolucion(lugares)),
        ],
      ),
    );
  }

  Widget _cajaSolucion(String titulo, String solucion) {
    bool revelado = solucion != "?";
    return Expanded(
      child: Column(
        children: [
          Text(titulo, style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Text(
            solucion, 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: revelado ? Colors.greenAccent.shade400 : Colors.grey.shade600, 
              fontWeight: revelado ? FontWeight.w900 : FontWeight.normal,
              fontSize: revelado ? 15 : 20
            )
          ),
        ],
      ),
    );
  }

  final double rowHeight = 55.0;
  final double headerHeight = 50.0;
  final double sectionHeight = 35.0;
  final double firstColWidth = 150.0;
  final double playerColWidth = 80.0;

  Widget _buildColumnaFija() {
    List<Widget> children = [];

    children.add(Container(
      height: headerHeight, width: firstColWidth, alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Colors.blue.shade50, border: Border(right: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300, width: 2))),
      child: const Text('CARTAS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
    ));

    void addSection(String title, List<String> items) {
      if (items.isEmpty) return;
      children.add(Container(
        height: sectionHeight, width: firstColWidth, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(color: Colors.blue.shade800, border: Border(right: BorderSide(color: Colors.grey.shade300))),
        child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
      ));

      for (var elemento in items) {
        String nombreArchivo = _obtenerNombreArchivo(elemento);
        children.add(Container(
          height: rowHeight, width: firstColWidth,
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300), right: BorderSide(color: Colors.grey.shade300))),
          child: Row(
            children: [
              const SizedBox(width: 8),
              GestureDetector(
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      contentPadding: EdgeInsets.zero, 
                      backgroundColor: Colors.transparent, 
                      content: ClipRRect(
                        borderRadius: BorderRadius.circular(15), 
                        child: Image.asset(
                          'assets/images/$nombreArchivo.jpeg', 
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: const Text('Imagen no encontrada.\nRevisa la configuración.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
                          ),
                        )
                      )
                    )
                  );
                },
                child: Container(
                  width: 30, height: 40, margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade400, width: 1), borderRadius: BorderRadius.circular(4), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]),
                  clipBehavior: Clip.hardEdge,
                  child: Image.asset('assets/images/$nombreArchivo.jpeg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 16, color: Colors.grey)),
                ),
              ),
              Expanded(child: Text(elemento, maxLines: 2, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 4),
            ],
          ),
        ));
      }
    }

    addSection('¿QUIÉN?', sospechososActivos);
    addSection('¿QUÉ ARMA?', armasActivas);
    addSection('¿DÓNDE?', lugaresActivos);

    if (cartasDescartadas.isNotEmpty) {
      children.add(GestureDetector(
        onTap: () { HapticFeedback.lightImpact(); setState(() { _mostrarDescartadas = !_mostrarDescartadas; }); },
        child: Container(
          height: sectionHeight, width: firstColWidth, alignment: Alignment.centerLeft, padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(color: Colors.grey.shade800, border: Border(right: BorderSide(color: Colors.grey.shade300))),
          child: Row(
            children: [
              Icon(_mostrarDescartadas ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              const Expanded(child: Text('DESCARTES', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1))),
            ],
          ),
        )
      ));

      if (_mostrarDescartadas) {
        for (var elemento in cartasDescartadas) {
          String nombreArchivo = _obtenerNombreArchivo(elemento);
          children.add(Container(
            height: rowHeight, width: firstColWidth,
            decoration: BoxDecoration(color: Colors.grey.shade200, border: Border(bottom: BorderSide(color: Colors.grey.shade300), right: BorderSide(color: Colors.grey.shade300))),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Container(
                  width: 25, height: 35, margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400, width: 1), borderRadius: BorderRadius.circular(4)),
                  clipBehavior: Clip.hardEdge,
                  child: Opacity(opacity: 0.5, child: Image.asset('assets/images/$nombreArchivo.jpeg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 16, color: Colors.grey))),
                ),
                Expanded(child: Text(elemento, maxLines: 2, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 4),
              ],
            ),
          ));
        }
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  Widget _buildColumnasJugadores() {
    List<Widget> children = [];

    children.add(Row(
      children: widget.jugadores.map((j) => Container(
        height: headerHeight, width: playerColWidth, alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.blue.shade50, border: Border(right: BorderSide(color: Colors.grey.shade300), bottom: BorderSide(color: Colors.grey.shade300, width: 2))),
        child: Text(j.nombre.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: _obtenerColorPersonaje(j.personaje)), overflow: TextOverflow.ellipsis),
      )).toList(),
    ));

    void addSectionCells(List<String> items) {
      if (items.isEmpty) return;
      children.add(Row(
        children: widget.jugadores.map((_) => Container(
          height: sectionHeight, width: playerColWidth,
          decoration: BoxDecoration(color: Colors.blue.shade800, border: Border(right: BorderSide(color: Colors.blue.shade800))),
        )).toList(),
      ));

      for (var carta in items) {
        children.add(Row(
          children: widget.jugadores.map((j) {
            int estado = _estadoCasillas["${j.nombre}_$carta"] ?? 0;
            return InkWell(
              onTap: () => _marcarCasillaManual(j.nombre, carta),
              child: Container(
                height: rowHeight, width: playerColWidth, alignment: Alignment.center,
                decoration: BoxDecoration(color: _obtenerColorFondo(estado), border: Border(bottom: BorderSide(color: Colors.grey.shade300), right: BorderSide(color: Colors.grey.shade300))),
                child: _obtenerIcono(estado),
              ),
            );
          }).toList(),
        ));
      }
    }

    addSectionCells(sospechososActivos);
    addSectionCells(armasActivas);
    addSectionCells(lugaresActivos);

    if (cartasDescartadas.isNotEmpty) {
      children.add(Row(
        children: widget.jugadores.map((_) => Container(
          height: sectionHeight, width: playerColWidth,
          decoration: BoxDecoration(color: Colors.grey.shade800, border: Border(right: BorderSide(color: Colors.grey.shade800))),
        )).toList(),
      ));

      if (_mostrarDescartadas) {
        for (var carta in cartasDescartadas) {
          children.add(Row(
            children: widget.jugadores.map((j) {
              int estado = _estadoCasillas["${j.nombre}_$carta"] ?? 0;
              return InkWell(
                onTap: () => _marcarCasillaManual(j.nombre, carta),
                child: Container(
                  height: rowHeight, width: playerColWidth, alignment: Alignment.center,
                  decoration: BoxDecoration(color: _obtenerColorFondo(estado), border: Border(bottom: BorderSide(color: Colors.grey.shade300), right: BorderSide(color: Colors.grey.shade300))),
                  child: _obtenerIcono(estado),
                ),
              );
            }).toList(),
          ));
        }
      }
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: children);
  }

  void _iniciarRondaRespuestas(String acusador, String sospechoso, String arma, String lugar) {
    int indexAcusador = widget.jugadores.indexWhere((j) => j.nombre == acusador);
    int turnoInicial = (indexAcusador + 1) % widget.jugadores.length;
    _procesarTurno(turnoInicial, indexAcusador, acusador, sospechoso, arma, lugar);
  }

  void _procesarTurno(int turnoActual, int turnoFinal, String acusador, String sospechoso, String arma, String lugar) {
    if (turnoActual == turnoFinal) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nadie tenía las cartas. ¡El misterio se aclara!'), backgroundColor: Colors.purple));
      return; 
    }

    String jugadorResponde = widget.jugadores[turnoActual].nombre;
    bool soyYoElQueResponde = (turnoActual == 0); 
    bool soyYoElAcusador = (widget.jugadores[0].nombre == acusador);

    if (soyYoElQueResponde) {
      List<String> misCartasInvolucradas = [];
      if (_estadoCasillas["${jugadorResponde}_$sospechoso"] == 2) misCartasInvolucradas.add(sospechoso);
      if (_estadoCasillas["${jugadorResponde}_$arma"] == 2) misCartasInvolucradas.add(arma);
      if (_estadoCasillas["${jugadorResponde}_$lugar"] == 2) misCartasInvolucradas.add(lugar);

      if (misCartasInvolucradas.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('¡Tienes que enseñar una carta!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            content: Text('$acusador está preguntando por $sospechoso, $arma y $lugar.\n\nTienes estas opciones. Elige cuál enseñarle en secreto:'),
            actionsAlignment: MainAxisAlignment.center,
            actions: misCartasInvolucradas.map((carta) => ElevatedButton(
              onPressed: () {
                Navigator.pop(context); 
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PantallaMostrarCarta(
                    carta: carta,
                    archivoImagen: _obtenerNombreArchivo(carta), 
                  )
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade900, foregroundColor: Colors.white),
              child: Text(carta),
            )).toList(),
          )
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('¡No tienes nada!', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
            content: Text('$acusador está preguntando por $sospechoso, $arma y $lugar.\n\nNo tienes ninguna de estas cartas en tu mano, así que pasas automáticamente.'),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  _siguienteTurno(turnoActual, turnoFinal, acusador, sospechoso, arma, lugar);
                },
                child: const Text('Continuar', style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          )
        );
      }

    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('Turno de $jugadorResponde', style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Sugerencia: $sospechoso, $arma, $lugar\n\n¿Qué hizo $jugadorResponde?'),
          actions: [
            TextButton(
              onPressed: () {
                _guardarEstado(); 
                setState(() {
                  _estadoCasillas["${jugadorResponde}_$sospechoso"] = 1; 
                  _estadoCasillas["${jugadorResponde}_$arma"] = 1;
                  _estadoCasillas["${jugadorResponde}_$lugar"] = 1;
                  _revisarDeducciones();
                });
                Navigator.pop(context);
                _siguienteTurno(turnoActual, turnoFinal, acusador, sospechoso, arma, lugar);
              },
              child: const Text('PASÓ (Poner X)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                if (soyYoElAcusador) {
                  _dialogoQueCartaMeEnsenaron(jugadorResponde, sospechoso, arma, lugar);
                } else {
                  _guardarEstado(); 
                  setState(() {
                    _deduccionesPendientes.add({'jugador': jugadorResponde, 'cartas': [sospechoso, arma, lugar]});
                    for (String carta in [sospechoso, arma, lugar]) {
                      String clave = "${jugadorResponde}_$carta";
                      if (_estadoCasillas[clave] == null || _estadoCasillas[clave] == 0) _estadoCasillas[clave] = 3; 
                    }
                    _revisarDeducciones();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deducción guardada automáticamente para $jugadorResponde (❓)')));
                }
              },
              child: const Text('ENSEÑÓ CARTA', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        )
      );
    }
  }

  void _siguienteTurno(int turnoActual, int turnoFinal, String acusador, String sospechoso, String arma, String lugar) {
    int next = (turnoActual + 1) % widget.jugadores.length;
    _procesarTurno(next, turnoFinal, acusador, sospechoso, arma, lugar);
  }

  void _dialogoQueCartaMeEnsenaron(String jugador, String sospechoso, String arma, String lugar) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('¿Qué te enseñó $jugador?', style: const TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Como tú preguntaste, tienes que haber visto la carta.'),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(onPressed: () {
            _guardarEstado(); 
            setState(() { _marcarCartaComoVista(jugador, sospechoso); _revisarDeducciones(); });
            Navigator.pop(context);
          }, child: Text(sospechoso)),
          ElevatedButton(onPressed: () {
            _guardarEstado();
            setState(() { _marcarCartaComoVista(jugador, arma); _revisarDeducciones(); });
            Navigator.pop(context);
          }, child: Text(arma)),
          ElevatedButton(onPressed: () {
            _guardarEstado();
            setState(() { _marcarCartaComoVista(jugador, lugar); _revisarDeducciones(); });
            Navigator.pop(context);
          }, child: Text(lugar)),
        ],
      )
    );
  }

  Widget _buildDropdownItemTexto(String carta) {
    String miNombre = widget.jugadores[0].nombre;
    String dueno = "";

    for (var j in widget.jugadores) {
      if (_estadoCasillas["${j.nombre}_$carta"] == 2) {
        dueno = j.nombre;
        break;
      }
    }

    if (dueno == miNombre) {
      return Text("$carta (Tuyo)", style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold));
    } else if (dueno.isNotEmpty) {
      return Text("$carta (De $dueno)", style: TextStyle(color: Colors.red.shade700, fontStyle: FontStyle.italic));
    } else {
      bool todosX = true;
      for (var j in widget.jugadores) {
        if (_estadoCasillas["${j.nombre}_$carta"] != 1) {
          todosX = false;
          break;
        }
      }
      if (todosX) {
        return Text("$carta (¡SOBRE!)", style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.bold));
      }
      return Text(carta, style: const TextStyle(color: Colors.black87));
    }
  }

  void _mostrarMenuAcusacion() {
    HapticFeedback.mediumImpact();
    String jugadorSeleccionado = widget.jugadores[0].nombre; 
    String sospechosoSeleccionado = sospechosos.first;
    String armaSeleccionada = armas.first;
    String lugarSeleccionado = lugares.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Nueva Sugerencia', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: '¿Quién pregunta?', border: OutlineInputBorder()),
                    value: jugadorSeleccionado,
                    items: widget.jugadores.map((j) => DropdownMenuItem(value: j.nombre, child: Text(j.nombre))).toList(),
                    onChanged: (val) => setModalState(() => jugadorSeleccionado = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Sospechoso', border: OutlineInputBorder()),
                    value: sospechosoSeleccionado,
                    items: sospechosos.map((s) => DropdownMenuItem(value: s, child: _buildDropdownItemTexto(s))).toList(),
                    onChanged: (val) => setModalState(() => sospechosoSeleccionado = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Arma', border: OutlineInputBorder()),
                    value: armaSeleccionada,
                    items: armas.map((a) => DropdownMenuItem(value: a, child: _buildDropdownItemTexto(a))).toList(),
                    onChanged: (val) => setModalState(() => armaSeleccionada = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Lugar', border: OutlineInputBorder()),
                    value: lugarSeleccionado,
                    items: lugares.map((l) => DropdownMenuItem(value: l, child: _buildDropdownItemTexto(l))).toList(),
                    onChanged: (val) => setModalState(() => lugarSeleccionado = val!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context); 
                        _iniciarRondaRespuestas(jugadorSeleccionado, sospechosoSeleccionado, armaSeleccionada, lugarSeleccionado);
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Iniciar Ronda', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _clasificarCartas();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final bool? confirmar = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¿Abandonar partida?', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Si sales ahora perderás todo el progreso y las deducciones de esta partida. ¿Estás seguro?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sí, salir'),
              ),
            ],
          ),
        );
        if (confirmar == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Tablero de Deducción', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: 'Deshacer (Misclick)',
              onPressed: _historialEstados.isNotEmpty ? _deshacer : null,
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _construirBarraAsesinato(),
                const SizedBox(height: 2),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildColumnaFija(),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildColumnasJugadores(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: _posicionBoton.dx,
              top: _posicionBoton.dy,
              child: Draggable(
                feedback: FloatingActionButton.extended(
                  onPressed: () {},
                  icon: const Icon(Icons.psychology),
                  label: const Text('Sugerencia'),
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                ),
                childWhenDragging: Container(),
                onDraggableCanceled: (velocity, offset) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _posicionBoton = Offset(offset.dx, offset.dy - 80);
                  });
                },
                child: FloatingActionButton.extended(
                  onPressed: _mostrarMenuAcusacion,
                  icon: const Icon(Icons.psychology),
                  label: const Text('Sugerencia', style: TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: Colors.blue.shade800,
                  foregroundColor: Colors.white,
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}