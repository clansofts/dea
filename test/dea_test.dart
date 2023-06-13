import 'package:dea/service/books.dart';
import 'package:dea/models/enums.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  late Books books;

  setUp(() {
    books = Books();
  });

  group('double entry acounting features', () {
    test('return merchant setup ...', () async {
      //final b = Books();
      final merchantId = "Malipo Popote Solutions LLC";

      books.setupMerchant(name: merchantId);
      final expected = books.getMerchant(merchantId: merchantId);
      print(expected);

      expect(expected.name, merchantId);
    });

    test('return account created ...', () async {
      final cash = Uuid().v4();

      books.addAccount(id: cash, accountType: AccountType.assets, name: "Cash");
      final expected = books.getAccount(cash);
      print(expected);

      expect(expected.accountId, cash);
    });

    test('return multiple accounts created ...', () async {
      final merchantId = "Malipo Popote Solutions LLC";
      final cash = Uuid().v4();
      final loan = Uuid().v4();

      books
        ..addAccount(id: cash, accountType: AccountType.assets, name: "Cash")
        ..addAccount(
            id: loan, accountType: AccountType.liabilities, name: "Loans");

      final expected = books.getAccounts(merchantId: merchantId);
      print(expected);

      expect(expected.length, 2);
    });

    test('double entry accounting transaction ...', () async {
      final cash = Uuid().v4();
      final loan = Uuid().v4();

      final amount = 10000.00;
      final less = 10000.00;
      final description = "KCB overdraft";
      final merchantId = "Malipo Popote Solutions LLC";

      // creating accounts
      books
        //initialize
        ..setupMerchant(name: "Malipo Popote Solutions LLC")
        // adding accounts
        ..addAccount(id: cash, accountType: AccountType.assets, name: "Cash")
        ..addAccount(
            id: loan, accountType: AccountType.liabilities, name: "Loans")

        // transacting
        ..transact(merchantId)
        // adding all accounting entries required
        ..debit(account: cash, amount: less, description: description)
        //..debit(account: cash, amount: 0, description: "erroneous")
        ..credit(account: loan, amount: amount, description: description)
        // validating and commiting transaction
        ..commit();

      final expected = books.getTrialBalances(merchantId: merchantId);

      expect(expected.length, 2);
    });
  });
}
