import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeu de Morpion',
      debugShowCheckedModeBanner: false,
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
      backgroundColor: Color.fromARGB(255, 186, 187, 184),
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
                      hintText: "Login",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                      obscureText: visibilite,
                      controller: password,
                      decoration: InputDecoration(
                          hintText: "Mot de passe",
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
                              "veuillez entrez le login ou le mot de passe")));
                    }
                    if (email.text == "makan@.com" &&
                        password.text == "123") {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return TicTacToe();
                      }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("login ou mot de passe incorrect")));
                    }
                    print('connection');
                  },
                  child: Text('connection'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> _board = [
    ['', '', ''],
    ['', '', ''],
    ['', '', '']
  ];

  String _currentPlayer = 'X'; // Le joueur courant
  String _winner = ''; // Le gagnant, si il y en a un
  bool _gameOver = false; // Si le jeu est terminé ou non

  // Fonction pour gérer les mouvements
  void _makeMove(int row, int col) {
    if (_board[row][col] == '' && !_gameOver) {
      setState(() {
        _board[row][col] = _currentPlayer;
        _checkWinner();
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
      });
    }
  }

  // Fonction pour vérifier si un joueur a gagné
  void _checkWinner() {
    // Vérifier les lignes et les colonnes
    for (int i = 0; i < 3; i++) {
      if (_board[i][0] == _board[i][1] && _board[i][1] == _board[i][2] && _board[i][0] != '') {
        _winner = _board[i][0];
        _gameOver = true;
        return;
      }
      if (_board[0][i] == _board[1][i] && _board[1][i] == _board[2][i] && _board[0][i] != '') {
        _winner = _board[0][i];
        _gameOver = true;
        return;
      }
    }
    // Vérifier les diagonales
    if (_board[0][0] == _board[1][1] && _board[1][1] == _board[2][2] && _board[0][0] != '') {
      _winner = _board[0][0];
      _gameOver = true;
      return;
    }
    if (_board[0][2] == _board[1][1] && _board[1][1] == _board[2][0] && _board[0][2] != '') {
      _winner = _board[0][2];
      _gameOver = true;
      return;
    }
    // Vérifier si la grille est pleine sans gagnant
    bool isFull = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i][j] == '') {
          isFull = false;
        }
      }
    }
    if (isFull) {
      _gameOver = true;
    }
  }

  // Fonction pour réinitialiser le jeu
  void _resetGame() {
    setState(() {
      _board = [
        ['', '', ''],
        ['', '', ''],
        ['', '', '']
      ];
      _currentPlayer = 'X';
      _winner = '';
      _gameOver = false;
    });
  }

  // Widget pour afficher la grille de jeu
  Widget _buildBoard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (col) {
            return GestureDetector(
              onTap: () => _makeMove(row, col),
              child: Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    _board[row][col],
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  // Widget pour afficher le message de fin de jeu
  Widget _buildGameOverMessage() {
    String message = '';
    if (_winner != '') {
      message = 'Le joueur $_winner a gagné !';
    } else {
      message = 'Match nul !';
    }

    return Column(
      children: [
        Text(
          message,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _resetGame,
          child: Text('Rejouer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jeu de Morpion Makan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBoard(),
            SizedBox(height: 20),
            _gameOver ? _buildGameOverMessage() : Text(
              'C\'est au tour de $_currentPlayer',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
