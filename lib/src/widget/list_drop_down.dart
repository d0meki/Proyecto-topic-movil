import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/reclamoService.dart';

class MiWidget extends StatelessWidget {
   var reclamoService = ServiceReclamo();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: reclamoService.getCategorias(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error al obtener los datos');
        } else {
          List<String>? datos = snapshot.data;

          return DropdownButton<String>(
            value: null, // Valor inicial seleccionado (puedes establecerlo si deseas)
            hint: Text('Selecciona una opción'), // Texto inicial del DropdownButton
            items: datos?.map((String opcion) {
              return DropdownMenuItem<String>(
                value: opcion,
                child: Text(opcion),
              );
            }).toList(),
            onChanged: (String? seleccion) {
              // Este callback se ejecuta cuando se selecciona una opción
              // Aquí puedes realizar cualquier acción adicional con la opción seleccionada
              print('Seleccionaste: $seleccion');
            },
          );
        }
      },
    );
  }
}
