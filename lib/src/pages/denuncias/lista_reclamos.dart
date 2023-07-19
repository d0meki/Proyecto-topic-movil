import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; //para el uso de Timestamp formato de fechas aceptadas en firebase
import 'package:topicos_proy/src/Controllers/reclamoService.dart'; //CONTROLADOR DONNDE CONSUMIMOS LAS APIS

class ReclamoListView extends StatefulWidget {
  const ReclamoListView({super.key});

  @override
  State<ReclamoListView> createState() => _ReclamoListViewState();
}

class _ReclamoListViewState extends State<ReclamoListView> {
  var reclamosService = ServiceReclamo();
  late Future<List<dynamic>> lista;
  @override
  void initState() {
    // lista = reclamosService.getReclamos();
    lista = reclamosService.getReclamosPorUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Lista de Reclamos'),
          leading: IconButton(
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
            if (snapshot.data.length > 0) {
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
            }else{
             return const Center(child: Text('No hay registros'),);
            }
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
            width: 90, // Ajusta el ancho del botón según tus necesidades
            height: 50,
            child: FloatingActionButton.extended(
              heroTag: 1,
              onPressed: () {
                filtrarPorEstado(context);
              },
              shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              label: const Text('Estado'),
              backgroundColor: Colors.lightBlueAccent,
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
                filtrarPorCategoria(context);
              },
              shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              label: const Text('Categoria'),
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            width: 90, // Ajusta el ancho del botón según tus necesidades
            height: 50, // Ajusta la altura del botón según tus necesidades
            child: FloatingActionButton.extended(
              heroTag: 3,
              onPressed: () {
                _showDatePicker();
              },
              shape:const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0.0)),
              ),
              label: const Text('Fecha'),
              backgroundColor: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }

//METODOS DE FILTRADO
  Future<dynamic> filtrarPorCategoria(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Categorias'),
            content: SizedBox(
                height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: StreamBuilder(
                  stream: reclamosService.categorias.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final cates = snapshot.data?.docs.reversed.toList();
                      return Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cates?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ListTile(
                                title: Text(cates?[index]['nombre']),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                lista = reclamosService.getReclamoCategoria(
                                    cates?[index]['nombre']);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
          );
        });
  }

  Future<dynamic> filtrarPorEstado(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Estados'),
            content: SizedBox(
                height: 150.0, // Change as per your requirement
                width: 250.0, // Change as per your requirement
                child: StreamBuilder(
                  stream: reclamosService.estados.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final estados = snapshot.data?.docs.reversed.toList();
                      return Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: estados?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: ListTile(
                                title: Text(estados?[index]['nombre']),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                lista = reclamosService.getReclamoEstado(
                                    estados?[index]['nombre']);
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
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
    setState(() {});
  }
}
