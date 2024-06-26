import 'package:flutter/material.dart';
import 'package:kairos/views/update_user.dart';
import 'package:kairos/views/view_auctions.dart';
import 'package:kairos/models/user.dart';
import 'view_watches.dart';
import 'login.dart';

class Home extends StatefulWidget {
  final String loginUserEmail;

  const Home({super.key, required this.loginUserEmail});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String> _walletFuture;

  @override
  void initState() {
    super.initState();
    _walletFuture = _getWallet();
  }

  Future<String> _getWallet() async {
    UserRepository userRepository = UserRepository();
    int walletAmount =
        await userRepository.getWalletByEmail(widget.loginUserEmail);
    return walletAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLargeScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/kairos_wallpaper.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width > 600 ? 500.0 : 400.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 40.0 : 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome, ${widget.loginUserEmail}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isLargeScreen ? 20.0 : 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewWatches(),
                              settings: RouteSettings(
                                  arguments: widget.loginUserEmail),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          textStyle:
                              TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        ),
                        child: const Text('Consult your watches'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewAuctions(),
                              settings: RouteSettings(
                                  arguments: widget.loginUserEmail),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          textStyle:
                              TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        ),
                        child: const Text('See the auctions'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // SizedBox(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Placeholder for 'How much is my watch worth?' functionality
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       padding: const EdgeInsets.symmetric(vertical: 15.0),
                    //       textStyle:
                    //           TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                    //     ),
                    //     child: const Text('How much is my watch worth?'),
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateUser(userEmail: widget.loginUserEmail),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          textStyle:
                              TextStyle(fontSize: isLargeScreen ? 18.0 : 14.0),
                        ),
                        child: const Text('Update your personal data'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<String>(
                future: _walletFuture,
                builder: (context, snapshot) {
                  return Text(
                    snapshot.hasData ? 'Wallet: ${snapshot.data} €' : '',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.white,
        ),
      ),
    );
  }
}
