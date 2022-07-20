import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import '../../../shared/utils/database_helper.dart';

import '../../../shared/widgets/input_text_container.dart';
import 'toggle_buttons_register.dart';

class BodyRegister extends StatefulWidget {
  const BodyRegister({
    Key? key,
  }) : super(key: key);

  @override
  State<BodyRegister> createState() => _BodyRegisterState();
}

class _BodyRegisterState extends State<BodyRegister> {
  final List<bool> isSelected = [false, false];

  final TextEditingController operationName = TextEditingController();

  final TextEditingController price = TextEditingController();

  String category = '';
  bool categorySelected = false;

  TextEditingController data = TextEditingController();

  void cleanEntries() {
    isSelected[0] = false;
    isSelected[1] = false;
    category = '';
    categorySelected = false;
    operationName.clear();
    price.clear();
    data.clear();
    setState(() {});
  }

  int getOperation() {
    if (isSelected[0]) {
      return 1;
    } else if (isSelected[1]) {
      return 0;
    }
    return -1;
  }

  String formatDate(String date) {
    List temp = date.split('-');
    return temp.length == 3
        ? ('${temp[2]}-${temp[1]}-${temp[0]}')
        : 'Data inválida!';
  }

  void save() async {
    if (operationName.text == '' ||
        price.text == '' ||
        getOperation() == -1 ||
        categorySelected ||
        data.text == '') {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Informações inválidas!'),
            content: const Text('Você não pode deixar nenhum campo em branco.'),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(238, 46, 93, 1)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Ok',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        },
      );
    } else {
      String name = operationName.text;
      double value = double.parse(price.text);
      int operation = getOperation();
      String date = formatDate(data.text);
      int categoryId = await DatabaseHelper.instance.selectCategory(category);
      DatabaseHelper.instance
          .insertOperation(value, name, operation, date, categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInputContainer(
          textValue: 'Nome',
          controller: operationName,
        ),
        TextInputContainer(
          textValue: 'Preço',
          controller: price,
          type: const TextInputType.numberWithOptions(),
          numericFormatter: true,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ToggleButtonsRegister(isSelected: isSelected),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          // child: DropdownButtonHideUnderline(
<<<<<<< HEAD
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.queyCategory(),
            builder: (
              context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
            ) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(

                hint: categorySelected ? null : const Text('Selecione uma categoria!'),
                // disabledHint: Text(category),
                value: categorySelected ? category : null,

                items: snapshot.data!
                    .map<DropdownMenuItem<String>>(
                      (Map<String, dynamic> value) => DropdownMenuItem<String>(
                        value: value['name'],
                        child: Text(
                          value['name'],
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    categorySelected = true;
                    category = newValue!;
                  });
                },
              ));
            },
=======
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: category,
              items: options
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  category = newValue!;
                });
              },
            ),
>>>>>>> 8284decb378809dba1417f72ac02efaafbb05692
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DateTimePicker(
            controller: data,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            dateLabelText: 'Data',
            locale: const Locale('pt', 'BR'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                cleanEntries();
                setState(() {});
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade400)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: const Text(
                  'Limpar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                save();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(238, 46, 93, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                child: const Text(
                  'Enviar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}