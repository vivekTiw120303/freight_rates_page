import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FreightRateSearchPage(),
    );
  }
}

class FreightRateSearchPage extends StatefulWidget {
  const FreightRateSearchPage({super.key});

  @override
  _FreightRateSearchPageState createState() => _FreightRateSearchPageState();
}

class _FreightRateSearchPageState extends State<FreightRateSearchPage> {
  bool includeNearbyOriginPorts = false;
  bool includeNearbyDestinationPorts = false;
  bool isFCL = true;
  bool isLCL = false;

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBFF), // Light background
      body: Column(
        children: [
          // Header Section
          Container(
            color: const Color(0x80FFFFFF), // Toolbar background
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Search the best Freight Rates",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A5F),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    // History button action
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    side: const BorderSide(
                      color: Color(0xFF0139FF),
                      width: 1,
                    ),
                    backgroundColor: const Color(0xFFE6EBFF),
                  ),
                  child: const Text(
                    "History",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0139FF),
                    ),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Origin and Destination Fields
                      Row(
                        children: [

                          Expanded(
                            child: AutocompleteField(
                              hint: "Origin",
                              controller: originController,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: AutocompleteField(
                              hint: "Destination",
                              controller: destinationController,
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 8),

                      // Checkboxes
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: includeNearbyOriginPorts,
                                  onChanged: (value) {
                                    setState(() {
                                      includeNearbyOriginPorts = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Include nearby origin ports",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: includeNearbyDestinationPorts,
                                  onChanged: (value) {
                                    setState(() {
                                      includeNearbyDestinationPorts = value!;
                                    });
                                  },
                                ),
                                const Text(
                                  "Include nearby destination ports",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // Commodity and Cut Off Date
                      Row(
                        children: [

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Commodity",
                                hintText: "Type commodity",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Cut Off Date",
                                hintText: "Select date",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF9CA3AF)),
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // Shipment Type and Container Size
                      Row(
                        children: [

                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Shipment Type:",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  children: [

                                    Checkbox(
                                      value: isFCL,
                                      onChanged: (value) {
                                        setState(() {
                                          isFCL = value!;
                                          if (isFCL) isLCL = false;
                                        });
                                      },
                                    ),

                                    const Text(
                                        "FCL",
                                        style: TextStyle(
                                            fontFamily: 'Poppins'
                                        )
                                    ),

                                    Checkbox(
                                      value: isLCL,
                                      onChanged: (value) {
                                        setState(() {
                                          isLCL = value!;
                                          if (isLCL) isFCL = false;
                                        });
                                      },
                                    ),

                                    const Text(
                                        "LCL",
                                        style: TextStyle(
                                            fontFamily: 'Poppins'
                                        )
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // No of Boxes and Weight
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: "Container Size",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: "40", child: Text("40' Standard")),
                                DropdownMenuItem(value: "20", child: Text("20' Standard")),
                              ],
                              onChanged: (value) {
                                // Handle container size change
                              },

                            ),
                          ),

                          const SizedBox(
                              width: 16
                          ),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "No of Boxes",
                                hintText: "Enter number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: "Weight (Kg)",
                                hintText: "Enter weight",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [

                          SvgPicture.asset(
                            'assets/info_circle.svg',
                            height: 12,
                            width: 6,
                          ),

                          const SizedBox(
                            width: 7,
                          ),

                          const Text(
                            "To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate.",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                        ],
                      ),

                      const SizedBox(height: 16),

                      // Container
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Container Internal Dimensions:",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Row(
                            children: [

                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  // Length
                                  Row(
                                    children: [

                                      Text("Length: ", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontWeight: FontWeight.bold)),

                                      SizedBox(
                                        width: 6,
                                      ),

                                      Text("39.46 ft", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontWeight: FontWeight.w900)),

                                    ],
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),

                                  // Width
                                  Row(
                                    children: [

                                      Text("Width: ", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontWeight: FontWeight.bold)),

                                      SizedBox(
                                        width: 14,
                                      ),

                                      Text("7.70 ft", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontWeight: FontWeight.w900)),

                                    ],
                                  ),

                                  SizedBox(
                                    height: 8,
                                  ),

                                  // Height
                                  Row(
                                    children: [

                                      Text("Height: ", style: TextStyle(fontFamily: 'Poppins', color: Colors.grey, fontWeight: FontWeight.bold)),

                                      SizedBox(
                                        width: 9,
                                      ),

                                      Text("7.84 ft", style: TextStyle(fontFamily: 'Poppins', color: Colors.black54, fontWeight: FontWeight.w900)),

                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(width: 68),

                              Image.asset(
                                'assets/container.png',
                                height: 80,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Search Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Search action
                          },
                          icon: const Icon(Icons.search, color: Color(0xFF0139FF)),
                          label: const Text(
                            "Search",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0139FF),
                            ),
                          ),

                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
                            backgroundColor: const Color(0xFFE6EBFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF0139FF),
                              width: 1,
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    originController.dispose();
    destinationController.dispose();
    super.dispose();
  }
}

class AutocompleteField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;

  const AutocompleteField({super.key, required this.hint, required this.controller});

  Future<List<String>> fetchSuggestions(String query) async {
    final response =
    await http.get(Uri.parse('http://universities.hipolabs.com/search?name=$query'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => item['name'] as String).toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 2),

        TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: SvgPicture.asset(
                'assets/location.svg',
                height: 4,
                width: 2,
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          suggestionsCallback: fetchSuggestions,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            );
          },
          onSuggestionSelected: (suggestion) {
            controller.text = suggestion;
          },
        ),
      ],
    );
  }
}
