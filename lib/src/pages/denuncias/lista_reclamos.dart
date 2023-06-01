import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';

class ReclamoListView extends StatefulWidget {
  const ReclamoListView({super.key});

  @override
  State<ReclamoListView> createState() => _ReclamoListViewState();
}
class _ReclamoListViewState extends State<ReclamoListView> {
  var reclamosService = FirebaseReclamo();
  late Future<List<dynamic>> lista;
  @override
  void initState() {
    lista = reclamosService.getReclamos();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Reclamos'), 
      leading:  IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "home");
            },
            icon: const Icon(Icons.home)),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "reclamo");
            },
            icon: const Icon(Icons.add))
      ]),
      //LISTA O HISTORIA DE RECLAMO
      body: FutureBuilder(
        future: lista,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 5,
                  thickness: 0.5,
                );
              },
              itemBuilder: (context, index) {
                if (snapshot.data.isNotEmpty) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      //set border radius more than 50% of height and width to make circle
                    ),
                    child: ListTile(
                      title: Text(snapshot.data[index]['categoria']),
                      subtitle: Text(
                          '${snapshot.data[index]['estado']}\n${snapshot.data[index]['fecha'].toDate().toString()}'),
                      trailing: Icon(Icons.arrow_forward_ios_rounded),
                      onTap: (() {
                        Navigator.pushNamed(context, 'detalle_reclamo',
                            arguments: snapshot.data[index].id);
                      }),
                      //TODO: SE PUEDE COLOCAR IMAGEN CON leading
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      //BOTONES DE FILTRADO
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 60, // Ajusta el ancho del botón según tus necesidades
            height: 50,
            child: FloatingActionButton.extended(
              heroTag: 1,
              onPressed: () {
                List<String> listaEstados = [
                  "pendiente",
                  "En proceso",
                  "terminado",
                ];
                filtrarPorEstado(context, listaEstados);
              },
              label: const Text('Estado'),
              backgroundColor: Colors.pink,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 90, // Ajusta el ancho del botón según tus necesidades
            height: 50,
            child: FloatingActionButton.extended(
              heroTag: 2,
              onPressed: () async {
                List<String> listaCategorias = [
                  "Caminos",
                  "Seguridad",
                  "Basuras",
                  "Alumbrado",
                  "Otros"
                ];
                filtrarPorCategoria(context, listaCategorias);
              },
              label: const Text('Categoria'),
              backgroundColor: Colors.pink,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 50, // Ajusta el ancho del botón según tus necesidades
            height: 50, // Ajusta la altura del botón según tus necesidades
            child: FloatingActionButton.extended(
              heroTag: 3,
              onPressed: () {
                _showDatePicker();
              },
              label: const Text('Fecha'),
              backgroundColor: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

//METODOS DE FILTRADO
  Future<dynamic> filtrarPorCategoria(BuildContext context, List<String> listaCategorias) {
    return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Categorias'),
                      content: SizedBox(
                        height: 300.0, // Change as per your requirement
                        width: 300.0, // Change as per your requirement
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listaCategorias.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ListTile(
                                title: Text(listaCategorias[index]),
                              ),
                              onTap: () {
                                // print(listaCategorias[index]);
                                Navigator.pop(context);
                                lista = reclamosService.getReclamoCategoria(
                                    listaCategorias[index]);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    );
                  });
  }

  Future<dynamic> filtrarPorEstado(BuildContext context, List<String> listaEstados) {
    return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Estados'),
                      content: SizedBox(
                        height: 150.0, // Change as per your requirement
                        width: 250.0, // Change as per your requirement
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listaEstados.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ListTile(
                                title: Text(listaEstados[index]),
                              ),
                              onTap: () {
                                // print(listaCategorias[index]);
                                Navigator.pop(context);
                                lista = reclamosService
                                    .getReclamoEstado(listaEstados[index]);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    );
                  });
  }

  void _showDatePicker() async {
     DateTimeRange dateRAnge =
      DateTimeRange(start: DateTime(2023, 05, 28), end: DateTime.now());
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRAnge,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (newDateRange == null) return;
    DateTime start = newDateRange.start;
    DateTime end = newDateRange.end.add(const Duration(minutes: 1439));
    Timestamp timestampStart = Timestamp.fromDate(start);
    Timestamp timestampEnd = Timestamp.fromDate(end);
    lista = reclamosService.getReclamoFecha(timestampStart, timestampEnd);
    setState(() {
    });
  }
}
