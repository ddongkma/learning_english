import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:learning_english/modal/english_today.dart';
import 'package:learning_english/pages/all_page.dart';
import 'package:learning_english/pages/all_word_page.dart';
import 'package:learning_english/pages/control_page.dart';
import 'package:learning_english/values/app_assets.dart';
import 'package:learning_english/values/app_colors.dart';
import 'package:learning_english/values/app_styles.dart';
import 'package:learning_english/values/share_keys.dart';
import 'package:learning_english/widgets/app_button.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  List<EnglishToday> words = [];

  List<int> fixelListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) return [];
    List<int> newList = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }
    return newList;
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int len = prefs.getInt(ShareKeys.counter) ?? 5;
    List<String> newList = [];
    List<int> rans = fixelListRandom(len: len, max: nouns.length);
    rans.forEach((index) {
      newList.add(nouns[index]);
    });
    setState(() {
      words = newList.map((e) => EnglishToday(noun: e)).toList();
    });
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    getEnglishToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        centerTitle: true,
        title: Text('English today',
            style: AppStyles.h3
                .copyWith(color: AppColors.textColor, fontSize: 36)),
        leading: InkWell(
          onTap: () {
            _globalKey.currentState?.openDrawer();
          },
          child: Image.asset(AppAssets.menuBar),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.symmetric(horizontal: 17),
        width: double.infinity,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.centerLeft,
              height: size.height * 1 / 10,
              child: Text(
                '"It is amazing how complete is the delusion that beauty is goodness."',
                style: AppStyles.h5.copyWith(
                  color: AppColors.textColor,
                ),
              ),
            ),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length > 5 ? 6 : words.length,
                  itemBuilder: (context, index) {
                    String word =
                    words[index].noun != null ? words[index].noun! : "";
                    String firstLetter = word.substring(0, 1);
                    String lastLetter = word.substring(1, word.length);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(25)),
                        elevation: 4,
                        color: AppColors.primaryColor,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                              !words[index].isFavorite;
                            });
                          },
                          splashColor: Colors.transparent,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(25)),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: index >= 5
                                ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            AllPage(words: words)));
                              },
                              child: Center(
                                child: Text(
                                  'Show More...',
                                  style: AppStyles.h3.copyWith(shadows: [
                                    const BoxShadow(
                                        color: Colors.black38,
                                        offset: Offset(3, 6),
                                        blurRadius: 6)
                                  ]),
                                ),
                              ),
                            )
                                : Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                LikeButton(
                                  onTap: (bool isLiked) async {
                                    setState(() {
                                      words[index].isFavorite =
                                      !words[index].isFavorite;
                                    });
                                    return words[index].isFavorite;
                                  },
                                  isLiked: words[index].isFavorite,
                                  mainAxisAlignment:
                                  MainAxisAlignment.end,
                                  size: 42,
                                  circleColor: const CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: const BubblesColor(
                                    dotPrimaryColor: Color(0xff33b5e5),
                                    dotSecondaryColor: Color(0xff0099cc),
                                  ),
                                  likeBuilder: (bool isLiked) {
                                    //
                                    return ImageIcon(
                                      AssetImage(AppAssets.like),
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.white,
                                      size: 50,
                                    );
                                  },
                                ),
                                // Container(
                                //   alignment: Alignment.centerRight,
                                //   child: Image.asset(
                                //     AppAssets.like,
                                //     color: words[index].isFavorite
                                //         ? Colors.red
                                //         : Colors.white,
                                //   ),
                                // ),
                                RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: firstLetter,
                                        style: TextStyle(
                                            fontFamily: FontFamily.sen,
                                            fontSize: 90,
                                            fontWeight: FontWeight.bold,
                                            shadows: const [
                                              BoxShadow(
                                                  color: Colors.black38,
                                                  offset: Offset(3, 6),
                                                  blurRadius: 6)
                                            ]),
                                        children: [
                                          TextSpan(
                                              text: lastLetter,
                                              style: TextStyle(
                                                  fontFamily:
                                                  FontFamily.sen,
                                                  fontSize: 55,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  shadows: const [
                                                    BoxShadow(
                                                        color: Colors
                                                            .black38,
                                                        offset:
                                                        Offset(3, 6),
                                                        blurRadius: 6)
                                                  ]))
                                        ])),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: AutoSizeText(
                                    '"Think of all the beauty still left around you and be happy"',
                                    maxFontSize: 26,
                                    style: AppStyles.h4.copyWith(
                                        letterSpacing: 1,
                                        color: AppColors.textColor),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            _currentIndex >= 5
                ? buildShowMore()
                : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.symmetric(vertical: 16),
              height: 12,
              alignment: Alignment.center,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return buildIndicator(index == _currentIndex, size);
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday();
          });
        },
        child: Image.asset(AppAssets.exchange),
      ),
      drawer: Drawer(
        child: Container(
          color: AppColors.lightBlue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, left: 16),
                child: Text(
                  'Your mind',
                  style: AppStyles.h3.copyWith(color: AppColors.textColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AppButton(label: 'Favorites', onTap: () {}),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: AppButton(
                    label: 'Your Control',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ControlPage()));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 12,
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lightBlue : AppColors.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }

  Widget buildShowMore() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        alignment: Alignment.centerLeft,
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          elevation: 4,
          color: AppColors.primaryColor,
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AllWordPage(words: words)));
            },
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text('Show more',
                  style: AppStyles.h5
                      .copyWith(color: AppColors.textColor, fontSize: 18)),
            ),
          ),
        ));
  }
}
