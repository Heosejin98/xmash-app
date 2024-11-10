import '../services/match_service.dart';
import '../models/match_model.dart';

class MatchRepository {
  final MatchService _matchService;

  MatchRepository({MatchService? matchService}) 
    : _matchService = matchService ?? MatchService();

  Future<List<MatchModel>> getMatches() async {
    return await _matchService.getMatches();
  }
} 