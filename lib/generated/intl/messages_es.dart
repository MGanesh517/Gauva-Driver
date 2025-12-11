// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(msg) => "${msg} Todos los derechos reservados.";

  static String m1(msg) =>
      "¿Estás seguro de que quieres ${msg} de la aplicación?";

  static String m2(msg) => "Error: ${msg}";

  static String m3(length) => "Debe tener al menos ${length} caracteres";

  static String m4(secondsRemaining) =>
      "Reenviar código en 00:${secondsRemaining}";

  static String m5(length) => "Utilice al menos ${length} caracteres";

  static String m6(method) =>
      "pagado con ${method}. ¡Esperamos que hayas tenido un gran viaje! No olvides dejar una calificación.";

  static String m7(amount) =>
      "¡Éxito! Has solicitado un retiro de ${amount}. Los fondos se transferirán a tu cuenta seleccionada en breve.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "accept_ride": MessageLookupByLibrary.simpleMessage("Aceptar viaje"),
    "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "activity": MessageLookupByLibrary.simpleMessage("Actividad"),
    "add_balance_to_your_wallet": MessageLookupByLibrary.simpleMessage(
      "Agrega saldo a tu billetera",
    ),
    "add_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Agregar documentos del conductor",
    ),
    "add_driver_personal_info": MessageLookupByLibrary.simpleMessage(
      "Agregar información personal del conductor",
    ),
    "add_new": MessageLookupByLibrary.simpleMessage("Agregar nuevo"),
    "add_payment_gateway": MessageLookupByLibrary.simpleMessage(
      "Agregar pasarela de pago",
    ),
    "add_wallet": MessageLookupByLibrary.simpleMessage(
      "Agregar a la billetera",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Dirección"),
    "all_field_required": MessageLookupByLibrary.simpleMessage(
      "Todos los campos son obligatorios",
    ),
    "all_rights_reserved": m0,
    "all_set_start_ride": MessageLookupByLibrary.simpleMessage(
      "¿Todo listo? Comienza el viaje ahora",
    ),
    "allow": MessageLookupByLibrary.simpleMessage("Permitir"),
    "amount": MessageLookupByLibrary.simpleMessage("Cantidad"),
    "app_encountered_unexpected_error": MessageLookupByLibrary.simpleMessage(
      "La aplicación encontró un error inesperado y tuvo que cerrarse. Esto podría deberse a memoria insuficiente del dispositivo, un error en la aplicación o un archivo dañado. Por favor, reinicie la aplicación o vuelva a instalarla si el problema continúa.",
    ),
    "apply": MessageLookupByLibrary.simpleMessage("Aplicar"),
    "are_you_sure_msg": m1,
    "arrived_pickup_point": MessageLookupByLibrary.simpleMessage(
      "Has llegado al punto de recogida",
    ),
    "average_rating": MessageLookupByLibrary.simpleMessage(
      "Calificación promedio",
    ),
    "bad_certificate_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Certificado inválido con el servidor API",
    ),
    "bad_request": MessageLookupByLibrary.simpleMessage("Solicitud incorrecta"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancel_ride": MessageLookupByLibrary.simpleMessage("Cancelar viaje"),
    "cancel_subtitle": MessageLookupByLibrary.simpleMessage(
      "Cuéntanos la razón por la que cancelaste tu viaje.",
    ),
    "cancel_the_ride": MessageLookupByLibrary.simpleMessage(
      "Cancelar el viaje",
    ),
    "cancel_title": MessageLookupByLibrary.simpleMessage(
      "Dinos por qué estás cancelando el viaje",
    ),
    "card_number": MessageLookupByLibrary.simpleMessage("Número de tarjeta"),
    "cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Nombre del titular de la tarjeta",
    ),
    "change_password": MessageLookupByLibrary.simpleMessage(
      "Cambiar contraseña",
    ),
    "close": MessageLookupByLibrary.simpleMessage("CERRAR"),
    "complete_ride": MessageLookupByLibrary.simpleMessage("Completar viaje"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirm_new_password": MessageLookupByLibrary.simpleMessage(
      "Confirmar nueva contraseña",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage(
      "Confirmar contraseña",
    ),
    "confirm_pay": MessageLookupByLibrary.simpleMessage("Confirmar pago"),
    "confirm_pickup": MessageLookupByLibrary.simpleMessage(
      "Confirmar recogida",
    ),
    "connection_error_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Error de conexión con el servidor API",
    ),
    "connection_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Tiempo de conexión agotado con el servidor API",
    ),
    "contact_support": MessageLookupByLibrary.simpleMessage(
      "Contactar Soporte",
    ),
    "country": MessageLookupByLibrary.simpleMessage("País"),
    "current_balance": MessageLookupByLibrary.simpleMessage("Saldo actual"),
    "current_password": MessageLookupByLibrary.simpleMessage(
      "Contraseña actual",
    ),
    "cvv": MessageLookupByLibrary.simpleMessage("CVV"),
    "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "delete_account": MessageLookupByLibrary.simpleMessage("Eliminar cuenta"),
    "delete_account_confirmation": MessageLookupByLibrary.simpleMessage(
      "¿Está seguro de que desea eliminar su cuenta?",
    ),
    "delete_account_warning": MessageLookupByLibrary.simpleMessage(
      "Esta acción es permanente y no se puede deshacer.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destino"),
    "details": MessageLookupByLibrary.simpleMessage("Detalles"),
    "discount": MessageLookupByLibrary.simpleMessage("Descuento"),
    "double_check_rider": MessageLookupByLibrary.simpleMessage(
      "Verifica el nombre del pasajero y confirma su destino antes de continuar.",
    ),
    "driver_documents": MessageLookupByLibrary.simpleMessage(
      "Documentos del conductor",
    ),
    "driving_license": MessageLookupByLibrary.simpleMessage(
      "Licencia de conducir",
    ),
    "driving_license_required": MessageLookupByLibrary.simpleMessage(
      "Licencia de conducir requerida",
    ),
    "either_phone_number_is_null_or_password_is_empty":
        MessageLookupByLibrary.simpleMessage(
          "Número de teléfono vacío o contraseña vacía",
        ),
    "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "email_label": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "emergency_phone": MessageLookupByLibrary.simpleMessage(
      "Teléfono de emergencia",
    ),
    "enterPhoneDes": MessageLookupByLibrary.simpleMessage(
      "Ingresa tu número de teléfono para continuar tu viaje y mantenerte informado.",
    ),
    "enterPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Ingrese el número de teléfono",
    ),
    "enter_3_digit_cvv": MessageLookupByLibrary.simpleMessage(
      "Ingrese el CVV de 3 dígitos",
    ),
    "enter_a_valid_amount": MessageLookupByLibrary.simpleMessage(
      "Ingrese un monto válido",
    ),
    "enter_amount": MessageLookupByLibrary.simpleMessage("Ingrese monto"),
    "enter_cardholder_name": MessageLookupByLibrary.simpleMessage(
      "Ingrese el nombre del titular de la tarjeta",
    ),
    "enter_details_complete_profile": MessageLookupByLibrary.simpleMessage(
      "Ingrese sus datos para completar su perfil y mejorar su experiencia.",
    ),
    "enter_experience": MessageLookupByLibrary.simpleMessage(
      "¡Escribe tu experiencia!",
    ),
    "enter_password": MessageLookupByLibrary.simpleMessage(
      "Ingresa tu contraseña",
    ),
    "enter_password_description": MessageLookupByLibrary.simpleMessage(
      "Por favor, ingresa la contraseña de tu cuenta para continuar.",
    ),
    "enter_plate_number": MessageLookupByLibrary.simpleMessage(
      "Ingrese el número de placa",
    ),
    "enter_valid_card_number": MessageLookupByLibrary.simpleMessage(
      "Ingrese un número de tarjeta válido",
    ),
    "enter_vehicle_name": MessageLookupByLibrary.simpleMessage(
      "Ingrese el nombre del vehículo",
    ),
    "error_with_msg": m2,
    "estimated_time": MessageLookupByLibrary.simpleMessage("Tiempo estimado"),
    "exit": MessageLookupByLibrary.simpleMessage("Salir"),
    "exp_date": MessageLookupByLibrary.simpleMessage("Fecha de expiración"),
    "expiryDate": MessageLookupByLibrary.simpleMessage("Fecha de caducidad"),
    "field_required": MessageLookupByLibrary.simpleMessage(
      "Este campo es obligatorio",
    ),
    "find_you_faster": MessageLookupByLibrary.simpleMessage(
      "¡Vamos a encontrarte más rápido!",
    ),
    "find_you_faster_msg": MessageLookupByLibrary.simpleMessage(
      "Activa la ubicación para conectarte con conductores cercanos fácilmente.",
    ),
    "follow_directions_comfortable": MessageLookupByLibrary.simpleMessage(
      "Sigue las indicaciones, mantente tranquilo y crea un ambiente de viaje cómodo.",
    ),
    "forbidden_access_please_login_again": MessageLookupByLibrary.simpleMessage(
      "Acceso prohibido. Por favor inicia sesión nuevamente.",
    ),
    "form_is_not_valid": MessageLookupByLibrary.simpleMessage(
      "El formulario no es válido",
    ),
    "full_name": MessageLookupByLibrary.simpleMessage("Nombre completo"),
    "gender": MessageLookupByLibrary.simpleMessage("Género"),
    "gender_female": MessageLookupByLibrary.simpleMessage("Femenino"),
    "gender_label": MessageLookupByLibrary.simpleMessage("Género"),
    "gender_male": MessageLookupByLibrary.simpleMessage("Masculino"),
    "gender_other": MessageLookupByLibrary.simpleMessage("Otro"),
    "gender_required": MessageLookupByLibrary.simpleMessage(
      "El género es obligatorio",
    ),
    "gender_select": MessageLookupByLibrary.simpleMessage("Seleccionar género"),
    "go_back_to_ride": MessageLookupByLibrary.simpleMessage("Volver al viaje"),
    "go_to_login": MessageLookupByLibrary.simpleMessage("Ir a Iniciar sesión"),
    "go_to_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Ir al punto de recogida",
    ),
    "grant_permission": MessageLookupByLibrary.simpleMessage(
      "Conceder permiso",
    ),
    "helloText": MessageLookupByLibrary.simpleMessage("Hola..."),
    "home": MessageLookupByLibrary.simpleMessage("Inicio"),
    "id": MessageLookupByLibrary.simpleMessage("ID: "),
    "initializing": MessageLookupByLibrary.simpleMessage("Inicializando..."),
    "insertAllData": MessageLookupByLibrary.simpleMessage(
      "Por favor ingrese todos los datos",
    ),
    "internal_server_error": MessageLookupByLibrary.simpleMessage(
      "Error interno del servidor",
    ),
    "issueSubmitted": MessageLookupByLibrary.simpleMessage(
      "Tu problema se envió con éxito",
    ),
    "km": MessageLookupByLibrary.simpleMessage("km"),
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "lets_ride": MessageLookupByLibrary.simpleMessage("Vamos a rodar"),
    "location": MessageLookupByLibrary.simpleMessage("Ubicación"),
    "location_permission_msg": MessageLookupByLibrary.simpleMessage(
      "Por favor, habilita el acceso a la ubicación para usar esta función.",
    ),
    "location_permission_needed": MessageLookupByLibrary.simpleMessage(
      "Permiso de ubicación necesario",
    ),
    "log_out": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "loggingInSomewhereElse": MessageLookupByLibrary.simpleMessage(
      "Iniciando sesión en otro lugar",
    ),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "loginSignup": MessageLookupByLibrary.simpleMessage(
      "Iniciar sesión / Registrarse",
    ),
    "login_with_your_password": MessageLookupByLibrary.simpleMessage(
      "Iniciar sesión con su contraseña",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Método: "),
    "min": MessageLookupByLibrary.simpleMessage("min"),
    "min_length_error": m3,
    "mobile_number": MessageLookupByLibrary.simpleMessage("Número de móvil"),
    "my_profile": MessageLookupByLibrary.simpleMessage("Mi perfil"),
    "name_label": MessageLookupByLibrary.simpleMessage("Nombre"),
    "new_password": MessageLookupByLibrary.simpleMessage("Nueva contraseña"),
    "next": MessageLookupByLibrary.simpleMessage("Siguiente"),
    "nid_image_required": MessageLookupByLibrary.simpleMessage(
      "Imagen del NID requerida",
    ),
    "nid_photo": MessageLookupByLibrary.simpleMessage(
      "Foto de identificación nacional",
    ),
    "no_address_found": MessageLookupByLibrary.simpleMessage(
      "No se encontró dirección",
    ),
    "no_cards_yet": MessageLookupByLibrary.simpleMessage(
      "¡Aún no hay tarjetas!",
    ),
    "no_internet_connection": MessageLookupByLibrary.simpleMessage(
      "Sin conexión a Internet.",
    ),
    "no_internet_connection_please_check": MessageLookupByLibrary.simpleMessage(
      "Sin conexión a Internet. Por favor verifica tu conexión.",
    ),
    "no_payment_methods_available": MessageLookupByLibrary.simpleMessage(
      "No hay métodos de pago disponibles",
    ),
    "no_rides_yet": MessageLookupByLibrary.simpleMessage("Aún no hay viajes."),
    "no_service_available": MessageLookupByLibrary.simpleMessage(
      "No hay servicio disponible",
    ),
    "no_transactions_found": MessageLookupByLibrary.simpleMessage(
      "No se encontraron transacciones",
    ),
    "no_wallet_data_available": MessageLookupByLibrary.simpleMessage(
      "No hay datos de la billetera disponibles",
    ),
    "offline": MessageLookupByLibrary.simpleMessage("Desconectado"),
    "or_select_avatar": MessageLookupByLibrary.simpleMessage(
      "O seleccione un avatar de la lista a continuación:",
    ),
    "otp_enter_title": MessageLookupByLibrary.simpleMessage("Introduce tu OTP"),
    "otp_input_hint": MessageLookupByLibrary.simpleMessage("Escribe tu OTP"),
    "otp_resend": MessageLookupByLibrary.simpleMessage("Reenviar"),
    "otp_resend_timer": m4,
    "otp_save_button": MessageLookupByLibrary.simpleMessage("Guardar"),
    "otp_sent_message": MessageLookupByLibrary.simpleMessage(
      "Hemos enviado un código OTP a tu número de teléfono",
    ),
    "otp_title_short": MessageLookupByLibrary.simpleMessage("OTP"),
    "password_hint": MessageLookupByLibrary.simpleMessage(
      "Establece una contraseña segura",
    ),
    "password_label": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "password_mismatch": MessageLookupByLibrary.simpleMessage(
      "Las contraseñas no coinciden.",
    ),
    "password_requirements": m5,
    "payment_completed": MessageLookupByLibrary.simpleMessage(
      "¡Gracias! Pago completado",
    ),
    "payment_confirmation": m6,
    "payment_gateway": MessageLookupByLibrary.simpleMessage("Pasarela de pago"),
    "payment_method": MessageLookupByLibrary.simpleMessage("Método de pago"),
    "payment_received": MessageLookupByLibrary.simpleMessage("Pago recibido"),
    "payment_withdraw": MessageLookupByLibrary.simpleMessage("Retiro de pago"),
    "payout_method": MessageLookupByLibrary.simpleMessage("Método de pago"),
    "personal_info": MessageLookupByLibrary.simpleMessage(
      "Información personal",
    ),
    "phoneMinLengthError": MessageLookupByLibrary.simpleMessage(
      "El número de teléfono debe tener al menos 6 dígitos",
    ),
    "phoneNo": MessageLookupByLibrary.simpleMessage("Número de teléfono"),
    "pickFromGallery": MessageLookupByLibrary.simpleMessage(
      "Elegir de la galería",
    ),
    "pick_a_date": MessageLookupByLibrary.simpleMessage("Elija una fecha"),
    "pickup": MessageLookupByLibrary.simpleMessage("Recogida"),
    "pickup_rider": MessageLookupByLibrary.simpleMessage("Recoger pasajero"),
    "plate_number": MessageLookupByLibrary.simpleMessage("Número de placa"),
    "please_enter_amount": MessageLookupByLibrary.simpleMessage(
      "Por favor ingrese la cantidad",
    ),
    "please_select_payment_type": MessageLookupByLibrary.simpleMessage(
      "Por favor selecciona un tipo de pago",
    ),
    "please_wait": MessageLookupByLibrary.simpleMessage("Por favor espera..."),
    "privacy_policy": MessageLookupByLibrary.simpleMessage(
      "Política de privacidad",
    ),
    "production_year": MessageLookupByLibrary.simpleMessage(
      "Año de producción",
    ),
    "profile_image": MessageLookupByLibrary.simpleMessage("Imagen de perfil"),
    "profile_image_required": MessageLookupByLibrary.simpleMessage(
      "La imagen de perfil es obligatoria",
    ),
    "profile_submitted_reviewed": MessageLookupByLibrary.simpleMessage(
      "Tu perfil ha sido enviado y está siendo revisado. Se te notificará cuando sea aprobado.",
    ),
    "profile_under_review": MessageLookupByLibrary.simpleMessage(
      "Tu perfil está en revisión",
    ),
    "reached_destination": MessageLookupByLibrary.simpleMessage(
      "Destino alcanzado",
    ),
    "reached_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "Has llegado al destino del pasajero.",
    ),
    "reached_pickup_wait": MessageLookupByLibrary.simpleMessage(
      "Has llegado al lugar de recogida. Por favor espera unos minutos para que el pasajero se acerque a tu vehículo.",
    ),
    "receive_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Tiempo de espera agotado al recibir datos del servidor API",
    ),
    "received_invalid_response_from_server":
        MessageLookupByLibrary.simpleMessage(
          "Se recibió una respuesta inválida del servidor.",
        ),
    "registration_done": MessageLookupByLibrary.simpleMessage(
      "¡Registro COMPLETADO!",
    ),
    "reportIssue": MessageLookupByLibrary.simpleMessage("Reportar un problema"),
    "reportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Cuéntanos qué ocurrió. Lo revisaremos de inmediato.",
    ),
    "reportIssueTitle": MessageLookupByLibrary.simpleMessage(
      "¿Algo salió mal? Reporta un problema",
    ),
    "reportType": MessageLookupByLibrary.simpleMessage("Tipo de reporte"),
    "requestEntityTooLarge": MessageLookupByLibrary.simpleMessage(
      "Entidad de solicitud demasiado grande",
    ),
    "request_timed_out_please_try_again": MessageLookupByLibrary.simpleMessage(
      "La solicitud expiró. Por favor intenta de nuevo.",
    ),
    "request_to_api_server_was_cancelled": MessageLookupByLibrary.simpleMessage(
      "Solicitud al servidor API fue cancelada",
    ),
    "resource_not_found": MessageLookupByLibrary.simpleMessage(
      "Recurso no encontrado.",
    ),
    "rideCharge": MessageLookupByLibrary.simpleMessage("Tarifa del viaje"),
    "rideDetails": MessageLookupByLibrary.simpleMessage("Detalles del viaje"),
    "ride_complete": MessageLookupByLibrary.simpleMessage(
      "Tu viaje ha terminado",
    ),
    "ride_feedback_prompt": MessageLookupByLibrary.simpleMessage(
      "Esperamos que hayas tenido un buen viaje. Por favor, completa el pago y califica tu experiencia.",
    ),
    "ride_history": MessageLookupByLibrary.simpleMessage("Historial de viajes"),
    "ride_preferences": MessageLookupByLibrary.simpleMessage(
      "Preferencias de viaje",
    ),
    "ride_preferences_description": MessageLookupByLibrary.simpleMessage(
      "Selecciona el tipo de viaje que mejor se adapte a tus necesidades.",
    ),
    "ride_requested": MessageLookupByLibrary.simpleMessage("Viaje solicitado"),
    "ride_started": MessageLookupByLibrary.simpleMessage(
      "¡Tu viaje ha comenzado!",
    ),
    "rider_waiting_move_now": MessageLookupByLibrary.simpleMessage(
      "Pasajero esperando — Mueve ahora",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "searching_for_driver": MessageLookupByLibrary.simpleMessage(
      "Buscando un conductor en línea..",
    ),
    "see_you_next_ride": MessageLookupByLibrary.simpleMessage(
      "¡Esperamos verte pronto en tu próximo viaje!",
    ),
    "selectReportType": MessageLookupByLibrary.simpleMessage(
      "Selecciona el tipo de reporte",
    ),
    "select_a_country": MessageLookupByLibrary.simpleMessage(
      "Seleccione un país",
    ),
    "select_card_type": MessageLookupByLibrary.simpleMessage(
      "Selecciona tipo de tarjeta",
    ),
    "select_payment_method": MessageLookupByLibrary.simpleMessage(
      "Seleccionar método de pago",
    ),
    "select_pickup_location": MessageLookupByLibrary.simpleMessage(
      "Seleccionar lugar de recogida",
    ),
    "select_profile_image": MessageLookupByLibrary.simpleMessage(
      "Seleccionar imagen de perfil",
    ),
    "select_service": MessageLookupByLibrary.simpleMessage(
      "¡Selecciona un servicio!",
    ),
    "select_vehicle_color": MessageLookupByLibrary.simpleMessage(
      "Seleccione el color del vehículo",
    ),
    "select_vehicle_type": MessageLookupByLibrary.simpleMessage(
      "Seleccione el tipo de vehículo",
    ),
    "send_timeout_with_api_server": MessageLookupByLibrary.simpleMessage(
      "Tiempo de espera agotado al enviar datos al servidor API",
    ),
    "service_charge": MessageLookupByLibrary.simpleMessage(
      "Cargo por servicio",
    ),
    "share_experience": MessageLookupByLibrary.simpleMessage(
      "¡Comparte tu experiencia!",
    ),
    "skip_for_now": MessageLookupByLibrary.simpleMessage("Saltar por ahora"),
    "something_went_wrong": MessageLookupByLibrary.simpleMessage(
      "Algo salió mal",
    ),
    "something_went_wrong_exclamation": MessageLookupByLibrary.simpleMessage(
      "¡Algo salió mal!",
    ),
    "start_journey_navigation": MessageLookupByLibrary.simpleMessage(
      "Comienza el viaje siguiendo la navegación en la app. Asegúrate de que ambas partes estén cómodas antes de iniciar.",
    ),
    "start_ride": MessageLookupByLibrary.simpleMessage("Iniciar viaje"),
    "status": MessageLookupByLibrary.simpleMessage("Estado"),
    "stayOnThisDevice": MessageLookupByLibrary.simpleMessage(
      "Permanecer en este dispositivo",
    ),
    "stop_point": MessageLookupByLibrary.simpleMessage("Punto de parada"),
    "submit": MessageLookupByLibrary.simpleMessage("Enviar"),
    "takeAPhoto": MessageLookupByLibrary.simpleMessage("Tomar una foto"),
    "tap_to_confirm_arrival": MessageLookupByLibrary.simpleMessage(
      "Toca para confirmar tu llegada",
    ),
    "tap_to_start_ride": MessageLookupByLibrary.simpleMessage(
      "Toca para iniciar el viaje",
    ),
    "terms_conditions": MessageLookupByLibrary.simpleMessage(
      "Términos y condiciones",
    ),
    "textCopied": MessageLookupByLibrary.simpleMessage("Texto copiado"),
    "thanksForReporting": MessageLookupByLibrary.simpleMessage(
      "Gracias por reportar. Nuestro equipo revisará tu problema y se pondrá en contacto contigo pronto.",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Tema"),
    "time_to_pickup": MessageLookupByLibrary.simpleMessage(
      "¡Hora de recoger a tu pasajero! Sigue la navegación y llega sin demora",
    ),
    "today": MessageLookupByLibrary.simpleMessage("Hoy"),
    "todays_activity": MessageLookupByLibrary.simpleMessage("Actividad de hoy"),
    "todays_earning": MessageLookupByLibrary.simpleMessage("Ganancias de hoy"),
    "top_up_your_wallet_securely_and_enjoy_seamless_payments":
        MessageLookupByLibrary.simpleMessage(
          "Recarga tu billetera de forma segura y disfruta de pagos sin interrupciones.",
        ),
    "total_amount": MessageLookupByLibrary.simpleMessage("Importe total"),
    "total_distance": MessageLookupByLibrary.simpleMessage("Distancia total"),
    "total_rides": MessageLookupByLibrary.simpleMessage("Viajes totales"),
    "transactions": MessageLookupByLibrary.simpleMessage("Transacciones"),
    "trip_ended_passenger_destination": MessageLookupByLibrary.simpleMessage(
      "El viaje ha terminado ya que el pasajero ha llegado a su destino.",
    ),
    "trip_ended_wait_payment": MessageLookupByLibrary.simpleMessage(
      "El viaje ha terminado. Espera a que el pasajero complete el pago antes de cerrar el viaje.",
    ),
    "trips": MessageLookupByLibrary.simpleMessage("Viajes"),
    "type_a_message": MessageLookupByLibrary.simpleMessage(
      "Escribe un mensaje",
    ),
    "unauthorized_access_please_login_again":
        MessageLookupByLibrary.simpleMessage(
          "Acceso no autorizado. Por favor inicia sesión nuevamente.",
        ),
    "unexpected_application_crash": MessageLookupByLibrary.simpleMessage(
      "Fallo inesperado de la aplicación",
    ),
    "unexpected_error_occurred": MessageLookupByLibrary.simpleMessage(
      "Ocurrió un error inesperado",
    ),
    "unexpected_response_format": MessageLookupByLibrary.simpleMessage(
      "Formato de respuesta inesperado",
    ),
    "update": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "upload": MessageLookupByLibrary.simpleMessage("Subir"),
    "upload_driver_documents": MessageLookupByLibrary.simpleMessage(
      "Suba sus documentos de conductor para completar la verificación y comenzar a conducir. ¡Rápido, fácil y seguro!",
    ),
    "upload_image": MessageLookupByLibrary.simpleMessage("Subir imagen"),
    "use_otp_instead": MessageLookupByLibrary.simpleMessage(
      "Usar OTP en su lugar",
    ),
    "use_your_password_here": MessageLookupByLibrary.simpleMessage(
      "Use su contraseña aquí",
    ),
    "validation_error": MessageLookupByLibrary.simpleMessage(
      "Error de validación",
    ),
    "vehicle_color": MessageLookupByLibrary.simpleMessage("Color del vehículo"),
    "vehicle_name": MessageLookupByLibrary.simpleMessage("Nombre del vehículo"),
    "vehicle_papers": MessageLookupByLibrary.simpleMessage(
      "Documentos del vehículo",
    ),
    "vehicle_papers_required": MessageLookupByLibrary.simpleMessage(
      "Documentos del vehículo requeridos",
    ),
    "vehicle_plate_number": MessageLookupByLibrary.simpleMessage(
      "Número de placa del vehículo",
    ),
    "vehicle_production_year": MessageLookupByLibrary.simpleMessage(
      "Año de producción del vehículo",
    ),
    "vehicle_type": MessageLookupByLibrary.simpleMessage("Tipo de vehículo"),
    "view_all": MessageLookupByLibrary.simpleMessage("Ver todo"),
    "wallet": MessageLookupByLibrary.simpleMessage("Billetera"),
    "wallet_balance": MessageLookupByLibrary.simpleMessage(
      "Saldo de la billetera",
    ),
    "welcomeBack": MessageLookupByLibrary.simpleMessage(
      "¡Bienvenido de nuevo!",
    ),
    "withdraw": MessageLookupByLibrary.simpleMessage("Retirar"),
    "withdraw_history": MessageLookupByLibrary.simpleMessage(
      "Historial de retiros",
    ),
    "withdraw_instruction": MessageLookupByLibrary.simpleMessage(
      "¡Te lo has ganado! Elige dónde quieres enviar tu dinero y pulsa retirar.",
    ),
    "withdraw_your_earnings": MessageLookupByLibrary.simpleMessage(
      "Retira tus ganancias",
    ),
    "withdrawal_request_success": m7,
    "withdrawal_success": MessageLookupByLibrary.simpleMessage(
      "¡Solicitud de retiro enviada con éxito!",
    ),
    "writeIssueDetails": MessageLookupByLibrary.simpleMessage(
      "Escribe los detalles del problema",
    ),
    "you_can_cancel_ride_in": MessageLookupByLibrary.simpleMessage(
      "Puedes cancelar el viaje en",
    ),
    "yourAccountAlreadyActive": MessageLookupByLibrary.simpleMessage(
      "Su cuenta ya está activa en otro dispositivo. Para usarla aquí, se cerrará la sesión en el otro dispositivo.",
    ),
    "your_balance": MessageLookupByLibrary.simpleMessage("Tu saldo"),
    "your_best_photo_here": MessageLookupByLibrary.simpleMessage(
      "Tu mejor foto aquí",
    ),
    "your_ride_complete": MessageLookupByLibrary.simpleMessage(
      "Viaje completado",
    ),
  };
}
