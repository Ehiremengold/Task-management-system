// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable
import 'package:frontend/data/data.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/data/services.dart';
import 'package:frontend/forms/account_type.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/services/auth.dart';
import 'package:frontend/utils/clipper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../forms/login.dart';

class LandingPage extends StatefulWidget {
  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  List navcontents = ['Pricing', 'About us', 'Features'];

  List<Service> services = [];
  List<Review> reviews = [];
  bool _isheroVisible = false;
  bool _isSponsorsVisible = false;
  bool _isMobileSectionVisible = false;
  bool _isServicesSectionVisible = false;
  bool _isCtaSectionVisible = false;
  bool _isFooterSectionVisible = false;

  void _getInitialInfo() {
    services = Service.services();
    reviews = Review.reviews();
  }

  PageController _reviewController = PageController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _getInitialInfo();
    return Scaffold(
      appBar: _buildAppBar(authProvider, context),
      body: ListView(
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroSection(),
          SizedBox(
            height: 90,
          ),
          VisibilityDetector(
            key: Key('sponsor-section'),
            onVisibilityChanged: (VisibilityInfo info) {
              if (info.visibleFraction > 0.5) {
                setState(() {
                  _isSponsorsVisible = true;
                });
              }
            },
            child: Center(
              child: Text(
                'Trusted by 150+ world\'s best companies',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            ),
          ),

          // sponsors
          _sponsorsSection
              ? Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  // height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/sponsors/microsoft.png',
                        width: 200,
                      ),
                      Image.asset(
                        'assets/sponsors/slack.png',
                        width: 200,
                      ),
                      Image.asset(
                        'assets/sponsors/trello.png',
                        width: 200,
                      ),
                      Image.asset(
                        'assets/sponsors/wrike.png',
                        width: 200,
                      ),
                    ],
                  ),
                )
                  .animate()
                  .fade(
                    begin: 0.0,
                    end: 1.0,
                    duration: Duration(milliseconds: 800),
                  )
                  .slide(
                    begin: Offset(0, 1), // Start from bottom (y = 1)
                    end: Offset(0, 0), // End at original position (y = 0)
                    duration: Duration(milliseconds: 500),
                  )
              : Opacity(
                  opacity: 0,
                  child: Container(
                    margin: EdgeInsets.only(right: 20, left: 20),
                    // height: 200,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/sponsors/microsoft.png',
                          width: 200,
                        ),
                        Image.asset(
                          'assets/sponsors/slack.png',
                          width: 200,
                        ),
                        Image.asset(
                          'assets/sponsors/trello.png',
                          width: 200,
                        ),
                        Image.asset(
                          'assets/sponsors/wrike.png',
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ),

          // services
          SizedBox(
            height: 90,
          ),

          _servicesSection(),

          // mobile-use too
          _mobileUseTooSection(),

          SizedBox(
            height: 70,
          ),
          Center(
            child: SizedBox(
              width: 450,
              child: Text(
                textAlign: TextAlign.center,
                'What Our Customers are Saying',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),

          // review section
          Container(
            margin: EdgeInsets.only(left: 200, right: 200),
            height: 400,
            // width: 300,
            child: ListView.builder(
                itemCount: reviews.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    width: 300,
                    
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.format_quote_rounded),
                        Expanded(
                          child: Text(
                            reviews[index].review,
                            softWrap: true,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                reviews[index].imagePath,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reviews[index].name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(reviews[index].job_description),
                                // for (int i = 0;
                                //     i < reviews[index].stars;
                                //     i += 1)
                                //   Icon(Icons.star_rate_rounded)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 80,
          ),

          // call-to-action
          _calltoActionSection(context),

          // Footer section,
          BuildFooter(),
        ],
      ),
    );
  }

  VisibilityDetector _calltoActionSection(BuildContext context) {
    return VisibilityDetector(
      key: Key('cta-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          setState(() {
            _isCtaSectionVisible = true;
          });
        }
      },
      child: _isCtaSectionVisible
          ? Animate(
              effects: [FadeEffect()],
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:
                        LinearGradient(colors: [Colors.white, Colors.amber])),
                margin: EdgeInsets.only(right: 200, left: 200, bottom: 60),
                padding: EdgeInsets.all(80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set up Personalized',
                          style: TextStyle(fontSize: 45),
                        ),
                        Row(
                          children: [
                            Text(
                              'tasks ',
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 45),
                            ),
                            Text(
                              'and Collaborate with teams!',
                              style: TextStyle(fontSize: 45),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AccountTypeForm()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create account',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // img section
                    Image.asset(
                      'assets/illustration/todo.png',
                      width: 450,
                    )
                  ],
                ),
              ),
            )
          : Opacity(
              opacity: 0,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient:
                        LinearGradient(colors: [Colors.white, Colors.amber])),
                margin: EdgeInsets.only(right: 200, left: 200, bottom: 60),
                padding: EdgeInsets.all(80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // text section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set up Personalized',
                          style: TextStyle(fontSize: 45),
                        ),
                        Row(
                          children: [
                            Text(
                              'tasks ',
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 45),
                            ),
                            Text(
                              'and Collaborate with teams!',
                              style: TextStyle(fontSize: 45),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                                builder: (context) => AccountTypeForm()));
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.black),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create account',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // img section
                    Image.asset(
                      'assets/illustration/todo.png',
                      width: 450,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  PreferredSize _buildAppBar(AuthProvider authProvider, BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: AppBar(
        elevation: 2,
        backgroundColor: Colors.black,
        leadingWidth: 300,
        leading: Container(
          margin: const EdgeInsets.only(left: 70, top: 5),
          child: Row(
            children: [
              Icon(
                Icons.task_rounded,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'taskManager',
                style: TextStyle(
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        actions: [
          authProvider.isLoggedIn
              ? Text(
                  authProvider.loggedUserEmail.toString(),
                  style: TextStyle(color: Colors.white),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => LoginForm()));
                  },
                  child: Row(
                    children: [
                      Text('Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                      )
                    ],
                  )),
          authProvider.isLoggedIn
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(CupertinoPageRoute(builder: (context) => Home()));
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 50),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      child: Text(
                        'Manage Tasks',
                      )),
                )
              : GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => AccountTypeForm()));
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.pink, Colors.purple]),
                        borderRadius: BorderRadius.circular(9)),
                    margin: EdgeInsets.only(right: 60, left: 35),
                    child: Row(children: [
                      Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: 15,
                      )
                    ]),
                  ),
                ),
        ],
        //
        title: Row(
          children: navcontents
              .map((index) => Row(
                    children: [
                      Text(
                        index,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      // SizedBox(width: 5,),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  ))
              .toList(),
        ),
        centerTitle: true,
      ),
    );
  }

  bool get _sponsorsSection => _isSponsorsVisible;

  VisibilityDetector _servicesSection() {
    return VisibilityDetector(
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.7) {
          setState(() {
            _isServicesSectionVisible = true;
          });
        }
      },
      key: Key('services-section'),
      child: Container(
          padding: EdgeInsets.only(
            left: 300,
            top: 70,
            bottom: 70,
          ),
          decoration: BoxDecoration(color: Colors.grey.shade100),
          height: 480,
          child: SizedBox(
            height: 450,
            // width: 700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade50),
                  child: Text(
                    'What we offer?',
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => SizedBox(width: 60),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      return _isServicesSectionVisible
                          ? Card(
                              color: Colors.white,
                              borderOnForeground: false,
                              elevation: 5, // Adjust the elevation as needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(30),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15)),
                                // height: 100,
                                width: 400,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      services[index].imagePath,
                                      width: 50,
                                    ),
                                    Text(
                                      services[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                    Text(
                                      services[index].description,
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Text(
                                      'Learn more',
                                      style: TextStyle(color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                            ).animate().fade().slideX(
                              begin: 50,
                              end: 0,
                              duration: Duration(milliseconds: 200))
                          : Opacity(opacity: 0);
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  VisibilityDetector _mobileUseTooSection() {
    return VisibilityDetector(
      key: Key('mobile-section'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.5) {
          setState(() {
            _isMobileSectionVisible = true;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 300, right: 300),
        margin: EdgeInsets.only(
          top: 80,
        ),
        // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _isMobileSectionVisible
                ? Image.asset('assets/illustration/mobile.png').animate().slide(
                      begin: Offset(-1, 0), // Start from left
                      end: Offset(0, 0), // End at original position
                      duration: Duration(milliseconds: 500),
                    )
                : Opacity(
                    opacity: 0,
                    child: Image.asset('assets/illustration/mobile.png'),
                  ),

            // Word section
            _isMobileSectionVisible
                ? SizedBox(
                    width: 580,
                    height: 300,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create tasks, on the go.',
                          style: TextStyle(
                              fontSize: 46, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'You\'re not alone. The pain of task management is real!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Get it right, and you\'ll end up working smarter to get more done in less time. Drawing up a to-do list might not seem like a groundbreaking technique.',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        )
                      ],
                    ),
                  ).animate().slide(
                      begin: Offset(1, 0), // Start from right
                      end: Offset(0, 0), // End at original position
                      duration: Duration(milliseconds: 500),
                    )
                : Opacity(
                    opacity: 0,
                    child: SizedBox(
                      width: 580,
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create tasks, on the go.',
                            style: TextStyle(
                                fontSize: 46, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'You\'re not alone. The pain of task management is real!',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Get it right, and you\'ll end up working smarter to get more done in less time. Drawing up a to-do list might not seem like a groundbreaking technique.',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurvedClipper(),
      child: Container(
          padding: EdgeInsets.all(120),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.blue.shade100])),
          height: 900,
          width: double.infinity,
          child: Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // text section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The best place to',
                      style: TextStyle(fontSize: 55),
                    ),
                    Text(
                      'manage tasks',
                      style: TextStyle(color: Colors.blue, fontSize: 90),
                    ).animate().fade(duration: Duration(milliseconds: 700)),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Effortlessly organize, prioritize, and conquer tasks. Collaborate \nseamlessly, track progress visually, and stay focused. Unleash your full potential.\nJoin us today!',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              '7-days free trial',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Easy to use',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  width: 40,
                ),

                // hero-img section
                Stack(
                  children: [
                    Container(
                      width: 800,
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.grey)),
                      padding: EdgeInsets.only(left: 70, right: 70, bottom: 70),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          fit: BoxFit.scaleDown,
                          'assets/illustration/tasksc.png',
                          width: 300,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: -8,
                      child: Opacity(
                        opacity: 0.7,
                        child: Image.asset(
                          'assets/illustration/calender.png',
                          width: 200,
                        ),
                      ),
                    )
                  ],
                ).animate().fade(duration: Duration(milliseconds: 500)).slide(
                    begin: Offset(0, -1), // from top
                    end: Offset(0, 0),
                    duration: Duration(seconds: 1))
              ],
            ),
          )),
    );
  }
}

