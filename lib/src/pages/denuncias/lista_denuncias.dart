import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ListaDenuncias extends StatefulWidget {
  const ListaDenuncias({super.key});

  @override
  State<ListaDenuncias> createState() => _ListaDenunciasState();
}

class _ListaDenunciasState extends State<ListaDenuncias> {
  final _listaDenuncias = [
    "Lista 1",
    "Lista 2",
    "Lista 3",
    "Lista 4",
    "Lista 5",
    "Lista 6"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Denuncias')),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _listaDenuncias.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BounceInLeft(
                  delay: const Duration(milliseconds: 500),
                  child: Stack(children: <Widget>[
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromARGB(255, 7, 255, 238),
                                blurRadius: 12,
                                offset: Offset(0, 6))
                          ]),
                    ),
                    ListTile(
                      title: Text('Entry ${_listaDenuncias[index]}'),
                      trailing: Icon(Icons.abc),
                      onTap: () {
                        print("Ver detalle");
                      },
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}

class CustomCardShapePainter extends CustomPainter {
  final Color startColor;
  final Color endColor;
  final double radius;

  CustomCardShapePainter(this.startColor, this.endColor, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    var radius = 24.0;
    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
