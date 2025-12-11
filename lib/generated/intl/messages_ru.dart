// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(msg) => "${msg} Все права защищены.";

  static String m1(msg) => "Вы уверены, что хотите ${msg} из приложения?";

  static String m2(msg) => "Ошибка: ${msg}";

  static String m3(length) => "Должно быть не менее ${length} символов";

  static String m4(secondsRemaining) =>
      "Отправить код повторно через 00:${secondsRemaining}";

  static String m5(length) => "Используйте не менее ${length} символов";

  static String m6(method) =>
      "оплачено через ${method}. Надеемся, поездка вам понравилась! Не забудьте оставить отзыв.";

  static String m7(amount) =>
      "Успешно! Вы запросили вывод ${amount}. Средства будут переведены на выбранный вами счет в ближайшее время.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept_ride": MessageLookupByLibrary.simpleMessage("Принять поездку"),
    "account": MessageLookupByLibrary.simpleMessage("Аккаунт"),
    "activity": MessageLookupByLibrary.simpleMessage("Активность"),
    "add_balance_to_your_wallet": MessageLookupByLibrary.simpleMessage(
      "Добавьте баланс в ваш кошелек",
    ),
    "add_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Добавить документы водителя",
    ),
    "add_driver_personal_info": MessageLookupByLibrary.simpleMessage(
      "Добавить личную информацию водителя",
    ),
    "add_new": MessageLookupByLibrary.simpleMessage("Добавить новый"),
    "add_payment_gateway": MessageLookupByLibrary.simpleMessage(
      "Добавить платежный шлюз",
    ),
    "add_wallet": MessageLookupByLibrary.simpleMessage("Добавить кошелек"),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "all_field_required": MessageLookupByLibrary.simpleMessage(
      "Все поля обязательны для заполнения",
    ),
    "all_rights_reserved": m0,
    "all_set_start_ride": MessageLookupByLibrary.simpleMessage(
      "Все готово? Начните поездку сейчас",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Разрешить"),
    "amount": MessageLookupByLibrary.simpleMessage("Сумма"),
    "app_encountered_unexpected_error": MessageLookupByLibrary.simpleMessage(
      "Приложение столкнулось с неожиданной ошибкой и было закрыто. Это могло произойти из-за недостаточной памяти устройства, ошибки в приложении или повреждённого файла. Пожалуйста, перезапустите приложение или переустановите его, если проблема продолжится.",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("Применить"),
    "are_you_sure_msg": m1,
    "arrived_pickup_point": MessageLookupByLibrary.simpleMessage(
      "Вы прибыли к точке посадки",
    ),
    "average_rating": MessageLookupByLibrary.simpleMessage("Средний рейтинг"),
    "bad_certificate_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Неверный сертификат с API-сервером",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Неверный запрос"),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancel_ride": MessageLookupByLibrary.simpleMessage("Отменить поездку"),
    "cancel_subtitle": MessageLookupByLibrary.simpleMessage(
      "Сообщите нам причину отмены поездки.",
    ),
    "cancel_the_ride": MessageLookupByLibrary.simpleMessage("Отменить поездку"),
    "cancel_title": MessageLookupByLibrary.simpleMessage(
      "Сообщите, почему вы отменяете поездку",
    ),
    "card_number": MessageLookupByLibrary.simpleMessage("Номер карты"),
    "cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Имя держателя карты",
    ),
    "change_password": MessageLookupByLibrary.simpleMessage("Сменить пароль"),
    "close": MessageLookupByLibrary.simpleMessage("ЗАКРЫТЬ"),
    "complete_ride": MessageLookupByLibrary.simpleMessage("Завершить поездку"),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirm_new_password": MessageLookupByLibrary.simpleMessage(
      "Подтвердите новый пароль",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Подтвердите пароль",
    ),
    "confirm_pay": MessageLookupByLibrary.simpleMessage("Подтвердить оплату"),
    "confirm_pickup": MessageLookupByLibrary.simpleMessage(
      "Подтвердить посадку",
    ),
    "connection_error_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Ошибка соединения с API-сервером",
    ),
    "connection_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Превышено время ожидания соединения с API-сервером",
    ),
    "contact_support": MessageLookupByLibrary.simpleMessage(
      "Связаться с поддержкой",
    ),
    "country": MessageLookupByLibrary.simpleMessage("Страна"),
    "current_balance": MessageLookupByLibrary.simpleMessage("Текущий баланс"),
    "current_password": MessageLookupByLibrary.simpleMessage("Текущий пароль"),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "delete_account": MessageLookupByLibrary.simpleMessage("Удалить аккаунт"),
    "delete_account_confirmation": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить свою учетную запись?",
    ),
    "delete_account_warning": MessageLookupByLibrary.simpleMessage(
      "Это действие является окончательным и не может быть отменено.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Пункт назначения"),
    "details": MessageLookupByLibrary.simpleMessage("Детали"),
    "discount": MessageLookupByLibrary.simpleMessage("Скидка"),
    "double_check_rider": MessageLookupByLibrary.simpleMessage(
      "Проверьте имя пассажира и подтвердите его пункт назначения перед продолжением.",
    ),
    "driver_documents": MessageLookupByLibrary.simpleMessage(
      "Документы водителя",
    ),
    "driving_license": MessageLookupByLibrary.simpleMessage(
      "Водительское удостоверение",
    ),
    "driving_license_required": MessageLookupByLibrary.simpleMessage(
      "Водительское удостоверение обязательно",
    ),
    "either_phone_number_is_null_or_password_is_empty":
        MessageLookupByLibrary.simpleMessage(
          "Номер телефона пустой или пароль пустой",
        ),
    "email": MessageLookupByLibrary.simpleMessage("Электронная почта"),
    "email_label": MessageLookupByLibrary.simpleMessage("Эл. почта"),
    "emergency_phone": MessageLookupByLibrary.simpleMessage(
      "Телефон для экстренной связи",
    ),
    "enterPhoneDes": MessageLookupByLibrary.simpleMessage(
      "Введите свой номер телефона, чтобы продолжить поездку и получать обновления.",
    ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Введите номер телефона",
    ),
    "enter_3_digit_cvv": MessageLookupByLibrary.simpleMessage(
      "Введите 3-значный CVV",
    ),
    "enter_a_valid_amount": MessageLookupByLibrary.simpleMessage(
      "Введите допустимую сумму",
    ),
    "enter_amount": MessageLookupByLibrary.simpleMessage("Введите сумму"),
    "enter_cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Введите имя держателя карты",
    ),
    "enter_details_complete_profile": MessageLookupByLibrary.simpleMessage(
      "Введите свои данные, чтобы завершить профиль и улучшить свой опыт.",
    ),
    "enter_experience": MessageLookupByLibrary.simpleMessage(
      "Опишите ваш опыт!",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Введите ваш пароль",
    ),
    "enter_password_description": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите пароль вашей учетной записи, чтобы продолжить.",
    ),
    "enter_plate_number": MessageLookupByLibrary.simpleMessage(
      "Введите номерной знак",
    ),
    "enter_valid_card_number": MessageLookupByLibrary.simpleMessage(
      "Введите действительный номер карты",
    ),
    "enter_vehicle_name": MessageLookupByLibrary.simpleMessage(
      "Введите название транспортного средства",
    ),
    "error_with_msg": m2,
    "estimated_time": MessageLookupByLibrary.simpleMessage("Примерное время"),
    "exit": MessageLookupByLibrary.simpleMessage("Выход"),
    "exp_date": MessageLookupByLibrary.simpleMessage("Срок действия"),
    "expiryDate": MessageLookupByLibrary.simpleMessage("Срок действия"),
    "field_required": MessageLookupByLibrary.simpleMessage(
      "Это поле обязательно для заполнения",
    ),
    "find_you_faster": MessageLookupByLibrary.simpleMessage(
      "Давайте найдем вас быстрее!",
    ),
    "find_you_faster_msg": MessageLookupByLibrary.simpleMessage(
      "Включите доступ к геолокации, чтобы быстро найти ближайших водителей.",
    ),
    "follow_directions_comfortable": MessageLookupByLibrary.simpleMessage(
      "Следуйте указаниям, сохраняйте спокойствие и создавайте комфортные условия поездки.",
    ),
    "forbidden_access_please_login_again": MessageLookupByLibrary.simpleMessage(
      "Доступ запрещён. Пожалуйста, войдите снова.",
    ),
    "form_is_not_valid": MessageLookupByLibrary.simpleMessage(
      "Форма недействительна",
    ),
    "full_name": MessageLookupByLibrary.simpleMessage("Полное имя"),
    "gender": MessageLookupByLibrary.simpleMessage("Пол"),
    "gender_female": MessageLookupByLibrary.simpleMessage("Женский"),
    "gender_label": MessageLookupByLibrary.simpleMessage("Пол"),
    "gender_male": MessageLookupByLibrary.simpleMessage("Мужской"),
    "gender_other": MessageLookupByLibrary.simpleMessage("Другой"),
    "gender_required": MessageLookupByLibrary.simpleMessage("Пол обязателен"),
    "gender_select": MessageLookupByLibrary.simpleMessage("Выберите пол"),
    "go_back_to_ride": MessageLookupByLibrary.simpleMessage(
      "Вернуться к поездке",
    ),
    "go_to_login": MessageLookupByLibrary.simpleMessage("Перейти к входу"),
    "go_to_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Перейти к месту посадки",
    ),
    "grant_permission": MessageLookupByLibrary.simpleMessage(
      "Предоставить доступ",
    ),
    "helloText": MessageLookupByLibrary.simpleMessage("Здравствуйте..."),
    "home": MessageLookupByLibrary.simpleMessage("Главная"),
    "id": MessageLookupByLibrary.simpleMessage("ID: "),
    "initializing": MessageLookupByLibrary.simpleMessage("Инициализация..."),
    "insertAllData": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите все данные",
    ),
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Внутренняя ошибка сервера",
    ),
    "issueSubmitted": MessageLookupByLibrary.simpleMessage(
      "Ваша проблема успешно отправлена",
    ),
    "km": MessageLookupByLibrary.simpleMessage("км"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "lets_ride": MessageLookupByLibrary.simpleMessage("Поехали"),
    "location": MessageLookupByLibrary.simpleMessage("Местоположение"),
    "location_permission_msg": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, включите доступ к местоположению для использования этой функции.",
    ),
    "location_permission_needed": MessageLookupByLibrary.simpleMessage(
      "Требуется доступ к геолокации",
    ),
    "log_out": MessageLookupByLibrary.simpleMessage("Выйти"),
    "loggingInSomewhereElse": MessageLookupByLibrary.simpleMessage(
      "Вход с другого устройства",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Войти"),
    "loginSignup": MessageLookupByLibrary.simpleMessage(
      "Войти / Зарегистрироваться",
    ),
    "login_with_your_password": MessageLookupByLibrary.simpleMessage(
      "Войдите с помощью пароля",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Метод: "),
    "min": MessageLookupByLibrary.simpleMessage("мин"),
    "min_length_error": m3,
    "mobile_number": MessageLookupByLibrary.simpleMessage("Номер телефона"),
    "my_profile": MessageLookupByLibrary.simpleMessage("Мой профиль"),
    "name_label": MessageLookupByLibrary.simpleMessage("Имя"),
    "new_password": MessageLookupByLibrary.simpleMessage("Новый пароль"),
    "next": MessageLookupByLibrary.simpleMessage("Далее"),
    "nid_image_required": MessageLookupByLibrary.simpleMessage(
      "Требуется изображение NID",
    ),
    "nid_photo": MessageLookupByLibrary.simpleMessage(
      "Фото удостоверения личности",
    ),
    "no_address_found": MessageLookupByLibrary.simpleMessage("Адрес не найден"),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage("Пока нет карт!"),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "Отсутствует интернет-соединение.",
    ),
    "no_internet_connection_please_check": MessageLookupByLibrary.simpleMessage(
      "Отсутствует интернет-соединение. Пожалуйста, проверьте подключение.",
    ),
    "no_payment_methods_available": MessageLookupByLibrary.simpleMessage(
      "Нет доступных способов оплаты",
    ),
    "no_rides_yet": MessageLookupByLibrary.simpleMessage("Пока нет поездок."),
    "no_service_available": MessageLookupByLibrary.simpleMessage(
      "Сервис недоступен",
    ),
    "no_transactions_found": MessageLookupByLibrary.simpleMessage(
      "Транзакции не найдены",
    ),
    "no_wallet_data_available": MessageLookupByLibrary.simpleMessage(
      "Нет данных кошелька",
    ),
    "offline": MessageLookupByLibrary.simpleMessage("Не в сети"),
    "or_select_avatar": MessageLookupByLibrary.simpleMessage(
      "Или выберите аватар из списка ниже:",
    ),
    "otp_enter_title": MessageLookupByLibrary.simpleMessage("Введите ваш OTP"),
    "otp_input_hint": MessageLookupByLibrary.simpleMessage("Введите OTP"),
    "otp_resend": MessageLookupByLibrary.simpleMessage("Отправить снова"),
    "otp_resend_timer": m4,
    "otp_save_button": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "otp_sent_message": MessageLookupByLibrary.simpleMessage(
      "Мы отправили код OTP на ваш номер телефона",
    ),
    "otp_title_short": MessageLookupByLibrary.simpleMessage("OTP"),
    "password_hint": MessageLookupByLibrary.simpleMessage(
      "Установите надёжный пароль",
    ),
    "password_label": MessageLookupByLibrary.simpleMessage("Пароль"),
    "password_mismatch": MessageLookupByLibrary.simpleMessage(
      "Пароли не совпадают.",
    ),
    "password_requirements": m5,
    "payment_completed": MessageLookupByLibrary.simpleMessage(
      "Спасибо! Оплата завершена",
    ),
    "payment_confirmation": m6,
    "payment_gateway": MessageLookupByLibrary.simpleMessage("Платёжный шлюз"),
    "payment_method": MessageLookupByLibrary.simpleMessage("Способ оплаты"),
    "payment_received": MessageLookupByLibrary.simpleMessage("Платеж получен"),
    "payment_withdraw": MessageLookupByLibrary.simpleMessage("Снятие средств"),
    "payout_method": MessageLookupByLibrary.simpleMessage("Метод выплаты"),
    "personal_info": MessageLookupByLibrary.simpleMessage("Личная информация"),
    "phoneMinLengthError": MessageLookupByLibrary.simpleMessage(
      "Номер телефона должен содержать не менее 6 цифр",
    ),
    "phoneNo": MessageLookupByLibrary.simpleMessage("Номер телефона"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage(
      "Выбрать из галереи",
    ),
    "pick_a_date": MessageLookupByLibrary.simpleMessage("Выберите дату"),
    "pickup": MessageLookupByLibrary.simpleMessage("Место посадки"),
    "pickup_rider": MessageLookupByLibrary.simpleMessage("Забрать пассажира"),
    "plate_number": MessageLookupByLibrary.simpleMessage("Номерной знак"),
    "please_enter_amount": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите сумму",
    ),
    "please_select_payment_type": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите способ оплаты",
    ),
    "please_wait": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, подождите...",
    ),
    "privacy_policy": MessageLookupByLibrary.simpleMessage(
      "Политика конфиденциальности",
    ),
    "production_year": MessageLookupByLibrary.simpleMessage("Год выпуска"),
    "profile_image": MessageLookupByLibrary.simpleMessage("Фото профиля"),
    "profile_image_required": MessageLookupByLibrary.simpleMessage(
      "Фото профиля обязательно",
    ),
    "profile_submitted_reviewed": MessageLookupByLibrary.simpleMessage(
      "Ваш профиль был отправлен и находится на рассмотрении. Вы будете уведомлены, когда он будет одобрен.",
    ),
    "profile_under_review": MessageLookupByLibrary.simpleMessage(
      "Ваш профиль на рассмотрении",
    ),
    "reached_destination": MessageLookupByLibrary.simpleMessage(
      "Пункт назначения достигнут",
    ),
    "reached_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "Вы прибыли в пункт назначения пассажира.",
    ),
    "reached_pickup_wait": MessageLookupByLibrary.simpleMessage(
      "Вы прибыли на место посадки. Пожалуйста, подождите несколько минут, пока пассажир не подойдет к вашему автомобилю.",
    ),
    "receive_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Превышено время ожидания получения от API-сервера",
    ),
    "received_invalid_response_from_server":
        MessageLookupByLibrary.simpleMessage(
          "Получен неверный ответ от сервера.",
        ),
    "registration_done": MessageLookupByLibrary.simpleMessage(
      "Регистрация ЗАВЕРШЕНА!",
    ),
    "reportIssue": MessageLookupByLibrary.simpleMessage("Сообщить о проблеме"),
    "reportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Расскажите нам, что пошло не так. Мы сразу же разберёмся.",
    ),
    "reportIssueTitle": MessageLookupByLibrary.simpleMessage(
      "Что-то пошло не так? Сообщите о проблеме",
    ),
    "reportType": MessageLookupByLibrary.simpleMessage("Тип отчёта"),
    "requestEntityTooLarge": MessageLookupByLibrary.simpleMessage(
      "Слишком большой объект запроса",
    ),
    "request_timed_out_please_try_again": MessageLookupByLibrary.simpleMessage(
      "Время запроса истекло. Пожалуйста, попробуйте снова.",
    ),
    "request_to_api_server_was_cancelled": MessageLookupByLibrary.simpleMessage(
      "Запрос к API-серверу был отменён",
    ),
    "resource_not_found": MessageLookupByLibrary.simpleMessage(
      "Ресурс не найден.",
    ),
    "rideCharge": MessageLookupByLibrary.simpleMessage("Стоимость поездки"),
    "rideDetails": MessageLookupByLibrary.simpleMessage("Детали поездки"),
    "ride_complete": MessageLookupByLibrary.simpleMessage("Поездка завершена"),
    "ride_feedback_prompt": MessageLookupByLibrary.simpleMessage(
      "Надеемся, поездка прошла гладко. Пожалуйста, оплатите и оцените поездку.",
    ),
    "ride_history": MessageLookupByLibrary.simpleMessage("История поездок"),
    "ride_preferences": MessageLookupByLibrary.simpleMessage(
      "Настройки поездки",
    ),
    "ride_preferences_description": MessageLookupByLibrary.simpleMessage(
      "Выберите тип поездки, который вам подходит.",
    ),
    "ride_requested": MessageLookupByLibrary.simpleMessage("Поездка запрошена"),
    "ride_started": MessageLookupByLibrary.simpleMessage(
      "Ваша поездка началась!",
    ),
    "rider_waiting_move_now": MessageLookupByLibrary.simpleMessage(
      "Пассажир ждёт — Поехали",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "searching_for_driver": MessageLookupByLibrary.simpleMessage(
      "Поиск доступного водителя..",
    ),
    "see_you_next_ride": MessageLookupByLibrary.simpleMessage(
      "Надеемся увидеть вас снова в следующей поездке!",
    ),
    "selectReportType": MessageLookupByLibrary.simpleMessage(
      "Выберите тип отчёта",
    ),
    "select_a_country": MessageLookupByLibrary.simpleMessage("Выберите страну"),
    "select_card_type": MessageLookupByLibrary.simpleMessage(
      "Выберите тип карты",
    ),
    "select_payment_method": MessageLookupByLibrary.simpleMessage(
      "Выберите способ оплаты",
    ),
    "select_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Выберите место посадки",
    ),
    "select_profile_image": MessageLookupByLibrary.simpleMessage(
      "Выберите изображение профиля",
    ),
    "select_service": MessageLookupByLibrary.simpleMessage("Выберите услугу!"),
    "select_vehicle_color": MessageLookupByLibrary.simpleMessage(
      "Выберите цвет транспортного средства",
    ),
    "select_vehicle_type": MessageLookupByLibrary.simpleMessage(
      "Выберите тип транспортного средства",
    ),
    "send_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Превышено время ожидания отправки на API-сервер",
    ),
    "service_charge": MessageLookupByLibrary.simpleMessage(
      "Плата за обслуживание",
    ),
    "share_experience": MessageLookupByLibrary.simpleMessage(
      "Поделитесь своим опытом!",
    ),
    "skip_for_now": MessageLookupByLibrary.simpleMessage("Пропустить сейчас"),
    "something_went_wrong": MessageLookupByLibrary.simpleMessage(
      "Что-то пошло не так",
    ),
    "something_went_wrong_exclamation": MessageLookupByLibrary.simpleMessage(
      "Что-то пошло не так!",
    ),
    "start_journey_navigation": MessageLookupByLibrary.simpleMessage(
      "Начните поездку, следуя навигации в приложении. Убедитесь, что обе стороны чувствуют себя комфортно перед началом.",
    ),
    "start_ride": MessageLookupByLibrary.simpleMessage("Начать поездку"),
    "status": MessageLookupByLibrary.simpleMessage("Статус"),
    "stayOnThisDevice": MessageLookupByLibrary.simpleMessage(
      "Остаться на этом устройстве",
    ),
    "stop_point": MessageLookupByLibrary.simpleMessage("Промежуточная точка"),
    "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "takeAPhoto": MessageLookupByLibrary.simpleMessage("Сделать фото"),
    "tap_to_confirm_arrival": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы подтвердить прибытие",
    ),
    "tap_to_start_ride": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы начать поездку",
    ),
    "terms_conditions": MessageLookupByLibrary.simpleMessage(
      "Условия и положения",
    ),
    "textCopied": MessageLookupByLibrary.simpleMessage("Текст скопирован"),
    "thanksForReporting": MessageLookupByLibrary.simpleMessage(
      "Спасибо за сообщение. Наша команда рассмотрит вашу проблему и свяжется с вами в ближайшее время.",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Тема"),
    "time_to_pickup": MessageLookupByLibrary.simpleMessage(
      "Время забрать пассажира! Следуйте навигации и прибудьте без задержек",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Сегодня"),
    "todays_activity": MessageLookupByLibrary.simpleMessage(
      "Сегодняшняя активность",
    ),
    "todays_earning": MessageLookupByLibrary.simpleMessage(
      "Заработок за сегодня",
    ),
    "top_up_your_wallet_securely_and_enjoy_seamless_payments":
        MessageLookupByLibrary.simpleMessage(
          "Пополните кошелек безопасно и наслаждайтесь беспроблемными платежами.",
        ),
    "total_amount": MessageLookupByLibrary.simpleMessage("Общая сумма"),
    "total_distance": MessageLookupByLibrary.simpleMessage("Общий пробег"),
    "total_rides": MessageLookupByLibrary.simpleMessage("Всего поездок"),
    "transactions": MessageLookupByLibrary.simpleMessage("Транзакции"),
    "trip_ended_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "Поездка завершена, так как пассажир достиг места назначения.",
    ),
    "trip_ended_wait_payment": MessageLookupByLibrary.simpleMessage(
      "Поездка завершена. Подождите, пока пассажир завершит оплату перед закрытием поездки.",
    ),
    "trips": MessageLookupByLibrary.simpleMessage("Поездки"),
    "type_a_message": MessageLookupByLibrary.simpleMessage("Введите сообщение"),
    "unauthorized_access_please_login_again":
        MessageLookupByLibrary.simpleMessage(
          "Неавторизованный доступ. Пожалуйста, войдите снова.",
        ),
    "unexpected_application_crash": MessageLookupByLibrary.simpleMessage(
      "Неожиданное завершение работы приложения",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "Произошла непредвиденная ошибка",
    ),
    "unexpected_response_format": MessageLookupByLibrary.simpleMessage(
      "Непредвиденный формат ответа",
    ),
    "update": MessageLookupByLibrary.simpleMessage("Обновить"),
    "upload": MessageLookupByLibrary.simpleMessage("Загрузить"),
    "upload_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Загрузите документы водителя для завершения верификации и начала работы. Быстро, просто и безопасно!",
    ),
    "upload_image": MessageLookupByLibrary.simpleMessage(
      "Загрузить изображение",
    ),
    "use_otp_instead": MessageLookupByLibrary.simpleMessage(
      "Используйте OTP вместо этого",
    ),
    "use_your_password_here": MessageLookupByLibrary.simpleMessage(
      "Используйте свой пароль здесь",
    ),
    "validation_error": MessageLookupByLibrary.simpleMessage(
      "Ошибка валидации",
    ),
    "vehicle_color": MessageLookupByLibrary.simpleMessage(
      "Цвет транспортного средства",
    ),
    "vehicle_name": MessageLookupByLibrary.simpleMessage(
      "Название транспортного средства",
    ),
    "vehicle_papers": MessageLookupByLibrary.simpleMessage(
      "Документы на транспортное средство",
    ),
    "vehicle_papers_required": MessageLookupByLibrary.simpleMessage(
      "Документы на транспортное средство обязательны",
    ),
    "vehicle_plate_number": MessageLookupByLibrary.simpleMessage(
      "Номерной знак транспортного средства",
    ),
    "vehicle_production_year": MessageLookupByLibrary.simpleMessage(
      "Год выпуска транспортного средства",
    ),
    "vehicle_type": MessageLookupByLibrary.simpleMessage(
      "Тип транспортного средства",
    ),
    "view_all": MessageLookupByLibrary.simpleMessage("Посмотреть всё"),
    "wallet": MessageLookupByLibrary.simpleMessage("Кошелек"),
    "wallet_balance": MessageLookupByLibrary.simpleMessage("Баланс кошелька"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("С возвращением!"),
    "withdraw": MessageLookupByLibrary.simpleMessage("Снять"),
    "withdraw_history": MessageLookupByLibrary.simpleMessage("История выводов"),
    "withdraw_instruction": MessageLookupByLibrary.simpleMessage(
      "Вы это заработали! Выберите, куда отправить деньги, и нажмите снять.",
    ),
    "withdraw_your_earnings": MessageLookupByLibrary.simpleMessage(
      "Снять ваш доход",
    ),
    "withdrawal_request_success": m7,
    "withdrawal_success": MessageLookupByLibrary.simpleMessage(
      "Запрос на вывод успешно отправлен!",
    ),
    "writeIssueDetails": MessageLookupByLibrary.simpleMessage(
      "Опишите проблему",
    ),
    "you_can_cancel_ride_in": MessageLookupByLibrary.simpleMessage(
      "Вы можете отменить поездку через",
    ),
    "yourAccountAlreadyActive": MessageLookupByLibrary.simpleMessage(
      "Ваша учетная запись уже активна на другом устройстве. Чтобы использовать её здесь, с другого устройства будет выполнен выход.",
    ),
    "your_balance": MessageLookupByLibrary.simpleMessage("Ваш баланс"),
    "your_best_photo_here": MessageLookupByLibrary.simpleMessage(
      "Ваша лучшая фотография здесь",
    ),
    "your_ride_complete": MessageLookupByLibrary.simpleMessage(
      "Поездка завершена",
    ),
  };
}
