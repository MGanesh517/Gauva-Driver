import '../../data/models/country_code.dart';

final List<Map<String, dynamic>> countryCodes = [
  {
    'code': 'BD',
    'name': 'Bangladesh',
    'phoneCode': '+880',
    'flag': 'https://flagcdn.com/w320/bd.png',
    'languageCode': 'bn',  // Bengali
  },
  {
    'code': 'US',
    'name': 'United States',
    'phoneCode': '+1',
    'flag': 'https://flagcdn.com/w320/us.png',
    'languageCode': 'en',  // English
  },
  {
    'code': 'GB',
    'name': 'United Kingdom',
    'phoneCode': '+44',
    'flag': 'https://flagcdn.com/w320/gb.png',
    'languageCode': 'en',  // English
  },
  {
    'code': 'CA',
    'name': 'Canada',
    'phoneCode': '+1',
    'flag': 'https://flagcdn.com/w320/ca.png',
    'languageCode': 'en',  // English (also French but defaulting to en here)
  },
  {
    'code': 'DE',
    'name': 'Germany',
    'phoneCode': '+49',
    'flag': 'https://flagcdn.com/w320/de.png',
    'languageCode': 'de',  // German
  },

  {
    'code': 'ES',
    'name': 'Spain',
    'phoneCode': '+34',
    'flag': 'https://flagcdn.com/w320/es.png',
    'languageCode': 'es',  // Spanish
  },
  {
    'code': 'AE',
    'name': 'United Arab Emirates',
    'phoneCode': '+971',
    'flag': 'https://flagcdn.com/w320/ae.png', //Assets.countries.aeSvg.path
    'languageCode': 'ar',  // Arabic
  },
  {
    'code': 'EG',
    'name': 'Egypt',
    'phoneCode': '+20',
    'flag': 'https://flagcdn.com/w320/eg.png',
    'languageCode': 'ar', // Arabic
  },
  {
    'code': 'RU',
    'name': 'Russia',
    'phoneCode': '+7',
    'flag': 'https://flagcdn.com/w320/ru.png',
    'languageCode': 'ru',  // Russian
  },
  {
    'code': 'CN',
    'name': 'China',
    'phoneCode': '+86',
    'flag': 'https://flagcdn.com/w320/cn.png',
    'languageCode': 'zh',  // Chinese
  },
  {
    'code': 'IN',
    'name': 'India',
    'phoneCode': '+91',
    'flag': 'https://flagcdn.com/w320/cn.png',
    'languageCode': 'en',
  },
];

List<CountryCode> countryCodeList = countryCodes.map((e) => CountryCode.fromJson(e)).toList();

