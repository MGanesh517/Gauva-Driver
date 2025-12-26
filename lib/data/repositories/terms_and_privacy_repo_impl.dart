import 'package:dartz/dartz.dart';
import 'package:gauva_driver/core/errors/failure.dart';
import 'package:gauva_driver/data/models/privacy_and_policy_model/privacy_and_policy_model.dart';
import 'package:gauva_driver/data/models/terms_and_condition_model/terms_and_condition_model.dart';
import 'package:gauva_driver/data/repositories/base_repository.dart';
import 'package:gauva_driver/data/repositories/interfaces/terms_and_privacy_repo_interface.dart';

import '../services/terms_and_privacy_service.dart';

class TermsAndPrivacyRepoImpl extends BaseRepository implements ITermsAndPrivacyRepo {
  final TermsAndPrivacyService termsAndPrivacyService;

  TermsAndPrivacyRepoImpl({required this.termsAndPrivacyService});

  @override
  Future<Either<Failure, TermsAndConditionModel>> termsAndCondition() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.termsAndCondition();
    return TermsAndConditionModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, PrivacyAndPolicyModel>> privacyAndPolicy() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.privacyPolicy();
    return PrivacyAndPolicyModel.fromJson(response.data);
  });

  @override
  Future<Either<Failure, String>> rateCard() async => await safeApiCall(() async {
    final response = await termsAndPrivacyService.rateCard();

    // Handle Map response (expected format based on API)
    if (response.data is Map<String, dynamic>) {
      final map = response.data as Map<String, dynamic>;

      // Check for content directly in the root
      if (map.containsKey('content') && map['content'] != null) {
        final content = map['content'];
        if (content is String && content.isNotEmpty) {
          return _ensureValidHtml(content);
        }
      }

      // Check for nested 'data' object
      if (map.containsKey('data') && map['data'] != null) {
        final innerData = map['data'];
        if (innerData is Map<String, dynamic>) {
          if (innerData.containsKey('content') && innerData['content'] != null) {
            final content = innerData['content'];
            if (content is String && content.isNotEmpty) {
              return _ensureValidHtml(content);
            }
          }
          // Try 'html' field as alternative
          if (innerData.containsKey('html') && innerData['html'] != null) {
            final html = innerData['html'];
            if (html is String && html.isNotEmpty) {
              return _ensureValidHtml(html);
            }
          }
        }
        if (innerData is String && innerData.isNotEmpty) {
          return _ensureValidHtml(innerData);
        }
      }
    }

    // Handle direct String response
    if (response.data is String) {
      final content = response.data as String;
      if (content.isNotEmpty) {
        return _ensureValidHtml(content);
      }
    }

    // Ensure we never return null - return empty string as fallback
    return '';
  });

  /// Ensures the HTML content is valid and properly wrapped
  String _ensureValidHtml(String content) {
    if (content.isEmpty) return '';

    // If content already has html tags, return as is
    final lowerContent = content.toLowerCase().trim();
    if (lowerContent.startsWith('<!doctype') || lowerContent.startsWith('<html')) {
      return content;
    }

    // If content has body tag but no html tag, wrap it
    if (lowerContent.contains('<body')) {
      return '<html>$content</html>';
    }

    // Otherwise, wrap in proper HTML structure
    return '<html><body>$content</body></html>';
  }
}
