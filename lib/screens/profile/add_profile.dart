import 'package:flutter/material.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Perfil',
            style: TextStyle(
              color: Colors.deepPurple[400],
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple[400]),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.deepPurple[400],
            width: 350,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Text(
                          'Foto de Perfil',
                          style: TextStyle(fontSize: 11),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[90],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome não pode ser vazio.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[90],
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O número não pode ser vazio.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _whatsappController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Whatsapp',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[90],
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O número não pode ser vazio.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[90],
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O e-mail não pode ser vazio.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,

                decoration: InputDecoration(
                  labelText: 'Endereço',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[90],
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O endereço não pode ser vazio.';
                  }

                  return null;
                },
              ),

              SizedBox(height: 16),

              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Mais informações sobre você, seu transporte, seu trabalho, etc...',
                      style: TextStyle(fontSize: 11),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),

                      style: TextStyle(fontSize: 16, color: Colors.black),

                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Mais informações sobre você, seu transporte, seu trabalho, etc...',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Text(
                          '+ Fotos diversas',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Container(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Text(
                          '+ Fotos diversas',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Container(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Text(
                          '+ Fotos diversas',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  Container(
                    child: Container(
                      width: 90,
                      height: 90,
                      child: Center(
                        child: Text(
                          '+ Fotos diversas',
                          style: TextStyle(fontSize: 9),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,
                    ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.fromLTRB(90, 20, 90, 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(23)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
