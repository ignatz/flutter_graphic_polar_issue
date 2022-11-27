import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildChart('single point', [Data(0, 5, 1)]),
            buildChart('2 points in the same sector at different radiuses',
                [Data(0, 5, 1), Data(0, 6, 2)]),
            buildChart('2 points with different sector and radius',
                [Data(0, 5, 1), Data(1, 6, 2)]),
            buildChart('3 points with different everything',
                [Data(0, 5, 1), Data(1, 6, 2), Data(2, 7, 3)]),
            buildChart('3 points with a duplicate',
                [Data(0, 5, 1), Data(1, 6, 2), Data(1, 6, 2)]),
          ],
        ),
      ),
    );
  }

  Widget buildChart(String name, List<Data> data) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 300, child: Text(name)),
          SizedBox(width: 100),
          Container(
            width: 150,
            height: 150,
            child: Chart(
              data: data,
              variables: {
                'sector': Variable(
                  accessor: (Data d) => d.sector.toString(),
                  scale: OrdinalScale(
                    values: List<int>.generate(10, (i) => i++)
                        .map((s) => s.toString())
                        .toList(),
                  ),
                ),
                'radius': Variable(
                  accessor: (Data d) => d.radius,
                  scale: LinearScale(
                    min: 0,
                    max: 10,
                  ),
                ),
                'value': Variable(
                  accessor: (Data d) => d.value,
                  scale: LinearScale(
                    min: 0,
                    max: 10,
                  ),
                ),
              },
              elements: [
                PolygonElement(
                  shape: ShapeAttr(value: HeatmapShape(sector: true)),
                  color: ColorAttr(
                    variable: 'value',
                    values: [Colors.blue, Colors.red],
                  ),
                )
              ],
              coord: PolarCoord(),
              axes: [
                Defaults.circularAxis,
                Defaults.radialAxis,
              ],
            ),
          ),
        ],
      );
}

class Data {
  final int sector;
  final double radius;
  final double value;

  Data(this.sector, this.radius, this.value);
}
