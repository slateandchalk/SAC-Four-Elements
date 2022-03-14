import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sac_slide_puzzle/countdown/countdown.dart';
import 'package:sac_slide_puzzle/layout/layout.dart';
import 'package:sac_slide_puzzle/models/models.dart';
import 'package:sac_slide_puzzle/puzzle/puzzle.dart';
import 'package:sac_slide_puzzle/theme/theme.dart';
import 'package:sac_slide_puzzle/typography/typography.dart';

enum sortOptions { overall, air, water, earth, fire }

class ScoreLayoutDelegate extends PuzzleLayoutDelegate {
  const ScoreLayoutDelegate();

  @override
  List<Object?> get props => [];

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return const SizedBox();
  }

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return const SizedBox();
  }

  @override
  Widget boardBuilder(int size, Map<String, int> board, double gap, List<Widget> tiles, double slideValue,
      Map<String, int> outline, PuzzleState state, CountdownStatus status) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ResponsiveLayoutBuilder(
          small: (_, __) => SizedBox(
            width: 300,
            child: Column(
              children: const [ScoreBoard(), Gap(16), GameBoard()],
            ),
          ),
          medium: (_, __) => SizedBox(
            width: 300,
            child: Column(
              children: const [ScoreBoard(), Gap(16), GameBoard()],
            ),
          ),
          large: (_, __) => SizedBox(
            width: 640,
            child: Column(
              children: const [ScoreBoard(), Gap(16), GameBoard()],
            ),
          ),
        ),
        const Gap(24),
      ],
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  Widget tileBuilder(Tile tile, Map<String, int> tileSize, PuzzleState state) {
    return const SizedBox();
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return const SizedBox();
  }

  @override
  Widget backgroundTopBuilder(PuzzleState state, MediaQueryData size) {
    return const SizedBox();
  }

  @override
  Widget backgroundBottomMountainBuilder(PuzzleState state, MediaQueryData size, artboardM) {
    return const SizedBox();
  }

  @override
  Widget backgroundBottomLandscapeBuilder(PuzzleState state, MediaQueryData size, artboardL) {
    return const SizedBox();
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  String numberOfPlayerPlayed = "0";

  Future<String> fetchScores() async {
    final response = await http.get(
        Uri.parse(
            'https://firestore.googleapis.com/v1/projects/sacfourelements/databases/(default)/documents/puzzleStats/numberOfPlayerPlayed'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    return jsonDecode(response.body)['fields']['count']['integerValue'];
  }

  @override
  void initState() {
    super.initState();
    fetchScores().then((value) => setState(() {
          numberOfPlayerPlayed = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    return Column(
      children: [
        Text(
          'Number of players attempted the game $numberOfPlayerPlayed',
          style: PuzzleTextStyle.bodyText.copyWith(color: theme.defaultColor, fontSize: 18),
        ),
        const Gap(2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get it levitating!',
              style: PuzzleTextStyle.bodyText.copyWith(color: theme.defaultColor),
            ),
            const Icon(
              Icons.favorite,
              color: Colors.red,
            )
          ],
        ),
        const Gap(2),
        Text(
          'Made with Flutter, Firebase & Rive.',
          style: PuzzleTextStyle.bodyText.copyWith(color: theme.defaultColor),
        ),
      ],
    );
  }
}

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({Key? key}) : super(key: key);

  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  final StreamController<List<ScoreQuery>> _scoreController = StreamController<List<ScoreQuery>>.broadcast();

  Future<List<ScoreQuery>> fetchScores() async {
    var queryStructure = jsonEncode({
      "structuredQuery": {
        "orderBy": [
          {
            "field": {"fieldPath": "total_time"},
            "direction": "ASCENDING"
          }
        ],
        "from": [
          {"collectionId": "puzzle", "allDescendants": true}
        ]
      }
    });
    final response = await http.post(
        Uri.parse(
            'https://firestore.googleapis.com/v1/projects/sacfourelements/databases/(default)/documents:runQuery'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: queryStructure);

    return parseScoreQuery(utf8.decode(response.bodyBytes));
  }

  List<ScoreQuery> parseScoreQuery(String bodyBytes) {
    final parsed = jsonDecode(bodyBytes).cast<Map<String, dynamic>>();

    return parsed.map<ScoreQuery>((json) => ScoreQuery.fromJson(json)).toList();
  }

  loadData() async {
    fetchScores().then((res) {
      _scoreController.add(res);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    return StreamBuilder<List<ScoreQuery>>(
      stream: _scoreController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.defaultColor,
            ),
          );
        }

        return snapshot.hasData
            ? ScoreList(
                score: snapshot.data!,
              )
            : Center(
                child: CircularProgressIndicator(
                color: theme.defaultColor,
              ));
      },
    );
  }
}

class ScoreList extends StatefulWidget {
  const ScoreList({Key? key, required this.score}) : super(key: key);
  final List<ScoreQuery> score;
  @override
  _ScoreListState createState() => _ScoreListState();
}

class _ScoreListState extends State<ScoreList> {
  List<ScoreQuery> scores = [];
  List<ScoreQuery> sortedScores = [];
  var selectedOption = sortOptions.overall;

  fetchIndex() {
    for (var i = 0; i < scores.length; i++) {
      scores[i].document.fields.index = i + 1;
    }
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft = m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft = s.toString().length < 2 ? "0" + s.toString() : s.toString();

    //hourLeft + "h " + minuteLeft + "m " + secondsLeft + "s"
    String hh = "";
    String mm = "";
    String ss = "";

    if (int.parse(hourLeft) != 0) {
      hh = hourLeft + "h ";
    }
    if (int.parse(minuteLeft) != 0) {
      mm = minuteLeft + "m ";
    }
    if (int.parse(secondsLeft) != 0) {
      ss = secondsLeft + "s";
    }

    return hh + mm + ss;
  }

  sortScores(sortX) {
    if (sortX == sortOptions.overall) {
      scores = widget.score;
      scores.sort((b, a) => int.parse(b.document.fields.totalTime.integerValue)
          .compareTo(int.parse(a.document.fields.totalTime.integerValue)));
    } else if (sortX == sortOptions.air) {
      scores = widget.score;
      scores.sort((b, a) => int.parse(b.document.fields.airTime.integerValue)
          .compareTo(int.parse(a.document.fields.airTime.integerValue)));
    } else if (sortX == sortOptions.water) {
      scores = widget.score;
      scores.sort((b, a) => int.parse(b.document.fields.waterTime.integerValue)
          .compareTo(int.parse(a.document.fields.waterTime.integerValue)));
    } else if (sortX == sortOptions.earth) {
      scores = widget.score;
      scores.sort((b, a) => int.parse(b.document.fields.earthTime.integerValue)
          .compareTo(int.parse(a.document.fields.earthTime.integerValue)));
    } else if (sortX == sortOptions.fire) {
      scores = widget.score;
      scores.sort((b, a) => int.parse(b.document.fields.fireTime.integerValue)
          .compareTo(int.parse(a.document.fields.fireTime.integerValue)));
    }
    fetchIndex();
  }

  @override
  void initState() {
    super.initState();
    scores = widget.score;
    fetchIndex();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((SimpleThemeBloc bloc) => bloc.state.theme);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Gap(8),
                SizedBox(
                  width: 40,
                  child: Text(
                    'Rank',
                    style: PuzzleTextStyle.text.copyWith(color: theme.defaultColor),
                  ),
                ),
                const Gap(20),
                Text(
                  'Nick Name',
                  style: PuzzleTextStyle.text.copyWith(color: theme.defaultColor),
                ),
              ],
            ),
            SizedBox(
              width: 72,
              child: PopupMenuButton<sortOptions>(
                offset: const Offset(100, 50),
                tooltip: 'Sort rank',
                icon: Icon(
                  Icons.sort,
                  size: 24,
                  color: theme.defaultColor,
                ),
                onSelected: (sortOptions result) {
                  switch (result) {
                    case sortOptions.overall:
                      setState(() {
                        selectedOption = sortOptions.overall;
                        sortScores(sortOptions.overall);
                      });
                      break;
                    case sortOptions.air:
                      setState(() {
                        selectedOption = sortOptions.air;
                        sortScores(sortOptions.air);
                      });
                      break;
                    case sortOptions.water:
                      setState(() {
                        selectedOption = sortOptions.water;
                        sortScores(sortOptions.water);
                      });
                      break;
                    case sortOptions.earth:
                      setState(() {
                        selectedOption = sortOptions.earth;
                        sortScores(sortOptions.earth);
                      });
                      break;
                    case sortOptions.fire:
                      setState(() {
                        selectedOption = sortOptions.fire;
                        sortScores(sortOptions.fire);
                      });
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<sortOptions>>[
                  CheckedPopupMenuItem<sortOptions>(
                    checked: sortOptions.overall == selectedOption,
                    value: sortOptions.overall,
                    child: const Text('Overall'),
                  ),
                  CheckedPopupMenuItem<sortOptions>(
                    checked: sortOptions.air == selectedOption,
                    value: sortOptions.air,
                    child: const Text('Air'),
                  ),
                  CheckedPopupMenuItem<sortOptions>(
                    checked: sortOptions.water == selectedOption,
                    value: sortOptions.water,
                    child: const Text('Water'),
                  ),
                  CheckedPopupMenuItem<sortOptions>(
                    checked: sortOptions.earth == selectedOption,
                    value: sortOptions.earth,
                    child: const Text('Earth'),
                  ),
                  CheckedPopupMenuItem<sortOptions>(
                    checked: sortOptions.fire == selectedOption,
                    value: sortOptions.fire,
                    child: const Text('Fire'),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionPanelList(
          elevation: 0,
          dividerColor: theme.backgroundColorPrimary.withOpacity(0.5),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              scores[index].document.fields.isExpanded = !isExpanded;
            });
          },
          children: scores.map<ExpansionPanel>((ScoreQuery item) {
            return ExpansionPanel(
              backgroundColor: Colors.transparent,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  visualDensity: VisualDensity.comfortable,
                  dense: true,
                  title: Row(
                    children: [
                      item.document.fields.index == 1
                          ? SizedBox(
                              child: Image.asset('assets/images/rank_gold.png'),
                              width: 24,
                            )
                          : item.document.fields.index == 2
                              ? SizedBox(
                                  child: Image.asset('assets/images/rank_silver.png'),
                                  width: 24,
                                )
                              : item.document.fields.index == 3
                                  ? SizedBox(
                                      child: Image.asset('assets/images/rank_bronze.png'),
                                      width: 24,
                                    )
                                  : SizedBox(
                                      width: 24,
                                      child: Text(
                                        item.document.fields.index.toString(),
                                        style: PuzzleTextStyle.bodyText,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                      const Gap(28),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              item.document.fields.nickName.stringValue,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: false,
                              style: item.document.fields.index <= 3 ? PuzzleTextStyle.text : PuzzleTextStyle.bodyText,
                            ),
                            isExpanded
                                ? Text(
                                    DateFormat.yMMMEd()
                                        .add_Hm()
                                        .format(DateTime.parse(item.document.fields.timeStamp.timestampValue)),
                                    overflow: TextOverflow.ellipsis,
                                    style: PuzzleTextStyle.labelText,
                                  )
                                : const SizedBox()
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  ),
                );
              },
              body: Row(
                children: [
                  const Gap(68),
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              'Total moves',
                              style: PuzzleTextStyle.text,
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + item.document.fields.totalMoves.integerValue.toString(),
                            style: PuzzleTextStyle.text,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              'Total time',
                              style: PuzzleTextStyle.text,
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + intToTimeLeft(int.parse(item.document.fields.totalTime.integerValue)),
                            style: PuzzleTextStyle.text,
                          )
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.air,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const Gap(4),
                                Text(
                                  'Air',
                                  style: PuzzleTextStyle.bodyText,
                                ),
                              ],
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + intToTimeLeft(int.parse(item.document.fields.airTime.integerValue)),
                            style: PuzzleTextStyle.bodyText,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.water,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const Gap(4),
                                Text(
                                  'Water',
                                  style: PuzzleTextStyle.bodyText,
                                ),
                              ],
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + intToTimeLeft(int.parse(item.document.fields.waterTime.integerValue)),
                            style: PuzzleTextStyle.bodyText,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.landscape,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const Gap(4),
                                Text(
                                  'Earth',
                                  style: PuzzleTextStyle.bodyText,
                                ),
                              ],
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + intToTimeLeft(int.parse(item.document.fields.earthTime.integerValue)),
                            style: PuzzleTextStyle.bodyText,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 16.0,
                                ),
                                const Gap(4),
                                Text(
                                  'Fire',
                                  style: PuzzleTextStyle.bodyText,
                                ),
                              ],
                            ),
                            width: 104,
                          ),
                          Text(
                            ': ' + intToTimeLeft(int.parse(item.document.fields.fireTime.integerValue)),
                            style: PuzzleTextStyle.bodyText,
                          )
                        ],
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  )
                ],
              ),
              isExpanded: item.document.fields.isExpanded,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ScoreQuery {
  ScoreQuery({
    required this.document,
  });

  ScoreQueryDocument document;

  factory ScoreQuery.fromJson(Map<String, dynamic> parsedJson) {
    return ScoreQuery(document: ScoreQueryDocument.fromJson(parsedJson['document']));
  }
}

