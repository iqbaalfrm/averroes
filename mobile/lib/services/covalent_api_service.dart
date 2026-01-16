import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// =============================================================================
/// COVALENT API SERVICE - Multi-Chain Portfolio
/// =============================================================================
/// 
/// Mendukung:
/// - BSC Mainnet (56)
/// - Ethereum Mainnet (1)
/// - Polygon Mainnet (137)
/// 
/// Fetches token balances untuk wallet address.
/// =============================================================================

class CovalentApiService {
  // API Key dari environment (tidak hardcoded)
  String get _apiKey => EnvConfig.covalentApiKey;
  static const String _baseUrl = 'https://api.covalenthq.com/v1';

  final http.Client _client;

  CovalentApiService({http.Client? client}) : _client = client ?? http.Client();

  // Chain ID mapping ke Covalent chain name
  static const Map<int, String> chainNames = {
    1: 'eth-mainnet',
    56: 'bsc-mainnet',
    137: 'matic-mainnet',
  };

  static const Map<int, String> chainDisplayNames = {
    1: 'Ethereum',
    56: 'BSC',
    137: 'Polygon',
  };

  static const Map<int, String> chainIcons = {
    1: 'ETH',
    56: 'BNB',
    137: 'MATIC',
  };

  /// Fetch token balances untuk wallet di chain tertentu
  Future<ChainBalanceResult> fetchBalances({
    required String walletAddress,
    required int chainId,
  }) async {
    final chainName = chainNames[chainId];
    if (chainName == null) {
      throw Exception('Chain ID $chainId tidak didukung');
    }

    final uri = Uri.parse(
      '$_baseUrl/$chainName/address/$walletAddress/balances_v2/'
    ).replace(queryParameters: {
      'key': _apiKey,
      'nft': 'false',
      'no-spam': 'true',
    });

    print('🔗 [Covalent] Fetching $chainName balances for $walletAddress');

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Batas waktu koneksi habis');
        },
      );

      print('📥 [Covalent] Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['data'];
        
        if (data == null) {
          return ChainBalanceResult(
            chainId: chainId,
            chainName: chainDisplayNames[chainId] ?? 'Unknown',
            tokens: [],
            totalValueUsd: 0,
          );
        }

        final items = data['items'] as List<dynamic>? ?? [];
        final tokens = <TokenBalance>[];
        double totalValue = 0;

        for (final item in items) {
          final balance = _parseTokenBalance(item, chainId);
          if (balance != null && balance.balanceUsd > 0.01) {
            tokens.add(balance);
            totalValue += balance.balanceUsd;
          }
        }

        // Sort by value descending
        tokens.sort((a, b) => b.balanceUsd.compareTo(a.balanceUsd));

        return ChainBalanceResult(
          chainId: chainId,
          chainName: chainDisplayNames[chainId] ?? 'Unknown',
          tokens: tokens,
          totalValueUsd: totalValue,
        );
      } else if (response.statusCode == 401) {
        throw const HttpException('API Key tidak valid');
      } else if (response.statusCode == 429) {
        throw const HttpException('Rate limit exceeded');
      } else {
        throw HttpException('Kesalahan ${response.statusCode}');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet');
    } on TimeoutException {
      throw TimeoutException('Server lambat, coba lagi');
    }
  }

  /// Fetch balances dari semua chain yang didukung
  Future<PortfolioData> fetchMultiChainPortfolio(String walletAddress) async {
    print('🚀 [Portfolio] Fetching multi-chain portfolio for $walletAddress');

    final results = await Future.wait([
      fetchBalances(walletAddress: walletAddress, chainId: 56),  // BSC
      fetchBalances(walletAddress: walletAddress, chainId: 1),   // Ethereum
      fetchBalances(walletAddress: walletAddress, chainId: 137), // Polygon
    ].map((future) => future.catchError((e) {
      print('⚠️ [Portfolio] Chain error: $e');
      return ChainBalanceResult(
        chainId: 0,
        chainName: 'Gagal',
        tokens: [],
        totalValueUsd: 0,
      );
    })));

    // Filter out error results
    final validResults = results.where((r) => r.chainId != 0).toList();

    // Merge all tokens
    final allTokens = <TokenBalance>[];
    double totalUsd = 0;

    for (final result in validResults) {
      allTokens.addAll(result.tokens);
      totalUsd += result.totalValueUsd;
    }

    // Sort all tokens by value
    allTokens.sort((a, b) => b.balanceUsd.compareTo(a.balanceUsd));

    return PortfolioData(
      walletAddress: walletAddress,
      chainResults: validResults,
      allTokens: allTokens,
      totalValueUsd: totalUsd,
      lastUpdated: DateTime.now(),
    );
  }

  TokenBalance? _parseTokenBalance(Map<String, dynamic> item, int chainId) {
    try {
      final contractAddress = item['contract_address'] as String? ?? '';
      final symbol = item['contract_ticker_symbol'] as String? ?? 'UNKNOWN';
      final name = item['contract_name'] as String? ?? symbol;
      final decimals = item['contract_decimals'] as int? ?? 18;
      final balanceRaw = item['balance'] as String? ?? '0';
      final quote = (item['quote'] as num?)?.toDouble() ?? 0.0;
      final quoteRate = (item['quote_rate'] as num?)?.toDouble() ?? 0.0;

      // Parse balance
      final balanceBigInt = BigInt.tryParse(balanceRaw) ?? BigInt.zero;
      final divisor = BigInt.from(10).pow(decimals);
      final balance = balanceBigInt / divisor;

      return TokenBalance(
        contractAddress: contractAddress,
        symbol: symbol.toUpperCase(),
        name: name,
        chainId: chainId,
        chainName: chainDisplayNames[chainId] ?? 'Unknown',
        balance: balance.toDouble(),
        balanceUsd: quote,
        priceUsd: quoteRate,
        decimals: decimals,
      );
    } catch (e) {
      print('⚠️ [Covalent] Parse error: $e');
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}

// =============================================================================
// DATA MODELS
// =============================================================================

class TokenBalance {
  final String contractAddress;
  final String symbol;
  final String name;
  final int chainId;
  final String chainName;
  final double balance;
  final double balanceUsd;
  final double priceUsd;
  final int decimals;

  const TokenBalance({
    required this.contractAddress,
    required this.symbol,
    required this.name,
    required this.chainId,
    required this.chainName,
    required this.balance,
    required this.balanceUsd,
    required this.priceUsd,
    required this.decimals,
  });

  String get balanceFormatted {
    if (balance >= 1000000) {
      return '${(balance / 1000000).toStringAsFixed(2)}M';
    } else if (balance >= 1000) {
      return '${(balance / 1000).toStringAsFixed(2)}K';
    } else if (balance >= 1) {
      return balance.toStringAsFixed(4);
    } else {
      return balance.toStringAsFixed(8);
    }
  }

  String get balanceUsdFormatted {
    if (balanceUsd >= 1000000) {
      return '\$${(balanceUsd / 1000000).toStringAsFixed(2)}M';
    } else if (balanceUsd >= 1000) {
      return '\$${(balanceUsd / 1000).toStringAsFixed(2)}K';
    } else {
      return '\$${balanceUsd.toStringAsFixed(2)}';
    }
  }
}

class ChainBalanceResult {
  final int chainId;
  final String chainName;
  final List<TokenBalance> tokens;
  final double totalValueUsd;

  const ChainBalanceResult({
    required this.chainId,
    required this.chainName,
    required this.tokens,
    required this.totalValueUsd,
  });

  String get totalValueFormatted {
    if (totalValueUsd >= 1000000) {
      return '\$${(totalValueUsd / 1000000).toStringAsFixed(2)}M';
    } else if (totalValueUsd >= 1000) {
      return '\$${(totalValueUsd / 1000).toStringAsFixed(2)}K';
    } else {
      return '\$${totalValueUsd.toStringAsFixed(2)}';
    }
  }
}

class PortfolioData {
  final String walletAddress;
  final List<ChainBalanceResult> chainResults;
  final List<TokenBalance> allTokens;
  final double totalValueUsd;
  final DateTime lastUpdated;

  const PortfolioData({
    required this.walletAddress,
    required this.chainResults,
    required this.allTokens,
    required this.totalValueUsd,
    required this.lastUpdated,
  });

  factory PortfolioData.empty() {
    return PortfolioData(
      walletAddress: '',
      chainResults: [],
      allTokens: [],
      totalValueUsd: 0,
      lastUpdated: DateTime.now(),
    );
  }

  String get totalValueFormatted {
    if (totalValueUsd >= 1000000) {
      return '\$${(totalValueUsd / 1000000).toStringAsFixed(2)}M';
    } else if (totalValueUsd >= 1000) {
      return '\$${(totalValueUsd / 1000).toStringAsFixed(2)}K';
    } else {
      return '\$${totalValueUsd.toStringAsFixed(2)}';
    }
  }

  String get shortAddress {
    if (walletAddress.length < 10) return walletAddress;
    return '${walletAddress.substring(0, 6)}...${walletAddress.substring(walletAddress.length - 4)}';
  }
}
