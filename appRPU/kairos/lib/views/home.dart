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
    int walletAmount = await userRepository.getWalletByEmail(widget.loginUserEmail);
    return walletAmount.toString();
  }

  void _reloadHomeData() {
    setState(() {
      _walletFuture = _getWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome, ${widget.loginUserEmail}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewWatches(),
                            settings: RouteSettings(arguments: widget.loginUserEmail),
                          ),
                        );
                      },
                      child: const Text('Consult your watches'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ViewAuctions(),
                            settings: RouteSettings(arguments: widget.loginUserEmail),
                          ),
                        );

                        if (result != null && result == true) {
                          _reloadHomeData();
                        }
                      },
                      child: const Text('See the auctions'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const ViewPriceWatch(),
                        //   ),
                        // );
                      },
                      child: const Text('How much is my watch worth?'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateUser(userEmail: widget.loginUserEmail),
                          ),
                        );
                      },
                      child: const Text('Update your personal data'),
                    ),
                  ),
                ],
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Wallet: Loading...',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text(
                      'Wallet: Error',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Text(
                      'Wallet: ${snapshot.data} €',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
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
        icon: const Icon(Icons.logout),
      ),
    );
  }
}
