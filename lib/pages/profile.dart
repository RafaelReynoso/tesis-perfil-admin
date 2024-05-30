import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
    const Profile({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                    children: [
                        const Expanded(flex: 2, child: _TopPortion()), 
                        Expanded(
                            flex: 3,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    children: [
                                        const Divider(),
                                        Text(
                                            'Chofer: Rafael',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontWeight: FontWeight.normal), // Sin negrita
                                        ),
                                        const Divider(),

                                        /*
                                        Text(
                                            'Nro. de Placa: RIB-342',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontWeight: FontWeight.normal), // Sin negrita
                                        ),
                                        */
                                        const SizedBox(height: 16),
                                        const SizedBox(height: 16),
                                    ],
                                ),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class _TopPortion extends StatelessWidget {
    const _TopPortion();

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                // Añadir el texto "Mi Perfil" en negrita encima de la foto
                const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                        'Mi Perfil',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24, // Puedes ajustar el tamaño de fuente si es necesario
                        ),
                    ),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: 150,
                            height: 150,
                            child: Stack(
                                fit: StackFit.expand,
                                children: [
                                    Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.black,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: AssetImage('assets/user.png'),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ],
        );
    }
}