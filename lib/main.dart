import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Variants App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductOptionsScreen(),
    );
  }
}

class ProductOptionsScreen extends StatefulWidget {
  @override
  _ProductOptionsScreenState createState() => _ProductOptionsScreenState();
}

class _ProductOptionsScreenState extends State<ProductOptionsScreen> {
  final _formKey = GlobalKey<FormState>();

  // Dropdown options
  final List<String> _sizes = ['Large', 'Small', 'Medium', 'Extra-Large'];
  final List<String> _colors = ['White', 'Black', 'Red', 'Blue'];
  final List<String> _materials = ['Silk', 'Nylon', 'Cotton'];

  // State variables for form fields
  String? _selectedSize;
  String? _selectedColor;
  String? _selectedMaterial;
  double? _price;
  String? _productName;

  // List to store product variants
  List<Map<String, dynamic>> _productVariants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Product Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildTextField('Enter Product Name', (value) {
                  _productName = value;
                }),
                SizedBox(height: 20),
                Text('Select Size:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDropdown('Size', _sizes, (value) {
                  _selectedSize = value;
                }),
                SizedBox(height: 20),
                Text('Select Color:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDropdown('Color', _colors, (value) {
                  _selectedColor = value;
                }),
                SizedBox(height: 20),
                Text('Select Material:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildDropdown('Material', _materials, (value) {
                  _selectedMaterial = value;
                }),
                SizedBox(height: 20),
                Text('Enter Price:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                _buildTextField('Enter Price', (value) {
                  _price = double.tryParse(value);
                }, keyboardType: TextInputType.number),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addVariant,
                  child: Text('Add Variant'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _generateVariants,
                  child: Text('Generate Variants'),
                ),
                SizedBox(height: 20),
                _buildVariantList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget to build dropdown fields
  Widget _buildDropdown(String label, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select a $label' : null,
    );
  }

  // Widget to build text fields
  Widget _buildTextField(String hintText, Function(String) onSaved, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
      keyboardType: keyboardType,
      onSaved: (value) => onSaved(value ?? ''),
      validator: (value) => value == null || value.isEmpty ? 'Please enter a value' : null,
    );
  }

  // Method to add a variant to the list
  void _addVariant() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _productVariants.add({
          'productName': _productName,
          'size': _selectedSize,
          'color': _selectedColor,
          'material': _selectedMaterial,
          'price': _price,
        });
      });
    }
  }

  // Method to generate variants
  void _generateVariants() {
    if (_productVariants.isEmpty) {
      _showDialog('No Variants', 'Please add at least one variant.');
      return;
    }

    List<String> variants = [];
    for (var variant in _productVariants) {
      variants.add('${variant['productName']}: ${variant['size']}, ${variant['color']}, ${variant['material']}, Rs. ${variant['price']}');
    }

    _showDialog('Generated Variants', variants.join('\n'));
  }

  // Method to show dialog with variant information
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Widget to build the variant list display
  Widget _buildVariantList() {
    if (_productVariants.isEmpty) {
      return Text('No variants added yet.', style: TextStyle(fontSize: 16));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _productVariants.map((variant) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text('${variant['productName']} - ${variant['size']} (${variant['color']} / ${variant['material']})'),
            subtitle: Text('Price: Ksh. ${variant['price']}'),
          ),
        );
      }).toList(),
    );
  }
}
