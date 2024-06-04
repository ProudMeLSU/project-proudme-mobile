import 'package:flutter/material.dart';
import 'package:project_proud_me/constant.dart';
import 'package:project_proud_me/language.dart';

class ScreenTimeCard extends StatefulWidget {
  @override
  _ScreenTimeCardState createState() => _ScreenTimeCardState();
}

class _ScreenTimeCardState extends State<ScreenTimeCard> {
  String _selectedScreenTimeType = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        child: Column(
                          children: [
                            Text(
                              'Screen Time Type',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  labelText: 'Select screen time type.'),
                              onChanged: (value) {
                                setState(() {
                                  _selectedScreenTimeType = value!;
                                });
                              },
                              items: screenTimeType
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Set My Goal',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Hours'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Minutes'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Track My Behaviour',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Hours'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.remove),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Minutes'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.add),
                                    color: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Reflect',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                  labelText: 'Type my thoughts'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const Divider(
                thickness: 1,
                color: Colors.black,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.desktop_windows_outlined,
                          color: secondaryColor,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          myJournalItems[1],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: fontFamily,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(myJournalItems[1]),
                                content: const Text(
                                  screenTimeInfo,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.info),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            const Color(0xfff5b342)),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
