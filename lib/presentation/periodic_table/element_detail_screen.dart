import 'package:ar_chem_lab/core/theme/app_colors.dart';
import 'package:ar_chem_lab/core/theme/app_padding.dart';
import 'package:ar_chem_lab/presentation/periodic_table/element_model.dart';

import 'package:flutter/material.dart';

class ElementDetailScreen extends StatelessWidget {
  const ElementDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final element = ModalRoute.of(context)!.settings.arguments as ElementModel;

    return Scaffold(
      backgroundColor:
          AppColors.midnightBlue, // Fallback if gradient isn't passed
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.midnightBlue,
              element.color.withOpacity(0.3),
              AppColors.royalBlue,
            ],
          ),
        ),
        child: Padding(
          padding: AppPadding.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60), // AppBar space
              Center(
                child: Hero(
                  tag: 'element_symbol_${element.symbol}',
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: element.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: element.color.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      element.symbol,
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  element.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Text(
                  element.category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoRow("Atomic Number", "${element.atomicNumber}"),
              _buildInfoRow("Atomic Mass", element.atomicMass),
              _buildInfoRow(
                "Electronic Config",
                element.electronicConfiguration,
              ),
              _buildInfoRow("Block", element.block.toUpperCase()),
              const SizedBox(height: 30),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    element.summary,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
