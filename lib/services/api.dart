// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/chara_model.dart';
import '/models/eps_model.dart';
import '/models/loc_model.dart';
import '/models/titan_model.dart';
import '/models/org_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String baseUrl = 'https://api.attackontitanapi.com';

  // ==================== CHARACTERS ====================
  
  /// Get all characters with pagination
  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/characters?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Search characters by name
  Future<List<Character>> searchCharacters(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/characters?name=$query'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search characters');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get character by ID
  Future<Character> getCharacterById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/characters/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Character.fromJson(data);
      } else {
        throw Exception('Failed to load character');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== EPISODES ====================
  
  /// Get all episodes with pagination
  Future<List<Episode>> getEpisodes({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/episodes?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Episode.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load episodes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get episode by ID
  Future<Episode> getEpisodeById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/episodes/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Episode.fromJson(data);
      } else {
        throw Exception('Failed to load episode');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== LOCATIONS ====================
  
  /// Get all locations with pagination
  Future<List<Location>> getLocations({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/locations?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get location by ID
  Future<Location> getLocationById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/locations/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Location.fromJson(data);
      } else {
        throw Exception('Failed to load location');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== TITANS ====================
  
  /// Get all titans with pagination
  Future<List<Titan>> getTitans({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/titans?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Titan.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load titans');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get titan by ID
  Future<Titan> getTitanById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/titans/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Titan.fromJson(data);
      } else {
        throw Exception('Failed to load titan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ==================== ORGANIZATIONS ====================
  
  /// Get all organizations with pagination
  Future<List<Organization>> getOrganizations({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/organizations?page=$page'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Organization.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load organizations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get organization by ID
  Future<Organization> getOrganizationById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/organizations/$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Organization.fromJson(data);
      } else {
        throw Exception('Failed to load organization');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}