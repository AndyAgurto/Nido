import 'package:flutter_test/flutter_test.dart';
import 'package:nido/core/money/money.dart';

void main() {
  group('Money - Value Object de Céntimos (PEN)', () {
    test('Creación desde céntimos y soles', () {
      const m1 = Money.fromCents(1050);
      expect(m1.cents, 1050);
      expect(m1.inSoles, 10.50);

      final m2 = Money.fromSoles(10.50);
      expect(m2.cents, 1050);

      const mZero = Money.zero;
      expect(mZero.cents, 0);
      expect(mZero.isZero, isTrue);
    });

    test('Redondeo exacto al convertir desde decimales en soles', () {
      final m = Money.fromSoles(12.345);
      expect(m.cents, 1235);

      final m2 = Money.fromSoles(12.344);
      expect(m2.cents, 1234);
    });

    test('Operaciones aritméticas exactas', () {
      const a = Money.fromCents(1000); // S/ 10.00
      const b = Money.fromCents(450);  // S/ 4.50

      expect((a + b).cents, 1450);
      expect((a - b).cents, 550);
      expect((-b).cents, -450);
      expect((b * 2).cents, 900);
      expect((a / 2).cents, 500);
    });

    test('Manejo de signos y valores absolutos', () {
      const neg = Money.fromCents(-2500);
      expect(neg.isNegative, isTrue);
      expect(neg.isPositive, isFalse);
      expect(neg.abs().cents, 2500);
    });

    test('Comparaciones lógicas', () {
      const chico = Money.fromCents(100);
      const grande = Money.fromCents(500);
      const igual = Money.fromCents(100);

      expect(chico < grande, isTrue);
      expect(grande > chico, isTrue);
      expect(chico <= igual, isTrue);
      expect(chico >= igual, isTrue);
      expect(chico == igual, isTrue);
      expect(chico == grande, isFalse);
    });

    test('Formateo en Soles (es_PE)', () {
      const m1 = Money.fromCents(125050); // S/ 1,250.50
      expect(m1.format(), 'S/ 1,250.50');

      const m2 = Money.fromCents(0);
      expect(m2.format(), 'S/ 0.00');

      const m3 = Money.fromCents(-4500);
      expect(m3.format(), '-S/ 45.00');

      const m4 = Money.fromCents(50); // 50 céntimos
      expect(m4.format(), 'S/ 0.50');

      expect(m1.format(includeSymbol: false), '1,250.50');
    });

    test('Parseo de cadenas de texto', () {
      expect(Money.parse('1250.50').cents, 125050);
      expect(Money.parse('S/ 1,250.50').cents, 125050);
      expect(Money.parse('S/. 1.250,50').cents, 125050);
      expect(Money.parse('-45.20').cents, -4520);
      expect(Money.parse('-S/ 45.20').cents, -4520);
      expect(Money.parse('100').cents, 10000);
      expect(Money.parse('0').cents, 0);

      expect(() => Money.parse('invalido'), throwsFormatException);
    });
  });
}