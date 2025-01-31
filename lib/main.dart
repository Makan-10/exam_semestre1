import 'package:flutter/material.dart';

void main() {
  runApp(Exam_Makan());
}

class Exam_Makan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dessin App Makan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: login(),
    );
  }
}
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool visibilite = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(61, 3, 24, 17),

      body: Padding(
        padding: EdgeInsets.only(top: 25),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset("assets/login.jpg"),
                    
                  ),
                ), 
                Padding(
                  
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Entrez votre email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.mail),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      obscureText: visibilite,
                      controller: password,
                      decoration: InputDecoration(
                          hintText: "Entrez votre mot de passe",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                              
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: InkWell(
                            child: visibilite
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onTap: () {
                              visibilite = !visibilite;
                              setState(() {});
                            },
                          ))),
                ),
                OutlinedButton(
                  onPressed: () {
                    if (email.text.isEmpty || password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "veuillez entrez l'email ou le mot de passe")));
                    }
                    if (email.text == "makan@.com" &&
                        password.text == "123") {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Home();
                      }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("l'email ou mot de passe incorrect")));
                    }
                    print('connection');
                  },
                  
                  child: Text('connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(61, 3, 24, 17),

                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Offset?> points = [];
  Color selectedColor = Colors.black;
  double strokeWidth = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(image:AssetImage("assets/login.jpg"))
            ),
          ),
          Center(
            child: Text("user@gmail.com"),),
            ListTile(title: Text("Home"),
            leading: Icon(Icons.home),)
        ]
       
      ),
      ),
      appBar: AppBar(
        title: Text('Dessin App Makan',),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null); // Add a null to indicate the end of a stroke
          });
        },
        child: CustomPaint(
          painter: Dessin(points: points, color: selectedColor, strokeWidth: strokeWidth),
          size: Size.infinite,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.color_lens, color: selectedColor),
                onPressed: () async {
                  Color? pickedColor = await showDialog(
                    context: context,
                    builder: (context) => Boite_Selection(selectedColor: selectedColor),
                  );
                  if (pickedColor != null) {
                    setState(() {
                      selectedColor = pickedColor;
                    });
                  }
                },
              ),
              Slider(
                value: strokeWidth,
                min: 1.0,
                max: 10.0,
                onChanged: (value) {
                  setState(() {
                    strokeWidth = value;
                  });
                },
              ),
              Text('Bordure: ${strokeWidth.toInt()}'),
            ],
          ),
        ),
      ),
    );
  }
}

class Dessin extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final double strokeWidth;

  Dessin({required this.points, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Dessin oldDelegate) => true;
}

class Boite_Selection extends StatelessWidget {
  final Color selectedColor;

  Boite_Selection({required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sélectionner votre couleur'),
      content: SingleChildScrollView(
        child: Boite_Couleur(
          pickerColor: selectedColor,
          onColorChanged: (color) {
            Navigator.of(context).pop(color);
          },
        ),
      ),
    );
  }
}

class Boite_Couleur extends StatelessWidget {
  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  Boite_Couleur({required this.pickerColor, required this.onColorChanged});

  final List<Color> colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            onColorChanged(color);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: pickerColor == color ? Colors.grey : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
