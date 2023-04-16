import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/reclamo_fire_controller.dart';

class ReclamoListView extends StatefulWidget {
  const ReclamoListView({super.key});

  @override
  State<ReclamoListView> createState() => _ReclamoListViewState();
}

class _ReclamoListViewState extends State<ReclamoListView> {
  var reclamosService = FirebaseReclamo();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Lista de Reclamos')),
        body: FutureBuilder(
          future: reclamosService.getReclamos(),
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
                        subtitle: Text(snapshot.data[index]['descripcion']),
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
        ));
  }
}
