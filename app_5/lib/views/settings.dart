import 'package:flutter/material.dart';
import 'package:mp5/models/settings_model.dart';
import 'package:mp5/utils/db_helper.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Difficulty _difficulty = Difficulty.medium;
  late Future<SettingsModel?> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadSettings();
  }

  Widget _buildDifficultyButton(Difficulty difficulty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _difficulty = difficulty;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _difficulty == difficulty ? Colors.blue : null,
        ),
        child: Text(
          difficulty.toString().split('.').last,
          style:
              TextStyle(color: _difficulty == difficulty ? Colors.white : null),
        ),
      ),
    );
  }

  void _saveSettings() async {
    final settings = SettingsModel(
      difficulty: _difficulty,
    );

    await DBHelper.insertSettings(settings);

    final updatedSettings = await DBHelper.getSettings();
    print('Updated Settings: ${updatedSettings?.difficulty}');
  }

  Future<SettingsModel?> _loadSettings() async {
    final settings = await DBHelper.getSettings();
    if (settings != null) {
      setState(() {
        _difficulty = settings.difficulty;
      });
    }
    print('Loaded difficulty: $_difficulty');
    return settings;
  }

  @override
  Widget build(BuildContext context) {
    print('Current difficulty: $_difficulty');
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildDifficultyButton(Difficulty.easy),
              _buildDifficultyButton(Difficulty.medium),
              _buildDifficultyButton(Difficulty.hard),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _saveSettings();
                  Navigator.pop(context);
                },
                child: Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