class ScoreQueryDocument {
  ScoreQueryDocument({
    required this.name,
    required this.fields,
    required this.createTime,
    required this.updateTime,
  });

  String name;
  ScoreQueryFields fields;
  String createTime;
  String updateTime;

  factory ScoreQueryDocument.fromJson(Map<String, dynamic> parsedJson) {
    return ScoreQueryDocument(
      name: parsedJson["name"],
      fields: ScoreQueryFields.fromJson(parsedJson["fields"]),
      createTime: parsedJson["createTime"],
      updateTime: parsedJson["updateTime"],
    );
  }
}

class ScoreQueryFields {
  ScoreQueryFields({
    required this.nickName,
    required this.airTime,
    required this.waterTime,
    required this.earthTime,
    required this.fireTime,
    required this.totalTime,
    required this.isExpanded,
    required this.index,
    required this.timeStamp,
    required this.totalMoves,
  });

  Strings nickName;
  Integers airTime;
  Integers waterTime;
  Integers earthTime;
  Integers fireTime;
  Integers totalTime;
  bool isExpanded;
  int index;
  TimestampVal timeStamp;
  Integers totalMoves;

  factory ScoreQueryFields.fromJson(Map<String, dynamic> parsedJson) {
    return ScoreQueryFields(
      nickName: Strings.fromJson(parsedJson["nick_name"]),
      airTime: Integers.fromJson(parsedJson["air_time"]),
      waterTime: Integers.fromJson(parsedJson["water_time"]),
      earthTime: Integers.fromJson(parsedJson["earth_time"]),
      fireTime: Integers.fromJson(parsedJson["fire_time"]),
      totalTime: Integers.fromJson(parsedJson["total_time"]),
      isExpanded: false,
      index: 0,
      timeStamp: TimestampVal.fromJson(parsedJson['date_time']),
      totalMoves: Integers.fromJson(parsedJson['total_moves']),
    );
  }
}

class Strings {
  Strings({
    required this.stringValue,
  });

  String stringValue;

  factory Strings.fromJson(Map<String, dynamic> parsedJson) {
    return Strings(
      stringValue: parsedJson["stringValue"],
    );
  }
}

class Integers {
  Integers({
    required this.integerValue,
  });

  String integerValue;

  factory Integers.fromJson(Map<String, dynamic> parsedJson) {
    return Integers(
      integerValue: parsedJson["integerValue"],
    );
  }
}

class TimestampVal {
  TimestampVal({
    required this.timestampValue,
  });

  String timestampValue;

  factory TimestampVal.fromJson(Map<String, dynamic> parsedJson) {
    return TimestampVal(
      timestampValue: parsedJson["timestampValue"],
    );
  }
}
