import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  String _currentLang = 'en';

  String get currentLang => _currentLang;

  final Map<String, Map<String, String>> translations = {
    'en': {
      //settings
      'settings_title': 'Settings',
      'set_info': 'Manage your account preferences',
      'profile_info': 'Profile Information',
      'update_details': 'Update your personal details',
      'name': 'Name',
      'email': 'Email',
      'email_cannot_change': 'Email cannot be changed',
      'language_pref': 'Language Preferences',
      'choose_language': 'Choose your language',
      'recent_language': 'Recent Language:',
      'save_changes': 'Save Changes',
      'note_language_change': 'Note:\nChanging your language will apply to all lessons.',

      //home screens
      'welcome_user': 'Welcome, {name}',
      'info_home_1': 'Overall Progress',
      'quiz_info_1': 'Quiz Performance',
      'info_home_2': 'Start your journey',
      'info_home_3': 'Begin Learing Indonesian Today',
      'info_home_4': 'Choose from 18 lessons across 3 difficulty levels.',
      'info_home_5': 'Learn essential phrases for airports, hotels, restaurants, shopping, transportation, and medical facilities.',
      'info_home_6': 'transportation, and medical facilities.',
      'button_learn': 'Start Learning',
      'info_home_7': 'Explore Indonesia',
      'info_home_8': 'Popular destination',
      'info_home_9': 'Travel Tips',
      'info_home_10': 'Emergency phrases',
      'info_home_11': 'Explore Wiki',

      // levels
      'level_info': 'Choose your level',
      'level_info_2' : 'Select a difficulty level to begin your journey',
      'lvl1': 'Beginner',
      'lvl1_sub' : 'Basic daily conversation',
      'lvl2': 'Intermediate',
      'lvl2_sub': 'Advanced daily conversation',
      'lvl3': 'Expert',
      'lvl3_sub': 'Complex communication',
      'lvl_button': 'Start Learning',

      //scenario
      'airport': 'Airport',
      'airport_desc': 'Learn airport phrases and tips.',
      'hotel': 'Hotel',
      'hotel_desc': 'Useful sentences for hotel stays.',
      'restaurant': 'Restaurant',
      'restaurant_desc': 'Dining phrases and vocabulary.',
      'shopping': 'Shopping',
      'shopping_desc': 'Words and tips for shopping.',
      'transportation': 'Transportation',
      'transportation_desc': 'Get around using transport phrases.',
      'hospital': 'Hospital',
      'hospital_desc': 'Healthcare and emergency phrases.',
      'start_learning': 'Start Learning',
    },

    'id': {
      //settings
      'settings_title': 'Pengaturan',
      'set_info':'Kelola preferensi akun Anda',
      'profile_info': 'Informasi Profil',
      'update_details': 'Perbarui data pribadi Anda',
      'name': 'Nama',
      'email': 'Email',
      'email_cannot_change': 'Email tidak dapat diubah',
      'language_pref': 'Preferensi Bahasa',
      'choose_language': 'Pilih bahasa Anda',
      'recent_language': 'Bahasa Saat Ini:',
      'save_changes': 'Simpan Perubahan',
      'note_language_change': 'Catatan:\nPerubahan bahasa akan berlaku untuk semua pelajaran.',

      //home screens
      'welcome_user': 'Selamat datang, {name}',
      'info_home_1': 'Progress Keseluruhan',
      'quiz_info_1': 'Performa Kuis',
      'info_home_2': 'Mulai perjalanan Anda',
      'info_home_3': 'Mulai belajar Bahasa Indonesia hari ini',
      'info_home_4': 'Pilih dari 18 pelajaran dalam 3 tingkat kesulitan.',
      'info_home_5': 'Pelajari frasa penting untuk bandara, hotel, restoran, belanja, transportasi, dan fasilitas medis.',
      'info_home_6': 'Transportasi dan fasilitas medis.',
      'button_learn': 'Mulai Belajar',
      'info_home_7': 'Jelajahi Indonesia',
      'info_home_8': 'Destinasi Populer',
      'info_home_9': 'Tips Perjalanan',
      'info_home_10': 'Frasa Darurat',
      'info_home_11': 'Jelajahi Wiki',


      // levels
      'level_info': 'Pilih level Anda',
      'level_info_2': 'Pilih tingkat kesulitan untuk memulai perjalanan Anda',
      'lvl1': 'Pemula',
      'lvl1_sub': 'Percakapan sehari-hari dasar',
      'lvl2': 'Menengah',
      'lvl2_sub': 'Percakapan sehari-hari lanjutan',
      'lvl3': 'Mahir',
      'lvl3_sub': 'Komunikasi kompleks',
      'lvl_button': 'Mulai Belajar',

// scenario
      'airport': 'Bandara',
      'airport_desc': 'Pelajari frasa dan tips di bandara.',
      'hotel': 'Hotel',
      'hotel_desc': 'Kalimat berguna untuk menginap di hotel.',
      'restaurant': 'Restoran',
      'restaurant_desc': 'Frasa dan kosakata makanan.',
      'shopping': 'Belanja',
      'shopping_desc': 'Kata dan tips saat berbelanja.',
      'transportation': 'Transportasi',
      'transportation_desc': 'Frasa untuk bepergian.',
      'hospital': 'Rumah Sakit',
      'hospital_desc': 'Frasa kesehatan dan darurat.',
      'start_learning': 'Mulai Belajar',
    },
    'es': {
      // settings
      'settings_title': 'Configuración',
      'set_info': 'Administra las preferencias de tu cuenta',
      'profile_info': 'Información del perfil',
      'update_details': 'Actualiza tus datos personales',
      'name': 'Nombre',
      'email': 'Correo electrónico',
      'email_cannot_change': 'El correo electrónico no se puede cambiar',
      'language_pref': 'Preferencias de idioma',
      'choose_language': 'Elige tu idioma',
      'recent_language': 'Idioma actual:',
      'save_changes': 'Guardar cambios',
      'note_language_change': 'Nota:\nEl cambio de idioma se aplicará a todas las lecciones.',

      // home screens
      'welcome_user': 'Bienvenido, {name}',
      'info_home_1': 'Progreso general',
      'quiz_info_1': 'Rendimiento del cuestionario',
      'info_home_2': 'Comienza tu viaje',
      'info_home_3': 'Empieza a aprender indonesio hoy',
      'info_home_4': 'Elige entre 18 lecciones en 3 niveles de dificultad.',
      'info_home_5': 'Aprende frases esenciales para aeropuertos, hoteles, restaurantes, compras, transporte y servicios médicos.',
      'info_home_6': 'Transporte y servicios médicos.',
      'button_learn': 'Comenzar a aprender',
      'info_home_7': 'Explorar Indonesia',
      'info_home_8': 'Destinos populares',
      'info_home_9': 'Consejos de viaje',
      'info_home_10': 'Frases de emergencia',
      'info_home_11': 'Explorar Wiki',

      // levels
      'level_info': 'Elige tu nivel',
      'level_info_2': 'Selecciona un nivel de dificultad para comenzar tu viaje',
      'lvl1': 'Principiante',
      'lvl1_sub': 'Conversación diaria básica',
      'lvl2': 'Intermedio',
      'lvl2_sub': 'Conversación diaria avanzada',
      'lvl3': 'Experto',
      'lvl3_sub': 'Comunicación compleja',
      'lvl_button': 'Comenzar a aprender',

// scenario
      'airport': 'Aeropuerto',
      'airport_desc': 'Aprende frases y consejos del aeropuerto.',
      'hotel': 'Hotel',
      'hotel_desc': 'Frases útiles para estadías en hotel.',
      'restaurant': 'Restaurante',
      'restaurant_desc': 'Frases y vocabulario de comida.',
      'shopping': 'Compras',
      'shopping_desc': 'Palabras y consejos para comprar.',
      'transportation': 'Transporte',
      'transportation_desc': 'Frases para moverse.',
      'hospital': 'Hospital',
      'hospital_desc': 'Frases médicas y de emergencia.',
      'start_learning': 'Comenzar a aprender',
    },
    'ru': {
      // settings
      'settings_title': 'Настройки',
      'set_info': 'Управление настройками аккаунта',
      'profile_info': 'Информация профиля',
      'update_details': 'Обновите личные данные',
      'name': 'Имя',
      'email': 'Электронная почта',
      'email_cannot_change': 'Электронную почту нельзя изменить',
      'language_pref': 'Языковые настройки',
      'choose_language': 'Выберите язык',
      'recent_language': 'Текущий язык:',
      'save_changes': 'Сохранить изменения',
      'note_language_change': 'Примечание:\nСмена языка применится ко всем урокам.',

      // home screens
      'welcome_user': 'Добро пожаловать, {name}',
      'info_home_1': 'Общий прогресс',
      'quiz_info_1': 'Результаты тестов',
      'info_home_2': 'Начните своё путешествие',
      'info_home_3': 'Начните изучать индонезийский уже сегодня',
      'info_home_4': 'Выберите из 18 уроков в 3 уровнях сложности.',
      'info_home_5': 'Изучите важные фразы для аэропортов, отелей, ресторанов, покупок, транспорта и медицинских услуг.',
      'info_home_6': 'Транспорт и медицинские услуги.',
      'button_learn': 'Начать обучение',
      'info_home_7': 'Исследуйте Индонезию',
      'info_home_8': 'Популярные направления',
      'info_home_9': 'Советы путешественникам',
      'info_home_10': 'Экстренные фразы',
      'info_home_11': 'Открыть Wiki',

      // levels
      'level_info': 'Выберите уровень',
      'level_info_2': 'Выберите уровень сложности, чтобы начать',
      'lvl1': 'Начальный',
      'lvl1_sub': 'Базовый разговорный уровень',
      'lvl2': 'Средний',
      'lvl2_sub': 'Продвинутый разговорный уровень',
      'lvl3': 'Продвинутый',
      'lvl3_sub': 'Сложная коммуникация',
      'lvl_button': 'Начать обучение',

// scenario
      'airport': 'Аэропорт',
      'airport_desc': 'Изучите фразы и советы для аэропорта.',
      'hotel': 'Отель',
      'hotel_desc': 'Полезные фразы для проживания в отеле.',
      'restaurant': 'Ресторан',
      'restaurant_desc': 'Фразы и словарный запас для еды.',
      'shopping': 'Покупки',
      'shopping_desc': 'Слова и советы для покупок.',
      'transportation': 'Транспорт',
      'transportation_desc': 'Фразы для передвижения.',
      'hospital': 'Больница',
      'hospital_desc': 'Медицинские и экстренные фразы.',
      'start_learning': 'Начать обучение',
    },
    'zh': {
      // settings
      'settings_title': '设置',
      'set_info': '管理您的账户偏好',
      'profile_info': '个人信息',
      'update_details': '更新您的个人信息',
      'name': '姓名',
      'email': '电子邮箱',
      'email_cannot_change': '电子邮箱无法更改',
      'language_pref': '语言偏好',
      'choose_language': '选择您的语言',
      'recent_language': '当前语言：',
      'save_changes': '保存更改',
      'note_language_change': '注意：\n更改语言将应用于所有课程。',

      // home screens
      'welcome_user': '欢迎，{name}',
      'info_home_1': '总体进度',
      'quiz_info_1': '测验表现',
      'info_home_2': '开始您的旅程',
      'info_home_3': '今天开始学习印尼语',
      'info_home_4': '从18节课程中选择，涵盖3个难度等级。',
      'info_home_5': '学习机场、酒店、餐厅、购物、交通和医疗场景中的常用短语。',
      'info_home_6': '交通和医疗相关内容。',
      'button_learn': '开始学习',
      'info_home_7': '探索印度尼西亚',
      'info_home_8': '热门目的地',
      'info_home_9': '旅行小贴士',
      'info_home_10': '紧急用语',
      'info_home_11': '探索百科',

      // levels
      'level_info': '选择你的级别',
      'level_info_2': '选择难度级别开始你的旅程',
      'lvl1': '初级',
      'lvl1_sub': '基础日常对话',
      'lvl2': '中级',
      'lvl2_sub': '进阶日常对话',
      'lvl3': '高级',
      'lvl3_sub': '复杂交流',
      'lvl_button': '开始学习',

// scenario
      'airport': '机场',
      'airport_desc': '学习机场常用短语和技巧。',
      'hotel': '酒店',
      'hotel_desc': '酒店住宿常用句子。',
      'restaurant': '餐厅',
      'restaurant_desc': '餐饮短语和词汇。',
      'shopping': '购物',
      'shopping_desc': '购物用词和技巧。',
      'transportation': '交通',
      'transportation_desc': '出行常用短语。',
      'hospital': '医院',
      'hospital_desc': '医疗和紧急短语。',
      'start_learning': '开始学习',
    },
  };

  String t(String key, {Map<String, String>? params}) {
    String text = translations[_currentLang]?[key] ?? key;

    if (params != null) {
      params.forEach((k, v) {
        text = text.replaceAll('{$k}', v);
      });
    }

    return text;
  }

  Future<void> changeLanguage(String lang) async {
    _currentLang = lang;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lang', lang);
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString('lang') ?? 'en';
  }
}