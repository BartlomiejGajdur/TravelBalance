import 'package:TravelBalance/services/api_service.dart';
import 'package:TravelBalance/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'secure_storage_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late SecureStorage secureStorage;

  setUp(() {
    mockSecureStorage = MockFlutterSecureStorage();
    secureStorage = SecureStorage();
    secureStorage.setSecureStorage(mockSecureStorage);
  });

  test('Sprawdzenie zapisu i odczytu', () async {
    final mockAuthentication = Authentication(
      "TOKEN123!",
      "REFRESHTOKEN123!",
      BaseTokenType.Bearer,
      LoginType.Apple,
    );

    // Mockowanie metod zapisu
    when(mockSecureStorage.write(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenAnswer((_) async {});
    when(mockSecureStorage.read(key: 'Token'))
        .thenAnswer((_) async => "TOKEN123!");
    when(mockSecureStorage.read(key: 'TokenType'))
        .thenAnswer((_) async => "Bearer");
    when(mockSecureStorage.read(key: 'LoginType'))
        .thenAnswer((_) async => "Apple");
    when(mockSecureStorage.read(key: 'RefreshToken'))
        .thenAnswer((_) async => "REFRESHTOKEN123!");

    // Test zapisu
    await secureStorage.saveAuthentication(mockAuthentication);

    // Test odczytu
    final auth = await secureStorage.getAuthentication();

    // Oczekiwania
    expect(auth, isNotNull);
    expect(auth!.token, "TOKEN123!");
    expect(auth.tokenType, BaseTokenType.Bearer);
    expect(auth.loginType, LoginType.Apple);
    expect(auth.refreshToken, "REFRESHTOKEN123!");
  });

  test('Resetowanie danych uwierzytelniania', () async {
    // Mockowanie metody usuwania
    when(mockSecureStorage.delete(key: anyNamed('key')))
        .thenAnswer((_) async {});

    // Test resetowania
    await secureStorage.resetAuthentication();

    // Oczekiwanie, że delete został wywołany dla każdego klucza
    verify(mockSecureStorage.delete(key: 'Token')).called(1);
    verify(mockSecureStorage.delete(key: 'TokenType')).called(1);
    verify(mockSecureStorage.delete(key: 'LoginType')).called(1);
    verify(mockSecureStorage.delete(key: 'RefreshToken')).called(1);
  });

  test('Odczyt zwraca null, jeśli brakuje danych', () async {
    // Mockowanie braku danych
    when(mockSecureStorage.read(key: anyNamed('key')))
        .thenAnswer((_) async => null);

    // Test odczytu
    final auth = await secureStorage.getAuthentication();

    // Oczekiwanie
    expect(auth, isNull);
  });

  test('Obsługa błędu podczas zapisu', () async {
    // Mockowanie błędu podczas zapisu
    when(mockSecureStorage.write(
            key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception("Error during write"));

    // Test zapisu
    final mockAuthentication = Authentication(
      "TOKEN123!",
      null,
      BaseTokenType.Bearer,
      LoginType.Apple,
    );

    await secureStorage.saveAuthentication(mockAuthentication);

    // Nie powinno rzucać wyjątku, tylko logować błąd
    verify(mockSecureStorage.write(key: 'Token', value: "TOKEN123!")).called(1);
  });

  test('Obsługa błędu podczas odczytu', () async {
    // Mockowanie błędu podczas odczytu
    when(mockSecureStorage.read(key: anyNamed('key')))
        .thenThrow(Exception("Error during read"));

    // Test odczytu
    final auth = await secureStorage.getAuthentication();

    // Oczekiwanie
    expect(auth, isNull);
  });
}
