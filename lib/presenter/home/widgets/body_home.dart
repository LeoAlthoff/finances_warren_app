import 'package:flutter/material.dart';
import '../../../shared/utils/database_helper.dart';

import '../../../config.dart';
import 'balance_container.dart';
import 'main_container_home.dart';

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 5),
              children: [
                MainContainerHome(
                  index: 1,
                  subText: 'Última entrada dia 1º de julho',
                  value: 18000,
                ),
                MainContainerHome(
                  index: 2,
                  subText: 'Última entrada dia 22 de junho',
                  value: 870,
                ),
                MainContainerHome(
                  index: 3,
                  subText: '1º à 31 de julho',
                  value: 17130,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Extrato',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
            future: DatabaseHelper.instance.selectContainer(),
            builder: ((context,
                AsyncSnapshot<Map<String, List<Map<String, dynamic>>>>
                    snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!['operation']!.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!['operation'] == null) {
                    return const Center(
                      child: Text('Nenhuma operação cadastrada'),
                    );
                  }
                  return BalanceContainer(
                    expense: snapshot.data!['operation']![index]['entry'] == 1
                        ? false
                        : true,
                    origin: snapshot.data!['operation']![index]['name'],
                    value: snapshot.data!['operation']![index]['value'],
                    icon: IconData(
                        snapshot.data!['category']![
                            snapshot.data!['operation']![index]['categoryId'] -
                                1]['icon'],
                        fontFamily: 'MaterialIcons'),
                    source: snapshot.data!['category']![
                        snapshot.data!['operation']![index]['categoryId'] -
                            1]['name'],
                    time: snapshot.data!['operation']![index]['date'],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
