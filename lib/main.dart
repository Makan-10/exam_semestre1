import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      backgroundColor: Colors.blue[50],
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
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
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
                          borderRadius: BorderRadius.circular(15)),
                      prefixIcon: Icon(Icons.lock),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: InkWell(
                        child: visibilite
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onTap: () {
                          setState(() {
                            visibilite = !visibilite;
                          });
                        },
                      ),
                    ),
                  ),
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
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    backgroundColor: Colors.blue[400],
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Connexion',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
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
  List<String> board = List.filled(9, "");
  bool isXTurn = true;
  int xPions = 0;  // Nombre de pions placés pour X
  int oPions = 0;  // Nombre de pions placés pour O
  int scoreX = 0;  // Score de X
  int scoreO = 0;  // Score de O
  int? selectedTile;  // Pour gérer la sélection d'un pion à déplacer
  bool canMove = false; // Pour savoir si un pion peut être déplacé
  bool gameOver = false; // Pour savoir si le jeu est terminé

  void _resetBoard() {
    setState(() {
      board = List.filled(9, "");
      selectedTile = null;
      xPions = 0;
      oPions = 0;
      canMove = false;
      gameOver = false;
    });
  }

  void _onTileTap(int index) {
    if (gameOver) return;

    // Si un pion est sélectionné et la case est vide, on déplace le pion
    if (selectedTile != null && board[index] == "" && canMove) {
      setState(() {
        board[index] = board[selectedTile!];
        board[selectedTile!] = "";
        selectedTile = null;
        isXTurn = !isXTurn;  // Change de joueur après le déplacement
        if (_checkWinner() != null) {
          gameOver = true;
        }
      });
    } 
    // Si aucun pion n'est sélectionné, et la case est vide, le joueur place un pion
    else if (selectedTile == null && board[index] == "" && (isXTurn && xPions < 3 || !isXTurn && oPions < 3)) {
      setState(() {
        board[index] = isXTurn ? "X" : "O";
        if (isXTurn) {
          xPions++;
        } else {
          oPions++;
        }
        isXTurn = !isXTurn;
        if (xPions == 3 && oPions == 3) {
          canMove = true; // Permet de commencer à déplacer les pions après les 3 pions de chaque joueur
        }
      });
    }
    // Si une case est tapée, sélectionner le pion à déplacer
    else if (board[index] != "" && selectedTile == null && canMove) {
      setState(() {
        selectedTile = index;  // Sélectionne le pion à déplacer
      });
    }

    // Vérifier si un joueur a gagné après chaque mouvement
    String? winner = _checkWinner();
    if (winner != null) {
      if (winner == "X") {
        setState(() {
          scoreX++;  // Incrémenter le score de X
        });
      }
      if (winner == "O") {
        setState(() {
          scoreO++;  // Incrémenter le score de O
        });
      }
      _showWinnerDialog(winner);
    }
  }

  String? _checkWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];
    for (var pattern in winPatterns) {
      if (board[pattern[0]] != "" &&
          board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]]) {
        return board[pattern[0]];
      }
    }
    if (!board.contains("")) return "Égalité";
    return null;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(winner == "Égalité" ? "Match nul!" : "Le gagnant est $winner!"),
        actions: [
          TextButton(
            child: Text("Rejouer", style: TextStyle(color: Colors.blue)),
            onPressed: () {
              _resetBoard();
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jeu de Morpion", style: TextStyle(fontSize: 22)),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage du score de chaque joueur
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Score - X: $scoreX | O: $scoreO",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              shrinkWrap: true,
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(index),
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: selectedTile == index ? Colors.blue[300] : Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)
                      ],
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
