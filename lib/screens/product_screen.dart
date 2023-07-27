import 'package:flutter/material.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  const ProductImage(),
                  Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      iconSize: 60,
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 60,
                      ),
                      color: Colors.white,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      iconSize: 60,
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 60,
                      ),
                      color: Colors.white,
                      //TODO: camara o galleria
                      onPressed: () {},
                    ),
                  )
                ],
              ),
              _ProductForm(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_outlined),
        onPressed: () {},
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Producto',
                  labelText: 'Nombre',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150',
                  labelText: 'Precio',
                ),
              ),
              const SizedBox(height: 30),
              SwitchListTile(
                value: true,
                title: const Text('Disponible'),
                onChanged: (value) {
                  //TODO: pendiente
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      );
}
