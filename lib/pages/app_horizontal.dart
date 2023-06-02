import 'package:flutter/material.dart';
import 'left_panel.dart';
import 'right_panel.dart';
class MiAplicacion extends StatefulWidget {
  @override
  State<MiAplicacion> createState() => _MiAplicacionState();
}

class _MiAplicacionState extends State<MiAplicacion> {
  RightPanel r=RightPanel();
  LeftPanel l=LeftPanel();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicacion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Mi Aplicacion'),
          ),
          endDrawer: MediaQuery.of(context).size.width < 600 ? _buildDrawer(context) : null,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Si el ancho de la pantalla es mayor a 600, muestra el diseño horizontal
                return _buildHorizontalLayout();
              } else {
                // Si el ancho de la pantalla es menor o igual a 600, muestra solo el panel izquierdo
                return _buildOnlyLeftPanel();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        Expanded(
          child: l,
        ),
        Expanded(
          child: r,
        ),
      ],
    );
  }

  Widget _buildOnlyLeftPanel() {
    return l;
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        child: r
    );
  }

}