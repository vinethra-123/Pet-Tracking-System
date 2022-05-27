import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:pet_track/data/firestore.dart';
import 'package:pet_track/data/shop.dart';
import 'package:maps_launcher/maps_launcher.dart';

class PetFoodTab extends StatefulWidget {
  const PetFoodTab({Key? key}) : super(key: key);

  @override
  _PetFoodTabState createState() => _PetFoodTabState();
}

class _PetFoodTabState extends State<PetFoodTab> {
  late SearchBar searchBar;
  String query = "";

  _initSearchBar() => searchBar = SearchBar(
        inBar: false,
        setState: setState,
        onCleared: () => setState(() => query = ""),
        onChanged: (val) => setState(() => query = val),
        onSubmitted: (val) => setState(() => query = val),
        buildDefaultAppBar: buildAppBar,
      );

  @override
  void initState() {
    _initSearchBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: SafeArea(
        child: StreamBuilder<List<Shop>>(
            stream: Firestore.getShops(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(strokeWidth: 1));
              }
              if (snapshot.connectionState == ConnectionState.done) {}
              List<Shop> filtered = (snapshot.data ?? []);
              if (query.isNotEmpty) {
                filtered = (snapshot.data ?? [])
                    .where(
                        (element) => element.name.toLowerCase().contains(query))
                    .toList();

                if (filtered.isEmpty) {
                  return ListTile(
                    title: Text("Not found matching $query"),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => query = ""),
                    ),
                  );
                }
              }
              return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    Shop shop = filtered[i];
                    return ListTile(
                      leading: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            shop.image,
                            fit: BoxFit.cover,
                          )),
                      title: Text(shop.name),
                      subtitle: Text(shop.description),
                      trailing: IconButton(
                        icon: const Icon(Icons.open_in_new_rounded),
                        onPressed: () => MapsLauncher.launchCoordinates(
                          shop.location.latitude,
                          shop.location.longitude,
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        title: const Text('Pet Food Shops'),
        automaticallyImplyLeading: false,
        elevation: 1,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
        backgroundColor: Colors.blueAccent,
        actions: [searchBar.getSearchAction(context)]);
  }
}
