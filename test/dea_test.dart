import 'package:dea/books.dart';
import 'package:dea/models.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('double entry accounting ...', () async {
    final cash = Uuid().v4();
    final loan = Uuid().v4();

    final b = Books();

    final amount = 10000.00;
    final less = 7500.00;
    final description = "KCB overdraft";

    // creating accounts
    b
      //initialize
      ..setupOwner(name: "Malipo Popote Solutions LLC")
      // adding accounts
      ..addAccount(id: cash, accountType: AccountType.assets, name: "Cash")
      ..addAccount(
          id: loan, accountType: AccountType.liabilities, name: "Loans")

      // transacting
      ..transact()
      // adding all accounting entries required
      ..debit(account: cash, amount: less, description: description)
      //..debit(account: cash, amount: 0, description: "erroneous")
      ..credit(account: loan, amount: amount, description: description)
      // validating and commiting transaction
      ..commit();

    //geting accounts
    //print(b.getAccounts());
    //print(b.getAccountStatement(cash));
    //print(b.getAccountStatement(loan));
    print(b.getLedgers());
    // getting trial balances
  });
}
