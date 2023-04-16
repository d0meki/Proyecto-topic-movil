import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';

class DetalleReclamo extends StatefulWidget {
  const DetalleReclamo({super.key});

  @override
  State<DetalleReclamo> createState() => _DetalleReclamoState();
}

class _DetalleReclamoState extends State<DetalleReclamo> {

  var reclamoService = FirebaseReclamo();
 
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
                                child: Text(snapshot.data['categoria']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(snapshot.data['fecha']),
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
