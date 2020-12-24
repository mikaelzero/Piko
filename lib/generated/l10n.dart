// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Piko`
  String get appName {
    return Intl.message(
      'Piko',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcome_back {
    return Intl.message(
      'Welcome back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to continue to Pixiv`
  String get welcome_sign {
    return Intl.message(
      'Sign in to continue to Pixiv',
      name: 'welcome_sign',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account? Sign up`
  String get register {
    return Intl.message(
      'Don\'t have an account? Sign up',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get login_account_hint {
    return Intl.message(
      'Account',
      name: 'login_account_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get login_password_hint {
    return Intl.message(
      'Password',
      name: 'login_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the necessary information`
  String get login_empty_error {
    return Intl.message(
      'Please enter the necessary information',
      name: 'login_empty_error',
      desc: '',
      args: [],
    );
  }

  /// `Login Error`
  String get login_error {
    return Intl.message(
      'Login Error',
      name: 'login_error',
      desc: '',
      args: [],
    );
  }

  /// `return again to exit app`
  String get return_again_to_exit {
    return Intl.message(
      'return again to exit app',
      name: 'return_again_to_exit',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get actionConfirm {
    return Intl.message(
      'Confirm',
      name: 'actionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get actionCancel {
    return Intl.message(
      'Cancel',
      name: 'actionCancel',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed`
  String get viewStateMessageError {
    return Intl.message(
      'Load Failed',
      name: 'viewStateMessageError',
      desc: '',
      args: [],
    );
  }

  /// `Load Failed,Check network `
  String get viewStateMessageNetworkError {
    return Intl.message(
      'Load Failed,Check network ',
      name: 'viewStateMessageNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Nothing Found`
  String get viewStateMessageEmpty {
    return Intl.message(
      'Nothing Found',
      name: 'viewStateMessageEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Not sign in yet`
  String get viewStateMessageUnAuth {
    return Intl.message(
      'Not sign in yet',
      name: 'viewStateMessageUnAuth',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get viewStateButtonRefresh {
    return Intl.message(
      'Refresh',
      name: 'viewStateButtonRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get viewStateButtonRetry {
    return Intl.message(
      'Retry',
      name: 'viewStateButtonRetry',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get viewStateButtonLogin {
    return Intl.message(
      'Sign In',
      name: 'viewStateButtonLogin',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get settingLanguage {
    return Intl.message(
      'Language',
      name: 'settingLanguage',
      desc: '',
      args: [],
    );
  }

  /// `System Font`
  String get settingFont {
    return Intl.message(
      'System Font',
      name: 'settingFont',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get logout {
    return Intl.message(
      'Sign Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Auto`
  String get autoBySystem {
    return Intl.message(
      'Auto',
      name: 'autoBySystem',
      desc: '',
      args: [],
    );
  }

  /// `Go to Sign In`
  String get needLogin {
    return Intl.message(
      'Go to Sign In',
      name: 'needLogin',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Rank`
  String get rank {
    return Intl.message(
      'Rank',
      name: 'rank',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Activities`
  String get activities {
    return Intl.message(
      'Activities',
      name: 'activities',
      desc: '',
      args: [],
    );
  }

  /// `Mine`
  String get mine {
    return Intl.message(
      'Mine',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get rank_day {
    return Intl.message(
      'Day',
      name: 'rank_day',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get rank_week {
    return Intl.message(
      'Week',
      name: 'rank_week',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get rank_month {
    return Intl.message(
      'Month',
      name: 'rank_month',
      desc: '',
      args: [],
    );
  }

  /// `Male hot`
  String get rank_male_hot {
    return Intl.message(
      'Male hot',
      name: 'rank_male_hot',
      desc: '',
      args: [],
    );
  }

  /// `Women hot`
  String get rank_women_hot {
    return Intl.message(
      'Women hot',
      name: 'rank_women_hot',
      desc: '',
      args: [],
    );
  }

  /// `Original`
  String get rank_original {
    return Intl.message(
      'Original',
      name: 'rank_original',
      desc: '',
      args: [],
    );
  }

  /// `New Person`
  String get rank_new_man {
    return Intl.message(
      'New Person',
      name: 'rank_new_man',
      desc: '',
      args: [],
    );
  }

  /// `Recommend Users`
  String get home_recommend_user {
    return Intl.message(
      'Recommend Users',
      name: 'home_recommend_user',
      desc: '',
      args: [],
    );
  }

  /// `Recommend`
  String get home_recommend_post {
    return Intl.message(
      'Recommend',
      name: 'home_recommend_post',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get post_view_count {
    return Intl.message(
      'View',
      name: 'post_view_count',
      desc: '',
      args: [],
    );
  }

  /// `Like`
  String get post_like_count {
    return Intl.message(
      'Like',
      name: 'post_like_count',
      desc: '',
      args: [],
    );
  }

  /// `follow`
  String get follow {
    return Intl.message(
      'follow',
      name: 'follow',
      desc: '',
      args: [],
    );
  }

  /// `replay`
  String get replay {
    return Intl.message(
      'replay',
      name: 'replay',
      desc: '',
      args: [],
    );
  }

  /// `following`
  String get following {
    return Intl.message(
      'following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `Works`
  String get user_page_tab1 {
    return Intl.message(
      'Works',
      name: 'user_page_tab1',
      desc: '',
      args: [],
    );
  }

  /// `Stars`
  String get user_page_tab2 {
    return Intl.message(
      'Stars',
      name: 'user_page_tab2',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get user_page_tab3 {
    return Intl.message(
      'Info',
      name: 'user_page_tab3',
      desc: '',
      args: [],
    );
  }

  /// `Related Works`
  String get about_post {
    return Intl.message(
      'Related Works',
      name: 'about_post',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `pc`
  String get workspace_pc {
    return Intl.message(
      'pc',
      name: 'workspace_pc',
      desc: '',
      args: [],
    );
  }

  /// `monitor`
  String get workspace_monitor {
    return Intl.message(
      'monitor',
      name: 'workspace_monitor',
      desc: '',
      args: [],
    );
  }

  /// `tool`
  String get workspace_tool {
    return Intl.message(
      'tool',
      name: 'workspace_tool',
      desc: '',
      args: [],
    );
  }

  /// `scanner`
  String get workspace_scanner {
    return Intl.message(
      'scanner',
      name: 'workspace_scanner',
      desc: '',
      args: [],
    );
  }

  /// `tablet`
  String get workspace_tablet {
    return Intl.message(
      'tablet',
      name: 'workspace_tablet',
      desc: '',
      args: [],
    );
  }

  /// `printer`
  String get workspace_printer {
    return Intl.message(
      'printer',
      name: 'workspace_printer',
      desc: '',
      args: [],
    );
  }

  /// `mouse`
  String get workspace_mouse {
    return Intl.message(
      'mouse',
      name: 'workspace_mouse',
      desc: '',
      args: [],
    );
  }

  /// `music`
  String get workspace_music {
    return Intl.message(
      'music',
      name: 'workspace_music',
      desc: '',
      args: [],
    );
  }

  /// `desk`
  String get workspace_desk {
    return Intl.message(
      'desk',
      name: 'workspace_desk',
      desc: '',
      args: [],
    );
  }

  /// `chair`
  String get workspace_chair {
    return Intl.message(
      'chair',
      name: 'workspace_chair',
      desc: '',
      args: [],
    );
  }

  /// `other`
  String get workspace_comment {
    return Intl.message(
      'other',
      name: 'workspace_comment',
      desc: '',
      args: [],
    );
  }

  /// `Search for what you're interested in`
  String get search_title {
    return Intl.message(
      'Search for what you\'re interested in',
      name: 'search_title',
      desc: '',
      args: [],
    );
  }

  /// `Illust`
  String get search_result_tab1 {
    return Intl.message(
      'Illust',
      name: 'search_result_tab1',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get search_result_tab2 {
    return Intl.message(
      'Users',
      name: 'search_result_tab2',
      desc: '',
      args: [],
    );
  }

  /// `Illust Id`
  String get illust_id {
    return Intl.message(
      'Illust Id',
      name: 'illust_id',
      desc: '',
      args: [],
    );
  }

  /// `User Id`
  String get user_id {
    return Intl.message(
      'User Id',
      name: 'user_id',
      desc: '',
      args: [],
    );
  }

  /// `Enter other word and try again`
  String get search_empty_desc {
    return Intl.message(
      'Enter other word and try again',
      name: 'search_empty_desc',
      desc: '',
      args: [],
    );
  }

  /// `Enter keywords or paste links`
  String get search_hit {
    return Intl.message(
      'Enter keywords or paste links',
      name: 'search_hit',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get search_filter {
    return Intl.message(
      'Filters',
      name: 'search_filter',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get search_reset {
    return Intl.message(
      'Reset',
      name: 'search_reset',
      desc: '',
      args: [],
    );
  }

  /// `Choose Dates`
  String get search_filter_choose_date {
    return Intl.message(
      'Choose Dates',
      name: 'search_filter_choose_date',
      desc: '',
      args: [],
    );
  }

  /// `Dates`
  String get search_filter_date {
    return Intl.message(
      'Dates',
      name: 'search_filter_date',
      desc: '',
      args: [],
    );
  }

  /// `Collections Users`
  String get search_filter_collections_num {
    return Intl.message(
      'Collections Users',
      name: 'search_filter_collections_num',
      desc: '',
      args: [],
    );
  }

  /// `Older`
  String get search_filter_date_asc {
    return Intl.message(
      'Older',
      name: 'search_filter_date_asc',
      desc: '',
      args: [],
    );
  }

  /// `Newer`
  String get search_filter_date_desc {
    return Intl.message(
      'Newer',
      name: 'search_filter_date_desc',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get search_filter_popular_desc {
    return Intl.message(
      'Popular',
      name: 'search_filter_popular_desc',
      desc: '',
      args: [],
    );
  }

  /// `Tag exact matches`
  String get search_filter_exact_match_for_tag {
    return Intl.message(
      'Tag exact matches',
      name: 'search_filter_exact_match_for_tag',
      desc: '',
      args: [],
    );
  }

  /// `Tag partial matches`
  String get search_filter_partial_match_for_tag {
    return Intl.message(
      'Tag partial matches',
      name: 'search_filter_partial_match_for_tag',
      desc: '',
      args: [],
    );
  }

  /// `Title and description`
  String get search_filter_title_and_caption {
    return Intl.message(
      'Title and description',
      name: 'search_filter_title_and_caption',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filter`
  String get search_filter_apply {
    return Intl.message(
      'Apply Filter',
      name: 'search_filter_apply',
      desc: '',
      args: [],
    );
  }

  /// `more`
  String get more {
    return Intl.message(
      'more',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Save DNS over HTTPS time`
  String get accelerate {
    return Intl.message(
      'Save DNS over HTTPS time',
      name: 'accelerate',
      desc: '',
      args: [],
    );
  }

  /// `Notice`
  String get please_note_that {
    return Intl.message(
      'Notice',
      name: 'please_note_that',
      desc: '',
      args: [],
    );
  }

  /// `This option should be ON unless you are able to access pixiv.net without any issue.`
  String get please_note_that_content {
    return Intl.message(
      'This option should be ON unless you are able to access pixiv.net without any issue.',
      name: 'please_note_that_content',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `cancel`
  String get cancel {
    return Intl.message(
      'cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `save success`
  String get save_success {
    return Intl.message(
      'save success',
      name: 'save_success',
      desc: '',
      args: [],
    );
  }

  /// `save failed`
  String get save_failed {
    return Intl.message(
      'save failed',
      name: 'save_failed',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get about_developer {
    return Intl.message(
      'Developer',
      name: 'about_developer',
      desc: '',
      args: [],
    );
  }

  /// `UI Design`
  String get about_ui_design {
    return Intl.message(
      'UI Design',
      name: 'about_ui_design',
      desc: '',
      args: [],
    );
  }

  /// `Feed Back`
  String get about_feed_back {
    return Intl.message(
      'Feed Back',
      name: 'about_feed_back',
      desc: '',
      args: [],
    );
  }

  /// `comment`
  String get comment_title {
    return Intl.message(
      'comment',
      name: 'comment_title',
      desc: '',
      args: [],
    );
  }

  /// `Please note that you need to open your agent to access the registration page`
  String get register_notice {
    return Intl.message(
      'Please note that you need to open your agent to access the registration page',
      name: 'register_notice',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}