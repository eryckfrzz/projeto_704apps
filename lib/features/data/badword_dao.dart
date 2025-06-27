import 'package:projeto_704apps/features/models/badword.dart';

abstract class BadwordDao {
  Future<Badword?> registerBadword(Badword badword, {required String token});
  Future<bool> badwordsCustom(Badword badword, {required String token});
  Future<bool> registerBadwordsBulk(int userId, List<Badword> badwords,{required String token});
  Future<List<Badword>> getBadwordsDefault({required String token});
  Future<List<Badword>> getBadwordsConfigured({required String token});
  Future<List<Badword>> getBadwordsCustom({required String token});
  Future<bool> updateBadword(
    Badword badword,
    String badwordId, {
    required String token,
  });
  Future<bool> deleteBadword(String badwordId, {required String token});
  Future<bool> deleteBadwordCustom(String badwordId, {required String token});
}