class BuildFooter extends StatelessWidget {
  const BuildFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.black,
      padding: EdgeInsets.only(left: 100, right: 100, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // other stuff
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Column 1
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.task,
                        color: Colors.white,
                      ),
                      Text(
                        'taskManager',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10,),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Join our News Letter Today!',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 250,
                          child: TextField(
                              decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Enter your email',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                          ))),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        height: 49,
                        width: 100,
                        child: Center(
                            child: Text(
                          'Subscribe',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Column 2

            Container(
              height: 150,
              margin: EdgeInsets.only(
                top: 50,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Company', style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('About us', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('Careers', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('News', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('Media kit',
                            style: TextStyle(color: Colors.white)),
                      ],
                    )
                  ]),
            ),

            // Column 3
            Container(
              height: 150,
              margin: EdgeInsets.only(
                top: 50,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quick Links', style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('Privacy Policy',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('Terms of Use',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('Disclaimer',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.keyboard_arrow_right_rounded,
                            color: Colors.white),
                        Text('FAQ', style: TextStyle(color: Colors.white)),
                      ],
                    )
                  ]),
            ),

            // Column 4
            Container(
              height: 150,
              margin: EdgeInsets.only(top: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Info', style: TextStyle(color: Colors.white)),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        Text('75 Orange Str, Ontario, Canada',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email_rounded, color: Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        Text('lorem@taskmanager.com',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.call, color: Colors.white),
                        SizedBox(
                          width: 5,
                        ),
                        Text('+111-222-333',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ]),
            ),
          ]),
          Spacer(),
          Column(
            children: [
              Divider(
                color: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '©️2024 taskManager Inc. All rights reserved',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Privacy',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Legal',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Sitemap',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/social-media-icons/facebook.png',
                        color: Colors.white,
                        width: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset('assets/social-media-icons/linkedin.png',
                          color: Colors.white, width: 20),
                      SizedBox(
                        width: 20,
                      ),
                      Image.asset('assets/social-media-icons/twitter.png',
                          color: Colors.white, width: 20),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
