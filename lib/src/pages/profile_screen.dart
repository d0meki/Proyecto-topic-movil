import 'package:flutter/material.dart';
import 'package:topicos_proy/src/Controllers/usuario_controller.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
  var firebaseUsuario = FirebaseUsuario();
  @override
  Widget build(BuildContext context) {
    dynamic uuid = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
                'login', (Route<dynamic> route) => false);
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[800],
      body: SafeArea(
          child: FutureBuilder(
        future: firebaseUsuario.getUserWhitUuid(uuid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(snapshot.data['avatar']),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  snapshot.data['name'],
                  style: const TextStyle(
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nisebuschgardens',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Usuario: Ciudadano",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.blueGrey[200],
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Source Sans Pro"),
                ),
                const SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                // we will be creating a new widget name info carrd

                InfoCard(text: snapshot.data['telefono'], icon: Icons.phone),
                InfoCard(text: snapshot.data['ci'], icon: Icons.web),
                InfoCard(
                  text: snapshot.data['pin'],
                  icon: Icons.location_city,
                ),
                InfoCard(text: snapshot.data['email'], icon: Icons.email),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),

      floatingActionButton: Column(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [
            FloatingActionButton.extended(
              heroTag: 1,
          onPressed: () {
            Navigator.pushNamed(context, "reclamo");
          },
          label: const Text('Hacer un Reclamo'),
          icon: const Icon(Icons.thumb_up),
          backgroundColor: Colors.pink,
        ),
        const SizedBox(height: 5,),
        FloatingActionButton.extended(
          heroTag: 2,
          onPressed: () {
            Navigator.pushNamed(context, "lista_reclamos");
          },
          label: const Text('Ver Reclamos'),
          icon: const Icon(Icons.remove_red_eye),
          backgroundColor: Colors.pink,
        ),
         ],
        
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  // the values we need
  final String text;
  final IconData icon;
  const InfoCard({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.teal,
          ),
          title: Text(
            text,
            style: const TextStyle(
                color: Colors.teal,
                fontSize: 20,
                fontFamily: "Source Sans Pro"),
          ),
        ),
      ),
    );
  }
}
