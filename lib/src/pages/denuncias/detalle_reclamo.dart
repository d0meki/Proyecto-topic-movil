// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';//PARA EL CARRUSEL DE IAMGENES
import 'package:topicos_proy/src/Controllers/reclamoService.dart';//CONTROLADOR DONNDE CONSUMIMOS LAS APIS
import 'package:topicos_proy/src/widget/widgets.dart';// Widgets

class DetalleReclamo extends StatelessWidget {
  DetalleReclamo({super.key});
  var reclamoService = ServiceReclamo();
  @override
  Widget build(BuildContext context) {
    dynamic documentId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
        appBar: AppBar(title: const Center(child: Text("Detalle del Reclamo"))),
        body: FutureBuilder(
          future: reclamoService.getReclamo(documentId),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: SizedBox(
                        width: 380,
                        height: 250,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Categoria: ${snapshot.data['categoria']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('Titulo: ${snapshot.data['titulo']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text('Estado: ${snapshot.data['estado']}'),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    snapshot.data['fecha'].toDate().toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data['descripcion']),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text('FOTOS'),
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: snapshot.data['fotos'].length,
                    options: CarouselOptions(
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                    ),
                    itemBuilder: (ctx, index, realIdx) {
                      return snapshot.data['fotos'].isNotEmpty
                          ? Container(
                              color: Colors.blueGrey,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data['fotos'][index])))))
                          : Container(
                              color: Colors.blueGrey,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey,
                                      image: const DecorationImage(
                                          image: NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKv97i2txLSKTCqwYH-3znwwNtuVQqAS1Xtq377G7r7APyz6IWhUobssxIxG7BKQ8eNhI&usqp=CAU")))),
                            );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (snapshot.data['estado'] == 'pendiente') {
                          await reclamoService.eliminarReclamo(documentId);
                          Navigator.pushNamed(context, "lista_reclamos");
                        } else {
                          Widgets.alertSnackbar(context,
                              "No se puede eliminar un reclamo de estado no pendiente");
                        }
                      },
                      child: Text('Eliminar'))
                ],
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
