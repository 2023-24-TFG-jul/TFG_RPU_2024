import 'package:flutter/material.dart';
import 'package:kairos/views/view_auctions.dart';
import 'view_watches.dart';
import 'view_price_watch.dart';
import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final String loginUserEmail = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Center(
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
                'Welcome, $loginUserEmail',
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
                        settings: RouteSettings(arguments: loginUserEmail),
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewAuctions(),
                        settings: RouteSettings(arguments: loginUserEmail),
                      ),
                    );
                  },
                  child: const Text('See the auctions'),
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
                        builder: (context) => const ViewPriceWatch(),
                      ),
                    );
                  },
                  child: const Text('How much is my watch worth?'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // COSAS
                  },
                  child: const Text('Update your personal data'),
                ),
              ),
            ],
          ),
        ),
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
