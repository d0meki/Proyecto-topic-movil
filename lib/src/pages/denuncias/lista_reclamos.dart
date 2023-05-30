import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

class ReclamoListView extends StatefulWidget {
  const ReclamoListView({super.key});

  @override
  State<ReclamoListView> createState() => _ReclamoListViewState();
}

class _ReclamoListViewState extends State<ReclamoListView> {
  var reclamosService = FirebaseReclamo();
  late Future<List<dynamic>> lista;
  DateTimeRange dateRAnge =
      DateTimeRange(start: DateTime(2023, 05, 28), end: DateTime.now());
  @override
  void initState() {
    lista = reclamosService.getReclamos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Reclamos'), actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "reclamo");
            },
            icon: Icon(Icons.add))
      ]),
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
                showDialog(
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
                                  print("estado");
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
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
                showDialog(
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
                                  print("categoria");
                                  setState(() {});
                                },
                              );
                            },
                          ),
                        ),
                      );
                    });
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

                // print(dateRAnge.start);
                // print(dateRAnge.end);
                print("fecha");
              },
              label: const Text('Fecha'),
              backgroundColor: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRAnge,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );
    if (newDateRange == null) return;

    Timestamp timestampStart = Timestamp.fromDate(newDateRange.start);
    Timestamp timestampEnd = Timestamp.fromDate(newDateRange.end);
    lista = reclamosService.getReclamoFecha(timestampStart, timestampEnd);
    setState(() {
      dateRAnge = newDateRange;
    });
  }
}
