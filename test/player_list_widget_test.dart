import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kesakisat_mobile/blocs/player_bloc.dart';
import 'package:kesakisat_mobile/db/database_provider.dart';
import 'package:kesakisat_mobile/models/player.dart';
import 'package:kesakisat_mobile/player_list.dart';
import 'package:kesakisat_mobile/states/player_state.dart';
import 'package:mockito/mockito.dart';

class DataBaseProviderMock extends Mock implements DatabaseProvider {}

void main() {
//
// create image for all golder tests that contains  `matchesGoldenFile`
// flutter test --update-goldens
  testWidgets('Golden test', (WidgetTester tester) async {
    final providerMock = DataBaseProviderMock();
    when(providerMock.getPlayers()).thenAnswer(
      (_) => Future.value(
        [
          Player(id: 1, name: 'Mocki player'),
        ],
      ),
    );
    await tester.pumpWidget(
      BlocProvider(
        create: (BuildContext context) {
          return PlayerBloc(new PlayerInitialState());
        },
        child: MaterialApp(
          home: Material(
            color: Colors.transparent,
            child: PlayerList(
              provider: providerMock,
            ),
          ),
        ),
      ),
    );
    await expectLater(
        find.byType(PlayerList), matchesGoldenFile('playerlist.png'));
  });
}
